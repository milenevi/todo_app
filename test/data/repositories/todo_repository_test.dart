import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/data/datasources/todo_local_datasource.dart';
import 'package:todo_app/data/datasources/todo_remote_datasource.dart';
import 'package:todo_app/data/repositories/todo_repository_impl.dart';
import 'package:todo_app/domain/entities/todo_entity.dart';
import 'todo_repository_test.mocks.dart';

@GenerateMocks([TodoRemoteDataSource, TodoLocalDataSource])
void main() {
  late TodoRepositoryImpl repository;
  late MockTodoRemoteDataSource mockRemoteDataSource;
  late MockTodoLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTodoRemoteDataSource();
    mockLocalDataSource = MockTodoLocalDataSource();
    repository = TodoRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('getTodos', () {
    test('should return combined list of todos when remote and local datasources complete',
        () async {
      // Arrange
      final remoteTodos = [
        const TodoEntity(id: 1, todo: 'Remote Todo', completed: false, userId: 1),
      ];
      final localTodos = [
        const TodoEntity(id: 1, todo: 'Remote Todo', completed: false, userId: 1),
        const TodoEntity(id: 2, todo: 'Local Todo', completed: true, userId: 1),
      ];
      
      when(mockRemoteDataSource.getTodos()).thenAnswer((_) async => remoteTodos);
      when(mockLocalDataSource.cacheTodos(any)).thenAnswer((_) async {});
      when(mockLocalDataSource.getTodos()).thenAnswer((_) async => localTodos);

      // Act
      final result = await repository.getTodos();

      // Assert
      verify(mockRemoteDataSource.getTodos());
      verify(mockLocalDataSource.cacheTodos(remoteTodos));
      verify(mockLocalDataSource.getTodos());
      expect(result.isSuccess, true);
      expect(result.value, equals(localTodos));
    });

    test('should return local todos when remote datasource fails',
        () async {
      // Arrange
      final localTodos = [
        const TodoEntity(id: 1, todo: 'Local Todo', completed: false, userId: 1),
      ];
      
      when(mockRemoteDataSource.getTodos()).thenThrow(Exception());
      when(mockLocalDataSource.getTodos()).thenAnswer((_) async => localTodos);

      // Act
      final result = await repository.getTodos();

      // Assert
      verify(mockRemoteDataSource.getTodos());
      verify(mockLocalDataSource.getTodos());
      expect(result.isSuccess, true);
      expect(result.value, equals(localTodos));
    });
  });

  group('CRUD Operations', () {
    test('createTodo should call local datasource', () async {
      const todo = TodoEntity(id: 2, todo: 'New Todo', completed: false, userId: 1);
      
      when(mockLocalDataSource.getTodos()).thenAnswer((_) async => [const TodoEntity(id: 1, todo: 'Old', completed: false, userId: 1)]);
      when(mockLocalDataSource.createTodo(any)).thenAnswer((_) async => todo);

      final result = await repository.createTodo('New Todo');

      expect(result.isSuccess, true);
      verify(mockLocalDataSource.createTodo(any)).called(1);
    });
  });
}
