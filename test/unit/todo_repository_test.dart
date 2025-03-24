import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/repositories/todo_repository.dart';
import 'package:todo_app/services/todo_service.dart';

// Mock para TodoService
class MockTodoService implements TodoService {
  String baseUrl = 'https://dummyjson.com';
  bool disposeCalled = false;
  List<Todo>? todosToReturn;
  Todo? todoToReturn;
  Exception? exceptionToThrow;

  @override
  Future<List<Todo>> getTodos() async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return todosToReturn ?? [];
  }

  @override
  Future<Todo> getTodoById(int id) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return todoToReturn ??
        Todo(id: id, todo: 'Default', completed: false, userId: 1);
  }

  @override
  void dispose() {
    disposeCalled = true;
  }
}

void main() {
  late TodoRepository repository;
  late MockTodoService mockService;

  setUp(() {
    mockService = MockTodoService();
    repository = TodoRepository(todoService: mockService);
  });

  group('TodoRepository', () {
    test('fetchTodos delegates to TodoService', () async {
      // Setup mock data
      mockService.todosToReturn = [
        Todo(id: 1, todo: 'Test Todo 1', completed: false, userId: 1),
        Todo(id: 2, todo: 'Test Todo 2', completed: true, userId: 1)
      ];

      // Call the method
      final todos = await repository.fetchTodos();

      // Verify
      expect(todos, equals(mockService.todosToReturn));
      expect(todos.length, equals(2));
    });

    test('fetchTodoById delegates to TodoService', () async {
      // Setup mock data
      mockService.todoToReturn =
          Todo(id: 1, todo: 'Test Todo 1', completed: false, userId: 1);

      // Call the method
      final todo = await repository.fetchTodoById(1);

      // Verify
      expect(todo, equals(mockService.todoToReturn));
      expect(todo.id, equals(1));
    });

    test('fetchTodos throws when TodoService throws', () async {
      // Setup mock to throw
      mockService.exceptionToThrow = Exception('Test error');

      // Verify exception is propagated
      expect(() => repository.fetchTodos(), throwsException);
    });

    test('dispose calls dispose on the TodoService', () {
      // Call the method
      repository.dispose();

      // Verify
      expect(mockService.disposeCalled, isTrue);
    });
  });
}
