// import 'package:dartz/dartz.dart';
import '../../core/result/result.dart';
import '../entities/todo_entity.dart';
import '../../core/error/failures.dart';

/// Repository interface for Todo operations
abstract class TodoRepository {
  /// Get all todos
  Future<Result<List<TodoEntity>>> getTodos();

  /// Get a todo by ID
  Future<Result<TodoEntity>> getTodoById(int id);

  /// Add a new todo with the given title
  Future<Result<TodoEntity>> createTodo(String title);

  /// Update an existing todo
  Future<Result<TodoEntity>> updateTodo(TodoEntity todo);

  /// Delete a todo by ID
  Future<Result<bool>> deleteTodo(int id);
}
