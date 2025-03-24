import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';
import 'package:todo_app/domain/usecases/todo_usecases.dart';
import 'package:todo_app/providers/todo_provider.dart';

// Mock implementation of TodoRepository for integration testing
class MockTodoRepository implements TodoRepository {
  List<Todo> _todos = [];
  int _nextId = 1;

  @override
  Future<List<Todo>> getTodos() async {
    return Future.value(_todos);
  }

  @override
  Future<Todo> getTodoById(int id) async {
    final todo = _todos.firstWhere(
      (todo) => todo.id == id,
      orElse: () => throw Exception('Todo not found'),
    );
    return Future.value(todo);
  }

  @override
  Future<Todo> addTodo(String title) async {
    final newTodo = Todo(
      id: _nextId++,
      todo: title,
      completed: false,
      userId: 1,
    );
    _todos.add(newTodo);
    return Future.value(newTodo);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index >= 0) {
      _todos[index] = todo;
    } else {
      throw Exception('Todo not found');
    }
  }

  @override
  Future<void> deleteTodo(int id) async {
    _todos.removeWhere((todo) => todo.id == id);
  }

  @override
  Future<void> dispose() async {
    // No resources to dispose
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
