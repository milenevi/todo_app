import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoProvider with ChangeNotifier {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Todo> get completedTodos =>
      _todos.where((todo) => todo.completed).toList();
  List<Todo> get incompleteTodos =>
      _todos.where((todo) => !todo.completed).toList();

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> fetchTodos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _todos = await _todoService.getTodos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTodoCompletion(Todo todo) async {
    final updatedTodo = todo.copyWith(completed: !todo.completed);
    final index = _todos.indexWhere((t) => t.id == todo.id);

    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }

  void addTodo(String title) {
    final newId = _todos.isNotEmpty
        ? _todos.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1
        : 1;

    final newTodo = Todo(
      id: newId,
      todo: title,
      completed: false,
      userId: 1, // Using a default userId
    );

    _todos.add(newTodo);
    notifyListeners();
  }

  Future<void> deleteTodo(int id) async {
    try {
      setLoading(true);
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
    } catch (e) {
      setError('Error deleting todo: ${e.toString()}');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void updateTodo(Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);

    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }
}
