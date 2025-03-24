import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../repositories/todo_repository.dart';
import '../state/todo_operations.dart';
import '../state/todo_state.dart';

class TodoProvider with ChangeNotifier {
  final TodoRepository _repository;
  final TodoOperations _operations;

  TodoState _state = TodoState.initial();

  TodoProvider({TodoRepository? repository, TodoOperations? operations})
      : _repository = repository ?? TodoRepository(),
        _operations = operations ?? TodoOperations();

  List<Todo> get todos => _state.todos;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  List<Todo> get completedTodos => _state.completedTodos;
  List<Todo> get incompleteTodos => _state.incompleteTodos;

  Todo? findTodoById(int id) => _state.findTodoById(id);

  void _updateState(TodoState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  Future<void> fetchTodos() async {
    _updateState(_state.copyWith(isLoading: true, error: null));

    try {
      final todos = await _repository.fetchTodos();
      _updateState(_state.copyWith(todos: todos, isLoading: false));
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Failed to fetch todos: ${e.toString()}',
      ));
    }
  }

  Future<void> toggleTodoCompletion(Todo todo) async {
    final newState = _operations.toggleTodoCompletion(_state, todo);
    _updateState(newState);
  }

  Future<void> addTodo(String title) async {
    final newState = _operations.addTodo(_state, title);
    _updateState(newState);
  }

  Future<void> deleteTodo(int id) async {
    _updateState(_state.copyWith(isLoading: true));

    try {
      final newState = _operations.deleteTodo(_state, id);
      _updateState(newState.copyWith(isLoading: false));
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Error deleting todo: ${e.toString()}',
      ));
      rethrow;
    }
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    try {
      final newState = _operations.updateTodo(_state, updatedTodo);
      _updateState(newState);
    } catch (e) {
      _updateState(_state.copyWith(
        error: 'Failed to update todo: ${e.toString()}',
      ));
      rethrow;
    }
  }
}
