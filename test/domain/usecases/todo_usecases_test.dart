import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/core/result/result.dart';
import 'package:todo_app/domain/entities/todo_entity.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';
import 'package:todo_app/domain/usecases/todo_usecases.dart';

import 'todo_usecases_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late TodoUseCases useCases;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCases = TodoUseCases(repository: mockRepository);
  });

  group('TodoUseCases', () {
    final testTodos = [
      const TodoEntity(id: 1, todo: 'Test Todo 1', completed: false, userId: 1),
      const TodoEntity(id: 2, todo: 'Test Todo 2', completed: true, userId: 1),
    ];

    test('should get todos from repository', () async {
      // Arrange
      when(mockRepository.getTodos())
          .thenAnswer((_) async => Result.success(testTodos));

      // Act
      final result = await useCases.getTodos();

      // Assert
      expect(result, equals(testTodos));
      verify(mockRepository.getTodos()).called(1);
    });

    test('should get todo by id from repository', () async {
      // Arrange
      when(mockRepository.getTodoById(1))
          .thenAnswer((_) async => Result.success(testTodos[0]));

      // Act
      final result = await useCases.getTodoById(1);

      // Assert
      expect(result, equals(testTodos[0]));
      verify(mockRepository.getTodoById(1)).called(1);
    });

    test('should toggle todo completion calls updateTodo in repository', () async {
      // Arrange
      final todo = testTodos[0];
      final updatedTodo = todo.copyWith(completed: true);
      when(mockRepository.updateTodo(any))
          .thenAnswer((_) async => Result.success(updatedTodo));

      // Act
      final result = await useCases.toggleTodoCompletion(todo);

      // Assert
      expect(result, equals(updatedTodo));
      verify(mockRepository.updateTodo(argThat(
        predicate<TodoEntity>((t) => t.id == todo.id && t.completed == !todo.completed)
      ))).called(1);
    });

    test('should create new todo in repository', () async {
      // Arrange
      const newTodo = TodoEntity(id: 3, todo: 'New Todo', completed: false, userId: 1);
      when(mockRepository.createTodo(any))
          .thenAnswer((_) async => Result.success(newTodo));

      // Act
      final result = await useCases.createTodo('New Todo');

      // Assert
      expect(result, equals(newTodo));
      verify(mockRepository.createTodo('New Todo')).called(1);
    });

    test('should delete todo in repository', () async {
      // Arrange
      when(mockRepository.deleteTodo(1))
          .thenAnswer((_) async => Result.success(true));

      // Act
      final result = await useCases.deleteTodo(1);

      // Assert
      expect(result, equals(true));
      verify(mockRepository.deleteTodo(1)).called(1);
    });

    test('should update todo in repository', () async {
      // Arrange
      const updatedTodo = TodoEntity(
        id: 1,
        todo: 'Updated Todo',
        completed: true,
        userId: 1,
      );
      when(mockRepository.updateTodo(any))
          .thenAnswer((_) async => Result.success(updatedTodo));

      // Act
      final result = await useCases.updateTodo(updatedTodo);

      // Assert
      expect(result, equals(updatedTodo));
      verify(mockRepository.updateTodo(updatedTodo)).called(1);
    });
  });
}
