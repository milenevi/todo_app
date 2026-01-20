import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_config.dart';
import '../../domain/entities/todo_entity.dart';
import '../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  /// Get all todos from the API
  Future<List<TodoEntity>> getTodos();

  /// Get a todo by ID - NOTA: Este método não é utilizado na aplicação real.
  /// Existe apenas para manter compatibilidade com a interface.
  Future<TodoEntity> getTodoById(int id);

  /// Create a todo - NOTA: Este método não é utilizado na aplicação real.
  /// Existe apenas para manter compatibilidade com a interface.
  Future<TodoEntity> createTodo(String title);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {

  TodoRemoteDataSourceImpl({required this.apiClient});
  final ApiClient apiClient;

  @override
  Future<List<TodoEntity>> getTodos() async {
    try {
      final response = await apiClient.get(NetworkConfig.todosEndpoint);
      final todos = (response['todos'] as List<dynamic>)
          .map((todo) => TodoModel.fromJson(todo as Map<String, dynamic>))
          .toList();
      return todos;
    } catch (e) {
      if (e is Failure) rethrow;
      throw const ServerFailure();
    }
  }

  @override
  Future<TodoEntity> getTodoById(int id) async {
    // Este método não é usado na aplicação real e deveria lançar uma exceção
    // em um ambiente de produção.
    throw UnimplementedError(
        'getTodoById não é implementado para uso em produção. Operações de TODOs são gerenciadas localmente.');
  }

  @override
  Future<TodoEntity> createTodo(String title) async {
    // Este método não é usado na aplicação real e deveria lançar uma exceção
    // em um ambiente de produção.
    throw UnimplementedError(
        'createTodo não é implementado para uso em produção. Operações de TODOs são gerenciadas localmente.');
  }
}
