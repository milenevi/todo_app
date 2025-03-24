import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class TodoService {
  final String baseUrl = 'https://dummyjson.com';

  Future<List<Todo>> getTodos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/todos'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> todosJson = data['todos'];
        final List<Todo> todos =
        todosJson.map((json) => Todo.fromJson(json)).toList();
        return todos;
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load todos: $e');
    }
  }

  Future<Todo> getTodoById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/todos/$id'));

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
}
