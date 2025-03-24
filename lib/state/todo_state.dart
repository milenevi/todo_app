import '../models/todo.dart';

class TodoState {
  final List<Todo> todos;
  final bool isLoading;
  final String? error;

  TodoState({
    required this.todos,
    required this.isLoading,
    this.error,
  });

  TodoState.initial()
      : todos = [],
        isLoading = false,
        error = null;

  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
    String? error,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<Todo> get completedTodos =>
      todos.where((todo) => todo.completed).toList();

  List<Todo> get incompleteTodos =>
      todos.where((todo) => !todo.completed).toList();

  Todo? findTodoById(int id) {
    try {
      return todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }
}
