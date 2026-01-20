import '../../domain/entities/todo_entity.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoEntity>> getTodos();
  Future<void> cacheTodos(List<TodoEntity> todos);
  Future<TodoEntity> createTodo(TodoEntity todo);
  Future<TodoEntity> updateTodo(TodoEntity todo);
  Future<void> deleteTodo(int id);
  Future<TodoEntity?> getTodoById(int id);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final List<TodoEntity> _todos = [];

  @override
  Future<List<TodoEntity>> getTodos() async {
    return List.unmodifiable(_todos);
  }

  @override
  Future<void> cacheTodos(List<TodoEntity> todos) async {
    // Merge strategy: Add only if not present (simple version)
    // Or replace all. For now, let's just add missing ones to keep user edits if any
    for (final todo in todos) {
      if (!_todos.any((t) => t.id == todo.id)) {
        _todos.add(todo);
      }
    }
  }

  @override
  Future<TodoEntity> createTodo(TodoEntity todo) async {
    _todos.add(todo);
    return todo;
  }

  @override
  Future<TodoEntity> updateTodo(TodoEntity todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      return todo;
    } else {
      // If not found locally, we add it (assuming it came from remote or is new)
      _todos.add(todo);
      return todo;
    }
  }

  @override
  Future<void> deleteTodo(int id) async {
    _todos.removeWhere((t) => t.id == id);
  }

  @override
  Future<TodoEntity?> getTodoById(int id) async {
    try {
      return _todos.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
