import 'package:http/http.dart' as http;
import '../domain/models/todo.dart';
import '../services/todo_service.dart';

class TodoRepository {
  final TodoService _todoService;

  /// Cria uma instância do TodoRepository
  ///
  /// Permite injetar um TodoService personalizado (útil para testes)
  TodoRepository({TodoService? todoService, http.Client? httpClient})
      : _todoService = todoService ?? TodoService(client: httpClient);

  /// Libera recursos quando o repositório não é mais necessário
  void dispose() {
    _todoService.dispose();
  }

  /// Busca todas as tarefas do serviço
  Future<List<Todo>> fetchTodos() async {
    return await _todoService.getTodos();
  }

  /// Busca uma tarefa específica pelo ID
  Future<Todo> fetchTodoById(int id) async {
    return await _todoService.getTodoById(id);
  }
}
