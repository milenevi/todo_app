import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/todo.dart';

class TodoService {
  final String baseUrl = 'https://dummyjson.com';
  final http.Client _client;

  TodoService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Todo>> getTodos() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/todos'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> todosJson = data['todos'];
        return todosJson.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load todos: $e');
    }
  }

  Future<Todo> getTodoById(int id) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/todos/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Todo.fromJson(data);
      } else {
        throw Exception('Failed to load todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load todo: $e');
    }
  }

  Future<Todo> addTodo(String title) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/todos/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'todo': title,
          'completed': false,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Todo.fromJson(data);
      } else {
        throw Exception('Failed to add todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add todo: $e');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/todos/${todo.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(todo.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final response = await _client.delete(Uri.parse('$baseUrl/todos/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
