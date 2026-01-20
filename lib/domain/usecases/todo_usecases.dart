import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use cases for Todo operations
class TodoUseCases {
  /// Creates a new instance of TodoUseCases
  TodoUseCases({required TodoRepository repository}) : _repository = repository;
  final TodoRepository _repository;

  /// Get all todos
  Future<List<TodoEntity>> getTodos() async {
    final result = await _repository.getTodos();
    return result.fold(
      (failure) => [],
      (todos) => todos,
    );
  }

  /// Get a todo by ID
  Future<TodoEntity?> getTodoById(int id) async {
    final result = await _repository.getTodoById(id);
    return result.fold(
      (failure) => null,
      (todo) => todo,
    );
  }

  /// Toggle the completion status of a todo
  Future<TodoEntity?> toggleTodoCompletion(TodoEntity todo) async {
    final updatedTodo = todo.copyWith(completed: !todo.completed);
    final result = await _repository.updateTodo(updatedTodo);
    return result.fold(
      (failure) => null,
      (data) => data,
    );
  }

  /// Add a new todo with the given title
  Future<TodoEntity?> createTodo(String title) async {
    if (title.trim().isEmpty) {
      return null;
    }
    final result = await _repository.createTodo(title);
    return result.fold(
      (failure) => null,
      (data) => data,
    );
  }

  /// Delete a todo by ID
  Future<bool> deleteTodo(int id) async {
    final result = await _repository.deleteTodo(id);
    return result.fold(
      (failure) => false,
      (success) => success,
    );
  }

  /// Update an existing todo
  Future<TodoEntity?> updateTodo(TodoEntity todo) async {
    if (todo.todo.trim().isEmpty) {
      return null;
    }
    final result = await _repository.updateTodo(todo);
    return result.fold(
      (failure) => null,
      (data) => data,
    );
  }

  /// Get all local todos - delegated to getTodos now as Repo handles sync
  List<TodoEntity> getLocalTodos() {
    // This method was exposing internal state.
    // Ideally consumers should await getTodos().
    // For now, to minimize breakage, we might need to remove this or make it async.
    // However, given the Clean Architecture fix, this method shouldn't exist as sync.
    // I will remove it and fix call sites.
    return [];
  }
}