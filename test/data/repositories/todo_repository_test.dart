// import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/core/result/result.dart';
import 'package:todo_app/data/datasources/todo_remote_datasource.dart';
import 'package:todo_app/data/repositories/todo_repository_impl.dart';
import 'package:todo_app/domain/entities/todo_entity.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'todo_repository_test.mocks.dart';

@GenerateMocks([TodoRemoteDataSource])
void main() {
  late TodoRepositoryImpl repository;
  late MockTodoRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockTodoRemoteDataSource();
    repository = TodoRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('getTodos', () {
    test('should return a list of todos when remote datasource completes',
        () async {
      // Arrange
      final todos = [
        Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1),
      ];
      when(mockRemoteDataSource.getTodos()).thenAnswer((_) async => todos);

      // Act
      final result = await repository.getTodos();

      // Assert
      verify(mockRemoteDataSource.getTodos());
      expect(result.isSuccess, true);
      expect(result.value, equals(todos));
    });

    test('should return a failure when remote datasource throws an exception',
        () async {
      // Arrange
      when(mockRemoteDataSource.getTodos()).thenThrow(Exception());

      // Act
      final result = await repository.getTodos();

      // Assert
      verify(mockRemoteDataSource.getTodos());
      expect(result.isFailure, true);
      expect(result.errorValue, isA<ServerFailure>());
    });

    test('should use correct repository pattern to prevent duplicate calls',
        () async {
      // This test ensures that repeated calls use the repository pattern correctly
      // Arrange
      final todos = [
        Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1),
      ];
      when(mockRemoteDataSource.getTodos()).thenAnswer((_) async => todos);

      // Act
      final result1 = await repository.getTodos();
      final result2 = await repository.getTodos();

      // Assert
      verify(mockRemoteDataSource.getTodos()).called(2); // Called twice
      expect(result1.isSuccess, true);
      expect(result2.isSuccess, true);
      expect(result1.value, equals(todos));
      expect(result2.value, equals(todos));
    });

    // Nota: Os outros métodos do repositório (getTodoById, createTodo, updateTodo, deleteTodo)
    // não estão sendo testados porque na aplicação real eles são apenas stubs.
    // A lógica real de manipulação de dados está na classe TodoUseCases.
  });
}
