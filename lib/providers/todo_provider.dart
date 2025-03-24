import 'package:flutter/foundation.dart';
import '../domain/models/todo.dart';
import '../domain/usecases/todo_usecases.dart';

class TodoProvider extends ChangeNotifier {
  final TodoUseCases _useCases;
  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;

  TodoProvider({required TodoUseCases useCases}) : _useCases = useCases;

  List<Todo> get todos => _todos;
  set todos(List<Todo> value) {
    _todos = value;
    notifyListeners();
  }

  List<Todo> get completedTodos =>
      _todos.where((todo) => todo.completed).toList();
  List<Todo> get incompleteTodos =>
      _todos.where((todo) => !todo.completed).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTodos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _todos = await _useCases.getTodos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Todo? findTodoById(int id) {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Todo?> getTodoById(int id) async {
    try {
      return await _useCases.getTodoById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) {
      _error = 'Task description cannot be empty';
      notifyListeners();
      return;
    }

    try {
      // Calculate next ID
      int nextId = 1;
      if (_todos.isNotEmpty) {
        nextId = _todos.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
      }

      // Create new todo
      final newTodo = Todo(
        id: nextId,
        todo: title,
        completed: false,
        userId: 1,
      );

      // Add to list
      _todos.insert(0, newTodo);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTodo(Todo todo) async {
    // Find the original todo and its index
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index == -1) return; // Todo not found

    final originalTodo = _todos[index];
    final statusChanged = originalTodo.completed != todo.completed;

    if (statusChanged) {
      // If completion status changed, remove and reposition
      _todos.removeAt(index);

      // Insert at the appropriate position based on completion status
      if (todo.completed) {
        // If completed, add to the beginning of the list
        _todos.insert(0, todo);
      } else {
        // If not completed, add after the last completed item or at the beginning
        final lastCompletedIndex = _todos.lastIndexWhere((t) => t.completed);
        if (lastCompletedIndex >= 0) {
          _todos.insert(lastCompletedIndex + 1, todo);
        } else {
          _todos.insert(0, todo);
        }
      }
    } else {
      // If only the text changed, maintain position
      _todos[index] = todo;
    }

    notifyListeners();
  }

  Future<void> toggleTodoCompletion(Todo todo) async {
    // Remove the todo from its current position
    _todos.removeWhere((t) => t.id == todo.id);

    // Create the updated todo with toggled completion status
    final updatedTodo = todo.copyWith(completed: !todo.completed);

    // Insert at appropriate position based on completion status
    if (updatedTodo.completed) {
      // If completed, add to the beginning of the list
      _todos.insert(0, updatedTodo);
    } else {
      // If not completed, add after the last completed item or at the beginning
      final lastCompletedIndex = _todos.lastIndexWhere((t) => t.completed);
      if (lastCompletedIndex >= 0) {
        _todos.insert(lastCompletedIndex + 1, updatedTodo);
      } else {
        _todos.insert(0, updatedTodo);
      }
    }

    notifyListeners();
  }

  Future<void> deleteTodo(int id) async {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  @override
  void dispose() {
    _useCases.dispose();
    super.dispose();
  }
}
