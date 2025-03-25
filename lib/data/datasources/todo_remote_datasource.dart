import '../../core/network/api_client.dart';
import '../../core/network/network_config.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/todo_entity.dart';
import '../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  /// Get all todos from the API
  Future<List<TodoEntity>> getTodos();

  /// Get a todo by ID - NOTA: Este método não é realmente usado pelo aplicativo
  /// É mantido apenas para compatibilidade com os testes existentes
  Future<TodoEntity> getTodoById(int id);

  /// Create a todo - NOTA: Este método não é realmente usado pelo aplicativo
  /// É mantido apenas para compatibilidade com os testes existentes
  Future<TodoEntity> createTodo(String title);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final ApiClient apiClient;

  TodoRemoteDataSourceImpl({required this.apiClient});

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
    // NOTA: Este método existe apenas para passar nos testes
    // No aplicativo real, os todos são gerenciados localmente
    try {
      final response = await apiClient.get('${NetworkConfig.todoEndpoint}/$id');
      return TodoModel.fromJson(response);
    } catch (e) {
      if (e is Failure) rethrow;
      throw const ServerFailure();
    }
  }

  @override
  Future<TodoEntity> createTodo(String title) async {
    // NOTA: Este método existe apenas para passar nos testes
    // No aplicativo real, os todos são criados localmente
    try {
      final response = await apiClient.post(
        NetworkConfig.todoEndpoint,
        body: {
          'todo': title,
          'completed': false,
          'userId': 1,
        },
      );
      return TodoModel.fromJson(response);
    } catch (e) {
      if (e is Failure) rethrow;
      throw const ServerFailure();
    }
  }
}
