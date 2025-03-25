import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/core/result/result.dart';
import 'package:todo_app/domain/entities/todo_entity.dart';
import 'package:todo_app/domain/models/todo.dart';
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
      Todo(id: 1, todo: 'Test Todo 1', completed: false, userId: 1),
      Todo(id: 2, todo: 'Test Todo 2', completed: true, userId: 1),
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

    test('should get todo by id from local list', () async {
      // Arrange
      // Primeiro, precisamos preencher a lista local (isso é feito pelo método getTodos)
      when(mockRepository.getTodos())
          .thenAnswer((_) async => Result.success(testTodos));
      await useCases.getTodos();

      // Act
      final result = await useCases.getTodoById(1);

      // Assert
      expect(result, equals(testTodos[0]));
      // Não deve chamar o repository.getTodoById porque o todo está na lista local
      verifyNever(mockRepository.getTodoById(any));
    });

    test('should get todo by id from repository if not in local list',
        () async {
      // Arrange
      // Primeiro, precisamos preencher a lista local (isso é feito pelo método getTodos)
      when(mockRepository.getTodos())
          .thenAnswer((_) async => Result.success(testTodos));
      await useCases.getTodos();

      // Repository deve retornar o todo com id 3 (que não está na lista local)
      final remoteTodo =
          Todo(id: 3, todo: 'Remote Todo', completed: false, userId: 1);
      when(mockRepository.getTodoById(3))
          .thenAnswer((_) async => Result.success(remoteTodo));

      // Act
      final result = await useCases.getTodoById(3);

      // Assert
      expect(result, equals(remoteTodo));
      verify(mockRepository.getTodoById(3)).called(1);
    });

    test('should toggle todo completion', () async {
      // Arrange
      // Primeiro, precisamos preencher a lista local (isso é feito pelo método getTodos)
      when(mockRepository.getTodos())
          .thenAnswer((_) async => Result.success(testTodos));
      await useCases.getTodos();

      // Act
      final result = await useCases.toggleTodoCompletion(testTodos[0]);

      // Assert
      expect(result!.completed, equals(true)); // O completed original era false
      // Não deveria chamar nenhum método do repository
      verifyNever(mockRepository.updateTodo(any));
    });

    test('should create new todo', () async {
      // Arrange
      // Primeiro, precisamos preencher a lista local (isso é feito pelo método getTodos)
      when(mockRepository.getTodos())
          .thenAnswer((_) async => Result.success(testTodos));
      await useCases.getTodos();

      // Act
      final result = await useCases.createTodo('New Todo');

      // Assert
      expect(result, isNotNull);
      expect(result!.todo, equals('New Todo'));
      expect(result.completed, equals(false));
      // Não deveria chamar o repository.createTodo
      verifyNever(mockRepository.createTodo(any));
    });

    test('should delete todo', () async {
      // Arrange
      // Primeiro, precisamos preencher a lista local (isso é feito pelo método getTodos)
      when(mockRepository.getTodos())
          .thenAnswer((_) async => Result.success(testTodos));
      await useCases.getTodos();

      // Act
      final result = await useCases.deleteTodo(1);

      // Assert
      expect(result, equals(true));
      // Verificar que o todo foi removido da lista local
      expect(useCases.getLocalTodos().where((t) => t.id == 1).isEmpty, isTrue);
      // Não deveria chamar o repository.deleteTodo
      verifyNever(mockRepository.deleteTodo(any));
    });

    test('should update todo', () async {
      // Arrange
      // Primeiro, precisamos preencher a lista local (isso é feito pelo método getTodos)
      when(mockRepository.getTodos())
          .thenAnswer((_) async => Result.success(testTodos));
      await useCases.getTodos();

      // Act
      final updatedTodo = Todo(
        id: 1,
        todo: 'Updated Todo',
        completed: true,
        userId: 1,
      );
      final result = await useCases.updateTodo(updatedTodo);

      // Assert
      expect(result, isNotNull);
      expect(result!.todo, equals('Updated Todo'));
      expect(result.completed, equals(true));
      // Não deveria chamar o repository.updateTodo
      verifyNever(mockRepository.updateTodo(any));
    });
  });
}
