import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';
import '../models/todo.dart';

/// Use cases for Todo operations
class TodoUseCases {
  final TodoRepository _repository;
  final List<Todo> _localTodos = [];
  int _nextId = 1;

  /// Creates a new instance of TodoUseCases
  TodoUseCases({required TodoRepository repository}) : _repository = repository;

  /// Get all todos
  Future<List<TodoEntity>> getTodos() async {
    final result = await _repository.getTodos();
    return result.fold(
      (failure) => [],
      (todos) {
        // Populate local todos with API data if local list is empty
        if (_localTodos.isEmpty) {
          _localTodos.clear();
          for (var todo in todos) {
            if (todo is Todo) {
              _localTodos.add(todo);
            } else {
              _localTodos.add(Todo(
                id: todo.id,
                todo: todo.todo,
                completed: todo.completed,
                userId: todo.userId,
              ));
            }

            // Update _nextId to be greater than the highest id
            if (todo.id >= _nextId) {
              _nextId = todo.id + 1;
            }
          }
        }
        return todos;
      },
    );
  }

  /// Get a todo by ID
  Future<TodoEntity?> getTodoById(int id) async {
    // Podemos usar o repository aqui, mas também podemos buscar diretamente na lista local
    // para melhorar o desempenho, já que todos os dados já estão em memória
    try {
      // Primeiro tenta buscar na lista local
      return _localTodos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      // Se não encontrar, tenta buscar pelo repository (para compatibilidade com testes)
      final result = await _repository.getTodoById(id);
      return result.fold(
        (failure) => null,
        (todo) => todo,
      );
    }
  }

  /// Toggle the completion status of a todo
  Future<TodoEntity?> toggleTodoCompletion(TodoEntity todo) async {
    final updatedTodo = Todo(
      id: todo.id,
      todo: todo.todo,
      completed: !todo.completed,
      userId: todo.userId,
    );

    final index = _localTodos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _localTodos[index] = updatedTodo;
      return updatedTodo;
    }

    // Se não encontrou o todo na lista local, adiciona
    _localTodos.add(updatedTodo);
    return updatedTodo;
  }

  /// Add a new todo with the given title
  Future<TodoEntity?> createTodo(String title) async {
    if (title.trim().isEmpty) {
      return null;
    }

    final newTodo = Todo(
      id: _nextId++,
      todo: title,
      completed: false,
      userId: 1,
    );

    _localTodos.add(newTodo);
    return newTodo;
  }

  /// Delete a todo by ID
  Future<bool> deleteTodo(int id) async {
    _localTodos.removeWhere((todo) => todo.id == id);
    return true;
  }

  /// Update an existing todo
  Future<TodoEntity?> updateTodo(TodoEntity todo) async {
    if (todo.todo.trim().isEmpty) {
      return null;
    }

    final index = _localTodos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      final updatedTodo = Todo(
        id: todo.id,
        todo: todo.todo,
        completed: todo.completed,
        userId: todo.userId,
      );
      _localTodos[index] = updatedTodo;
      return updatedTodo;
    }
    return null;
  }

  /// Get all local todos
  List<TodoEntity> getLocalTodos() {
    return _localTodos;
  }
}
