// import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/result/result.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_datasource.dart';
import '../models/todo_model.dart';

/// Implementação do TodoRepository que usa um TodoRemoteDataSource apenas para carregamento inicial
/// e retorna valores simulados para os outros métodos para compatibilidade com os testes.
/// A lógica real de gestão de dados está em TodoUseCases._localTodos.
class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  /// Creates a new instance of TodoRepositoryImpl
  TodoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<TodoEntity>>> getTodos() async {
    try {
      // Essa é a única operação real na API
      final todos = await remoteDataSource.getTodos();
      return Result.success(todos);
    } catch (e) {
      if (e is Failure) return Result.failure(e);
      return Result.failure(const ServerFailure());
    }
  }

  // Os métodos abaixo são stubs que existem apenas para implementar a interface TodoRepository.
  // Na aplicação real, todas as operações de CRUD (exceto a carga inicial) são gerenciadas
  // localmente na classe TodoUseCases._localTodos.

  @override
  Future<Result<TodoEntity>> getTodoById(int id) async {
    // Simulação - nunca é usada na aplicação real
    return Result.failure(const NotImplementedFailure(
        message:
            "Operação não implementada - TODOs são gerenciados localmente"));
  }

  @override
  Future<Result<TodoEntity>> createTodo(String title) async {
    // Simulação - nunca é usada na aplicação real
    return Result.failure(const NotImplementedFailure(
        message:
            "Operação não implementada - TODOs são gerenciados localmente"));
  }

  @override
  Future<Result<TodoEntity>> updateTodo(TodoEntity todo) async {
    // Simulação - nunca é usada na aplicação real
    return Result.failure(const NotImplementedFailure(
        message:
            "Operação não implementada - TODOs são gerenciados localmente"));
  }

  @override
  Future<Result<bool>> deleteTodo(int id) async {
    // Simulação - nunca é usada na aplicação real
    return Result.failure(const NotImplementedFailure(
        message:
            "Operação não implementada - TODOs são gerenciados localmente"));
  }
}
