import 'package:flutter/material.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/todo_usecases.dart';

class TodoController extends ChangeNotifier {
  final TodoUseCases _useCases;

  final ValueNotifier<List<TodoEntity>> _todos =
      ValueNotifier<List<TodoEntity>>([]);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _error = ValueNotifier<String?>(null);

  TodoController({required TodoUseCases useCases}) : _useCases = useCases;

  ValueNotifier<List<TodoEntity>> get todos => _todos;
  ValueNotifier<bool> get isLoading => _isLoading;
  ValueNotifier<String?> get error => _error;

  Future<void> loadTodos() async {
    _isLoading.value = true;
    _error.value = null;
    notifyListeners();

    try {
      final todos = await _useCases.getTodos();
      _todos.value = todos;
      _error.value = null;
    } catch (e) {
      _error.value = 'Erro ao carregar tarefas';
    }

    _isLoading.value = false;
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    try {
      final todo = await _useCases.createTodo(title);
      if (todo != null) {
        _todos.value = [todo, ..._todos.value];
        _error.value = null;
      } else {
        _error.value = 'Erro ao criar tarefa';
      }
    } catch (e) {
      _error.value = 'Erro ao criar tarefa';
    }
    notifyListeners();
  }

  Future<void> toggleTodoStatus(TodoEntity todo) async {
    try {
      await _useCases.toggleTodoCompletion(todo);
      final index = _todos.value.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        final newTodos = List<TodoEntity>.from(_todos.value);
        newTodos[index] = todo.copyWith(completed: !todo.completed);
        _todos.value = newTodos;
        _error.value = null;
      }
    } catch (e) {
      _error.value = 'Erro ao atualizar tarefa';
    }
    notifyListeners();
  }

  Future<void> removeTodo(int id) async {
    try {
      final success = await _useCases.deleteTodo(id);
      if (success) {
        _todos.value = _todos.value.where((todo) => todo.id != id).toList();
        _error.value = null;
      } else {
        _error.value = 'Erro ao excluir tarefa';
      }
    } catch (e) {
      _error.value = 'Erro ao excluir tarefa';
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _todos.dispose();
    _isLoading.dispose();
    _error.dispose();
    super.dispose();
  }
}
