import '../../../domain/models/todo.dart';

/// Abstract interface for Todo data sources
abstract class TodoDatasource {
  /// Get all todos
  Future<List<Todo>> getTodos();

  /// Get a todo by id
  Future<Todo> getTodoById(int id);

  /// Add a new todo
  Future<Todo> addTodo(String title);

  /// Update a todo
  Future<void> updateTodo(Todo todo);

  /// Delete a todo
  Future<void> deleteTodo(int id);

  /// Dispose any resources
  void dispose();
}
