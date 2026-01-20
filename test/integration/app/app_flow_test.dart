import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/core/result/result.dart';
import 'package:todo_app/domain/entities/todo_entity.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';
import 'package:todo_app/domain/usecases/todo_usecases.dart';
import 'package:todo_app/presentation/providers/todo_provider.dart';

// Mock implementation of TodoRepository for integration testing
class MockTodoRepository implements TodoRepository {
  final List<TodoEntity> _todos = [];
  int _nextId = 1;

  @override
  Future<Result<List<TodoEntity>>> getTodos() async {
    return Result.success(_todos);
  }

  @override
  Future<Result<TodoEntity>> getTodoById(int id) async {
    try {
      final todo = _todos.firstWhere((todo) => todo.id == id);
      return Result.success(todo);
    } catch (e) {
      return Result.failure(const ServerFailure());
    }
  }

  @override
  Future<Result<TodoEntity>> createTodo(String title) async {
    final newTodo = TodoEntity(
      id: _nextId++,
      todo: title,
      completed: false,
      userId: 1,
    );
    _todos.add(newTodo);
    return Result.success(newTodo);
  }

  @override
  Future<Result<TodoEntity>> updateTodo(TodoEntity todo) async {
    try {
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index >= 0) {
        _todos[index] = todo;
        return Result.success(todo);
      }
      return Result.failure(const ServerFailure());
    } catch (e) {
      return Result.failure(const ServerFailure());
    }
  }

  @override
  Future<Result<bool>> deleteTodo(int id) async {
    try {
      _todos.removeWhere((todo) => todo.id == id);
      return Result.success(true);
    } catch (e) {
      return Result.failure(const ServerFailure());
    }
  }
}

void main() {
  group('Todo App Integration Tests', () {
    test('Complete user flow with TodoProvider and Repository', () async {
      // Setup mock repository and use cases
      final repository = MockTodoRepository();
      final useCases = TodoUseCases(repository: repository);

      // Create TodoProvider with mock dependencies
      final todoProvider = TodoProvider(useCases: useCases);

      // Aguardar a inicialização completa do provider
      await Future.delayed(const Duration(milliseconds: 100));

      // Initial state - no todos
      expect(todoProvider.todos.isEmpty, true);

      // Step 1: Add a new todo
      await todoProvider.addTodo('Integration Test Todo');

      // Verify todo was added
      expect(todoProvider.todos.length, 1);
      expect(todoProvider.todos[0].todo, 'Integration Test Todo');
      expect(todoProvider.todos[0].completed, false);

      // Step 2: Toggle todo completion
      final todoToToggle = todoProvider.todos[0];
      await todoProvider.toggleTodoCompletion(todoToToggle);

      // Verify todo was marked as completed (using completedTodos list)
      expect(todoProvider.completedTodos.length, 1);
      expect(todoProvider.completedTodos[0].todo, 'Integration Test Todo');
      expect(todoProvider.completedTodos[0].completed, true);

      // Step 3: Verify completed and incomplete lists
      expect(todoProvider.completedTodos.length, 1);
      expect(todoProvider.incompleteTodos.length, 0);

      // Step 4: Delete the todo
      await todoProvider.deleteTodo(todoProvider.completedTodos[0].id);

      // Verify todo was deleted
      expect(todoProvider.todos.isEmpty, true);
    });
  });
}