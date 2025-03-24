import '../models/todo.dart';
import '../repositories/todo_repository.dart';

class TodoUseCases {
  final TodoRepository _repository;

  TodoUseCases({required TodoRepository repository}) : _repository = repository;

  Future<List<Todo>> getTodos() async {
    return await _repository.getTodos();
  }

  Future<Todo> getTodoById(int id) async {
    return await _repository.getTodoById(id);
  }

  Future<void> toggleTodoCompletion(Todo todo) async {
    final updatedTodo = todo.copyWith(completed: !todo.completed);
    await _repository.updateTodo(updatedTodo);
  }

  Future<Todo> addTodo(String title) async {
    if (title.trim().isEmpty) {
      throw Exception('Task description cannot be empty');
    }
    return await _repository.addTodo(title);
  }

  Future<void> deleteTodo(int id) async {
    await _repository.deleteTodo(id);
  }

  Future<void> updateTodo(Todo todo) async {
    if (todo.todo.trim().isEmpty) {
      throw Exception('Task description cannot be empty');
    }
    await _repository.updateTodo(todo);
  }

  Future<void> dispose() async {
    await _repository.dispose();
  }
}
