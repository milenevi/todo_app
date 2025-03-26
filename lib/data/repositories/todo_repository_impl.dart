// import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/result/result.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_datasource.dart';
import '../models/todo_model.dart';

/// Implementação do TodoRepository que usa um TodoRemoteDataSource apenas para carregamento inicial
/// A lógica real de gestão de dados está em TodoUseCases._localTodos.
class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  /// Creates a new instance of TodoRepositoryImpl
  TodoRepositoryImpl({required this.remoteDataSource});

  /// A única operação real implementada - carrega todos da API
  @override
  Future<Result<List<TodoEntity>>> getTodos() async {
    try {
      final todos = await remoteDataSource.getTodos();
      return Result.success(todos);
    } catch (e) {
      if (e is Failure) return Result.failure(e);
      return Result.failure(const ServerFailure());
    }
  }

  /// Os métodos abaixo retornam NotImplementedFailure pois todas as operações
  /// CRUD são gerenciadas localmente pela classe TodoUseCases

  @override
  Future<Result<TodoEntity>> getTodoById(int id) async =>
      Result.failure(const NotImplementedFailure(
          message:
              "Operação não implementada - TODOs são gerenciados localmente"));

  @override
  Future<Result<TodoEntity>> createTodo(String title) async =>
      Result.failure(const NotImplementedFailure(
          message:
              "Operação não implementada - TODOs são gerenciados localmente"));

  @override
  Future<Result<TodoEntity>> updateTodo(TodoEntity todo) async =>
      Result.failure(const NotImplementedFailure(
          message:
              "Operação não implementada - TODOs são gerenciados localmente"));

  @override
  Future<Result<bool>> deleteTodo(int id) async =>
      Result.failure(const NotImplementedFailure(
          message:
              "Operação não implementada - TODOs são gerenciados localmente"));
}
