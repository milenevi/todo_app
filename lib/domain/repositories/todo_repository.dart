import '../models/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> getTodoById(int id);
  Future<Todo> addTodo(String title);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(int id);
  Future<void> dispose();
}
