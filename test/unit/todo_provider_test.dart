import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/usecases/todo_usecases.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'todo_provider_test.mocks.dart';

@GenerateMocks([TodoUseCases])
void main() {
  late TodoProvider provider;
  late MockTodoUseCases mockUseCases;

  setUp(() {
    mockUseCases = MockTodoUseCases();
    provider = TodoProvider(useCases: mockUseCases);
  });

  group('TodoProvider', () {
    test('should load todos successfully', () async {
      final todos = [
        Todo(id: 1, todo: 'Test Todo 1', completed: false, userId: 1),
        Todo(id: 2, todo: 'Test Todo 2', completed: true, userId: 1),
      ];
      when(mockUseCases.getTodos()).thenAnswer((_) async => todos);

      await provider.fetchTodos();

      expect(provider.todos, equals(todos));
      expect(provider.isLoading, equals(false));
      expect(provider.error, isNull);
      verify(mockUseCases.getTodos()).called(1);
    });

    test('should handle error when loading todos', () async {
      when(mockUseCases.getTodos()).thenThrow(Exception('Test error'));

      await provider.fetchTodos();

      expect(provider.todos, isEmpty);
      expect(provider.isLoading, equals(false));
      expect(provider.error, equals('Exception: Test error'));
      verify(mockUseCases.getTodos()).called(1);
    });

    test('should find todo by id successfully', () {
      final todo = Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1);
      provider.todos = [todo];

      final result = provider.findTodoById(1);

      expect(result, equals(todo));
    });

    test('should return null when finding non-existent todo by id', () {
      provider.todos = [];

      final result = provider.findTodoById(1);

      expect(result, isNull);
    });

    test('should get todo by id successfully', () async {
      final todo = Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1);
      when(mockUseCases.getTodoById(1)).thenAnswer((_) async => todo);

      final result = await provider.getTodoById(1);

      expect(result, equals(todo));
      verify(mockUseCases.getTodoById(1)).called(1);
    });

    test('should handle error when getting todo by id', () async {
      when(mockUseCases.getTodoById(1)).thenThrow(Exception('Test error'));

      final result = await provider.getTodoById(1);

      expect(result, isNull);
      expect(provider.error, equals('Exception: Test error'));
      verify(mockUseCases.getTodoById(1)).called(1);
    });

    test('should add todo successfully', () async {
      await provider.addTodo('New Todo');

      expect(provider.todos.length, equals(1));
      expect(provider.todos[0].todo, equals('New Todo'));
      expect(provider.todos[0].completed, equals(false));
    });

    test('should not add empty todo', () async {
      await provider.addTodo('  ');

      expect(provider.todos, isEmpty);
      expect(provider.error, equals('Task description cannot be empty'));
    });

    test('should update todo successfully', () async {
      // Add a todo first
      final originalTodo = Todo(
        id: 1,
        todo: 'Original Todo',
        completed: false,
        userId: 1,
      );
      provider.todos = [originalTodo];

      // Update it
      final updatedTodo = Todo(
        id: 1,
        todo: 'Updated Todo',
        completed: true,
        userId: 1,
      );
      await provider.updateTodo(updatedTodo);

      expect(provider.todos.length, equals(1));
      expect(provider.todos[0].todo, equals('Updated Todo'));
      expect(provider.todos[0].completed, equals(true));
    });

    test('should toggle todo completion successfully', () async {
      // Add a todo first
      final originalTodo = Todo(
        id: 1,
        todo: 'Test Todo',
        completed: false,
        userId: 1,
      );
      provider.todos = [originalTodo];

      // Toggle completion
      await provider.toggleTodoCompletion(originalTodo);

      expect(provider.todos.length, equals(1));
      expect(provider.todos[0].todo, equals('Test Todo'));
      expect(provider.todos[0].completed, equals(true));
    });

    test('should delete todo successfully', () async {
      // Add a todo first
      final todo = Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1);
      provider.todos = [todo];

      // Delete it
      await provider.deleteTodo(1);

      expect(provider.todos, isEmpty);
    });

    test('should dispose use cases', () {
      provider.dispose();
      verify(mockUseCases.dispose()).called(1);
    });

    test('should get completed todos', () {
      final todos = [
        Todo(id: 1, todo: 'Test Todo 1', completed: true, userId: 1),
        Todo(id: 2, todo: 'Test Todo 2', completed: false, userId: 1),
        Todo(id: 3, todo: 'Test Todo 3', completed: true, userId: 1),
      ];
      provider.todos = todos;

      expect(provider.completedTodos, equals([todos[0], todos[2]]));
    });

    test('should get incomplete todos', () {
      final todos = [
        Todo(id: 1, todo: 'Test Todo 1', completed: true, userId: 1),
        Todo(id: 2, todo: 'Test Todo 2', completed: false, userId: 1),
        Todo(id: 3, todo: 'Test Todo 3', completed: true, userId: 1),
      ];
      provider.todos = todos;

      expect(provider.incompleteTodos, equals([todos[1]]));
    });
  });
}
