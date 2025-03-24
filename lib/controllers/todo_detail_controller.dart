import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/models/todo.dart';
import '../domain/usecases/todo_usecases.dart';
import '../providers/todo_provider.dart';

class TodoDetailController extends ChangeNotifier {
  final int todoId;
  final TodoUseCases _useCases;
  final ValueNotifier<Todo?> _todo = ValueNotifier<Todo?>(null);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _error = ValueNotifier<String?>(null);

  TodoDetailController({
    required this.todoId,
    required TodoUseCases useCases,
  }) : _useCases = useCases;

  ValueListenable<Todo?> get todo => _todo;
  ValueListenable<bool> get isLoading => _isLoading;
  ValueListenable<String?> get error => _error;

  Future<bool> loadTodo(BuildContext context) async {
    _isLoading.value = true;
    _error.value = null;
    notifyListeners();

    try {
      // Get todo from provider instead of API
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      final todo = todoProvider.findTodoById(todoId);

      if (todo == null) {
        _error.value = 'Todo not found';
        _isLoading.value = false;
        notifyListeners();
        return false;
      }

      _todo.value = todo;
      _isLoading.value = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error.value = e.toString();
      _isLoading.value = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTodo(BuildContext context, Todo updatedTodo) async {
    try {
      // Update in provider first
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      await todoProvider.updateTodo(updatedTodo);

      // Then update local state
      _todo.value = updatedTodo;
      notifyListeners();
      return true;
    } catch (e) {
      _error.value = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTodo(BuildContext context) async {
    _isLoading.value = true;
    _error.value = null;
    notifyListeners();

    try {
      // Delete from provider
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      await todoProvider.deleteTodo(todoId);

      _isLoading.value = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error.value = e.toString();
      _isLoading.value = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _todo.dispose();
    _isLoading.dispose();
    _error.dispose();
    super.dispose();
  }
}
