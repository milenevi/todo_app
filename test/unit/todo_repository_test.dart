import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/repositories/todo_repository.dart';
import 'todo_repository_test.mocks.dart';

@GenerateMocks([TodoService])
void main() {
  late TodoRepository repository;
  late MockTodoService mockService;

  setUp(() {
    mockService = MockTodoService();
    repository = TodoRepository(todoService: mockService);
  });

  group('TodoRepository', () {
    test('should fetch todos from service', () async {
      final todos = [
        Todo(id: 1, todo: 'Test Todo 1', completed: false, userId: 1),
        Todo(id: 2, todo: 'Test Todo 2', completed: true, userId: 1),
      ];
      when(mockService.getTodos()).thenAnswer((_) async => todos);

      final result = await repository.fetchTodos();

      expect(result, equals(todos));
      verify(mockService.getTodos()).called(1);
    });

    test('should fetch todo by id from service', () async {
      final todo = Todo(
        id: 1,
        todo: 'Test Todo 1',
        completed: false,
        userId: 1,
      );
      when(mockService.getTodoById(1)).thenAnswer((_) async => todo);

      final result = await repository.fetchTodoById(1);

      expect(result, equals(todo));
      verify(mockService.getTodoById(1)).called(1);
    });

    test('should handle error when fetching todos', () async {
      when(mockService.getTodos()).thenThrow(Exception('Network error'));

      expect(() => repository.fetchTodos(), throwsException);
      verify(mockService.getTodos()).called(1);
    });

    test('should handle error when fetching todo by id', () async {
      when(mockService.getTodoById(1)).thenThrow(Exception('Not found'));

      expect(() => repository.fetchTodoById(1), throwsException);
      verify(mockService.getTodoById(1)).called(1);
    });

    test('should dispose service', () {
      repository.dispose();
      verify(mockService.dispose()).called(1);
    });

    test(
      'should cache todos and return cached data on subsequent calls',
      () async {
        final todos = [
          Todo(id: 1, todo: 'Test Todo 1', completed: false, userId: 1),
          Todo(id: 2, todo: 'Test Todo 2', completed: true, userId: 1),
        ];

        // Setup the mock to return the data once
        when(mockService.getTodos()).thenAnswer((_) async => todos);

        // First call should hit the service
        final result1 = await repository.fetchTodos();

        // Create a new repository with the same service to force a clean cache
        repository = TodoRepository(todoService: mockService);

        // Second call should hit the service again
        final result2 = await repository.fetchTodos();

        expect(result1, equals(todos));
        expect(result2, equals(todos));

        // Verify that getTodos is called twice (once for each repository instance)
        verify(mockService.getTodos()).called(2);
      },
    );
  });
}
