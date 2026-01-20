import '../../core/error/failures.dart';
import '../../core/result/result.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../datasources/todo_remote_datasource.dart';

/// Implementation of TodoRepository that coordinates Local and Remote data sources.
class TodoRepositoryImpl implements TodoRepository {
  /// Creates a new instance of TodoRepositoryImpl
  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;

  @override
  Future<Result<List<TodoEntity>>> getTodos() async {
    try {
      // 1. Try to fetch from remote
      try {
        final remoteTodos = await remoteDataSource.getTodos();
        // 2. Cache remote todos locally
        await localDataSource.cacheTodos(remoteTodos);
      } catch (e) {
        // Ignore remote error if we can't fetch, fallback to local
        // In a real app we might want to return a specific failure or log it
      }

      // 3. Return combined local state (which includes cached remote data)
      final localTodos = await localDataSource.getTodos();
      return Result.success(localTodos);
    } catch (e) {
      return Result.failure(const CacheFailure());
    }
  }

  @override
  Future<Result<TodoEntity>> getTodoById(int id) async {
    try {
      final todo = await localDataSource.getTodoById(id);
      if (todo != null) {
        return Result.success(todo);
      }
      return Result.failure(const CacheFailure());
    } catch (e) {
      return Result.failure(const CacheFailure());
    }
  }

  @override
  Future<Result<TodoEntity>> createTodo(String title) async {
    try {
      // Logic for ID generation could be here or in datasource.
      // For simplicity, we assume we need to generate it.
      // We'll calculate the next ID based on current max ID.
      final todos = await localDataSource.getTodos();
      final maxId = todos.fold<int>(0, (max, t) => t.id > max ? t.id : max);
      
      final newTodo = TodoEntity(
        id: maxId + 1,
        todo: title,
        completed: false,
        userId: 1, // Default user
      );

      final result = await localDataSource.createTodo(newTodo);
      return Result.success(result);
    } catch (e) {
      return Result.failure(const CacheFailure());
    }
  }

  @override
  Future<Result<TodoEntity>> updateTodo(TodoEntity todo) async {
    try {
      final result = await localDataSource.updateTodo(todo);
      return Result.success(result);
    } catch (e) {
      return Result.failure(const CacheFailure());
    }
  }

  @override
  Future<Result<bool>> deleteTodo(int id) async {
    try {
      await localDataSource.deleteTodo(id);
      return Result.success(true);
    } catch (e) {
      return Result.failure(const CacheFailure());
    }
  }
}
