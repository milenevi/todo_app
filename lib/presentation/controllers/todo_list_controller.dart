import 'package:meta/meta.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/todo_usecases.dart';
import '../providers/todo_provider.dart';

/// Controller for the Todo List screen
class TodoListController {

  /// Creates a new TodoListController
  TodoListController({
    required TodoProvider todoProvider,
    required this.useCases,
  }) : _todoProvider = todoProvider;
  final TodoProvider _todoProvider;

  /// UseCases are retained for potential direct use in the future
  @protected
  final TodoUseCases useCases;

  /// Get all todos from the provider
  List<TodoEntity> get todos => _todoProvider.todos;

  /// Get completed todos from the provider
  List<TodoEntity> get completedTodos => _todoProvider.completedTodos;

  /// Get incomplete todos from the provider
  List<TodoEntity> get incompleteTodos => _todoProvider.incompleteTodos;

  /// Get loading state from the provider
  bool get isLoading => _todoProvider.isLoading;

  /// Get error state from the provider
  String? get error => _todoProvider.error;

  /// Add a new todo
  Future<void> addTodo(String title) async {
    await _todoProvider.addTodo(title);
  }

  /// Toggle the completion status of a todo
  Future<void> toggleTodoCompletion(TodoEntity todo) async {
    await _todoProvider.toggleTodoCompletion(todo);
  }

  /// Load todos from the repository
  Future<void> loadTodos() async {
    await _todoProvider.fetchTodos();
  }

  /// Dispose resources
  void dispose() {
    // No resources to dispose in this controller
  }
}
