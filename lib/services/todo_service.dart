import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/models/todo.dart';

class TodoService {
  static const String baseUrl = 'https://dummyjson.com/todos';
  final http.Client _client;

  /// Cria uma instância de TodoService
  ///
  /// Por padrão, cria um novo http.Client se nenhum for fornecido
  TodoService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Todo>> getTodos() async {
    try {
      final response = await _client.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> todosJson = data['todos'];
        final List<Todo> todos =
        todosJson.map((json) => Todo.fromJson(json)).toList();
        return todos;
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Todo> getTodoById(int id) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Todo.fromJson(data);
      } else {
        throw Exception('Failed to load todo');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Libera os recursos do cliente HTTP quando não for mais necessário
  void dispose() {
    _client.close();
  }
}
