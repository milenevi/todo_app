import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/usecases/todo_usecases.dart';
import 'package:todo_app/providers/todo_provider.dart';

import 'todo_detail_controller_test.mocks.dart';

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
        Todo(id: 2, todo: 'Test Todo 2', completed: true, userId: 1)
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
      expect(provider.error, equals('Test error'));
      verify(mockUseCases.getTodos()).called(1);
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

      expect(() => provider.getTodoById(1), throwsException);
      verify(mockUseCases.getTodoById(1)).called(1);
    });

    test('should add todo successfully', () async {
      final todo = Todo(id: 1, todo: 'New Todo', completed: false, userId: 1);
      when(mockUseCases.addTodo(any)).thenAnswer((_) async => todo);

      await provider.addTodo('New Todo');

      expect(provider.todos, contains(todo));
      verify(mockUseCases.addTodo('New Todo')).called(1);
    });

    test('should handle error when adding todo', () async {
      when(mockUseCases.addTodo(any)).thenThrow(Exception('Test error'));

      await provider.addTodo('New Todo');

      expect(provider.error, equals('Test error'));
      verify(mockUseCases.addTodo('New Todo')).called(1);
    });

    test('should update todo successfully', () async {
      final todo =
      Todo(id: 1, todo: 'Updated Todo', completed: true, userId: 1);
      when(mockUseCases.updateTodo(any)).thenAnswer((_) async => todo);

      await provider.updateTodo(todo);

      expect(provider.todos, contains(todo));
      verify(mockUseCases.updateTodo(todo)).called(1);
    });

    test('should handle error when updating todo', () async {
      final todo = Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1);
      when(mockUseCases.updateTodo(any)).thenThrow(Exception('Test error'));

      await provider.updateTodo(todo);

      expect(provider.error, equals('Test error'));
      verify(mockUseCases.updateTodo(todo)).called(1);
    });

    test('should toggle todo completion successfully', () async {
      final todo = Todo(id: 1, todo: 'Test Todo', completed: true, userId: 1);
      when(mockUseCases.toggleTodoCompletion(any))
          .thenAnswer((_) async => todo);

      await provider.toggleTodoCompletion(todo);

      expect(provider.todos, contains(todo));
      verify(mockUseCases.toggleTodoCompletion(todo)).called(1);
    });

    test('should handle error when toggling todo completion', () async {
      final todo = Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1);
      when(mockUseCases.toggleTodoCompletion(any))
          .thenThrow(Exception('Test error'));

      await provider.toggleTodoCompletion(todo);

      expect(provider.error, equals('Test error'));
      verify(mockUseCases.toggleTodoCompletion(todo)).called(1);
    });

    test('should delete todo successfully', () async {
      final todo = Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1);
      when(mockUseCases.deleteTodo(any)).thenAnswer((_) async => true);

      await provider.deleteTodo(todo.id);

      expect(provider.todos, isNot(contains(todo)));
      verify(mockUseCases.deleteTodo(todo.id)).called(1);
    });

    test('should handle error when deleting todo', () async {
      final todo = Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1);
      when(mockUseCases.deleteTodo(any)).thenThrow(Exception('Test error'));

      await provider.deleteTodo(todo.id);

      expect(provider.error, equals('Test error'));
      verify(mockUseCases.deleteTodo(todo.id)).called(1);
    });

    test('should dispose use cases', () {
      provider.dispose();
      verify(mockUseCases.dispose()).called(1);
    });

    test('should get completed todos', () {
      final todos = [
        Todo(id: 1, todo: 'Test Todo 1', completed: true, userId: 1),
        Todo(id: 2, todo: 'Test Todo 2', completed: false, userId: 1),
        Todo(id: 3, todo: 'Test Todo 3', completed: true, userId: 1)
      ];
      provider.todos = todos;

      expect(provider.completedTodos, equals([todos[0], todos[2]]));
    });

    test('should get incomplete todos', () {
      final todos = [
        Todo(id: 1, todo: 'Test Todo 1', completed: true, userId: 1),
        Todo(id: 2, todo: 'Test Todo 2', completed: false, userId: 1),
        Todo(id: 3, todo: 'Test Todo 3', completed: true, userId: 1)
      ];
      provider.todos = todos;

      expect(provider.incompleteTodos, equals([todos[1]]));
    });
  });
}
