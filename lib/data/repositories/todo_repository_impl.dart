import '../../domain/models/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_service.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoService _todoService;

  TodoRepositoryImpl({TodoService? todoService})
      : _todoService = todoService ?? TodoService();

  @override
  Future<List<Todo>> getTodos() async {
    return await _todoService.getTodos();
  }

  @override
  Future<Todo> getTodoById(int id) async {
    return await _todoService.getTodoById(id);
  }

  @override
  Future<Todo> addTodo(String title) async {
    return await _todoService.addTodo(title);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await _todoService.updateTodo(todo);
  }

  @override
  Future<void> deleteTodo(int id) async {
    await _todoService.deleteTodo(id);
  }

  @override
  Future<void> dispose() async {
    _todoService.dispose();
  }
}
