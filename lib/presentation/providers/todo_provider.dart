import 'package:flutter/foundation.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/todo_usecases.dart';
import 'dart:developer' as developer;
import 'dart:math' as Math;

/// Provider for Todo state management
class TodoProvider extends ChangeNotifier {
  final TodoUseCases _useCases;
  List<TodoEntity> _todos = [];
  bool _isLoading = false;
  String? _error;
  bool _initialized = false;

  /// Creates a new instance of TodoProvider
  TodoProvider({required TodoUseCases useCases}) : _useCases = useCases {
    // Inicializa dados ao criar o provider
    fetchTodos();
  }

  /// Get all todos
  List<TodoEntity> get todos => _todos;

  /// Set all todos
  set todos(List<TodoEntity> value) {
    _todos = value;
    notifyListeners();
  }

  /// Get completed todos
  List<TodoEntity> get completedTodos =>
      _todos.where((todo) => todo.completed).toList();

  /// Get incomplete todos
  List<TodoEntity> get incompleteTodos =>
      _todos.where((todo) => !todo.completed).toList();

  /// Sorting helper - reorganiza a lista para manter tarefas não concluídas primeiro e concluídas depois
  void _sortTodosByCompletion() {
    // Separa as tarefas não concluídas e concluídas
    final incompleteTodos = _todos.where((todo) => !todo.completed).toList();
    final completedTodos = _todos.where((todo) => todo.completed).toList();

    // Reconstrói a lista com não concluídas primeiro (TO DO) e concluídas depois (COMPLETED)
    _todos = [...incompleteTodos, ...completedTodos];
  }

  /// Loading state
  bool get isLoading => _isLoading;

  /// Error message
  String? get error => _error;

  /// Provider initialization status
  bool get initialized => _initialized;

  /// Fetch all todos from the repository
  Future<void> fetchTodos() async {
    if (_isLoading) return; // Evita múltiplas chamadas simultâneas

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      developer.log("Fetching todos...");

      // Tenta carregar do repositório
      final result = await _useCases.getTodos();

      // Combina os resultados obtidos do repositório com os locais
      final localTodos = _useCases.getLocalTodos();
      developer.log(
          "API todos: ${result.length}, Local todos: ${localTodos.length}");

      if (result.isNotEmpty) {
        // Use a combinação dos dois conjuntos de dados
        final Map<int, TodoEntity> todoMap = {};

        // Primeiro adiciona os locais
        for (var todo in localTodos) {
          todoMap[todo.id] = todo;
        }

        // Depois adiciona os da API (não sobrescreve os locais com mesmo ID)
        for (var todo in result) {
          if (!todoMap.containsKey(todo.id)) {
            todoMap[todo.id] = todo;
          }
        }

        _todos = todoMap.values.toList();
      } else {
        // Se não houver dados no repositório, usa os dados locais
        _todos = localTodos;
      }

      _sortTodosByCompletion(); // Garante a ordem correta após carregar
      _error = null;
      _initialized = true;
      developer.log("Todos loaded successfully. Count: ${_todos.length}");
    } catch (e) {
      developer.log("Error fetching todos: $e", error: e);

      // Em caso de erro, usa os dados locais
      _todos = _useCases.getLocalTodos();
      _sortTodosByCompletion();
      _error = null;
      _initialized = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Find a todo by ID from the current list
  TodoEntity? findTodoById(int id) {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get a todo by ID from the repository
  Future<TodoEntity?> getTodoById(int id) async {
    try {
      return await _useCases.getTodoById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Add a new todo
  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) {
      _error = 'Task description cannot be empty';
      notifyListeners();
      return;
    }

    try {
      final newTodo = await _useCases.createTodo(title);
      if (newTodo != null) {
        // Reorganizar a lista mantendo a nova tarefa no topo da seção TO DO
        final incompleteTodos = _todos.where((t) => !t.completed).toList();
        final completedTodos = _todos.where((t) => t.completed).toList();

        // Adiciona a nova tarefa no início das não concluídas
        incompleteTodos.insert(0, newTodo);

        // Reconstrói a lista com não concluídas primeiro
        _todos = [...incompleteTodos, ...completedTodos];
        _error = null;
      } else {
        _error = 'Erro ao criar tarefa';
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Toggle todo completion status
  Future<void> toggleTodoCompletion(TodoEntity todo) async {
    try {
      developer.log("Toggling completion for todo ${todo.id}: ${todo.todo}");

      final updatedTodo = await _useCases.toggleTodoCompletion(todo);
      if (updatedTodo != null) {
        developer.log(
            "Todo completion toggled successfully. New status: ${updatedTodo.completed}");

        // Remove o todo da posição atual
        final index = _todos.indexWhere((t) => t.id == todo.id);
        if (index != -1) {
          _todos.removeAt(index);
          developer.log("Removed todo from position $index");
        }

        // Reorganiza a lista mantendo a ordem de seções
        final incompleteTodos = _todos.where((t) => !t.completed).toList();
        final completedTodos = _todos.where((t) => t.completed).toList();

        // Adiciona o todo atualizado na seção correta
        if (updatedTodo.completed) {
          // Se está concluída, coloca no início das concluídas
          completedTodos.insert(0, updatedTodo);
          developer.log("Todo added to completed section");
        } else {
          // Se não está concluída, coloca no início das não concluídas
          incompleteTodos.insert(0, updatedTodo);
          developer.log("Todo added to incomplete section");
        }

        // Reconstrói a lista mantendo TO DO primeiro, COMPLETED depois
        _todos = [...incompleteTodos, ...completedTodos];
        _error = null;
        notifyListeners();
      } else {
        _error = 'Erro ao atualizar status da tarefa';
        developer.log("Failed to toggle todo completion: returned null");
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      developer.log("Error toggling todo completion: $e", error: e);
      notifyListeners();
    }
  }

  /// Update an existing todo
  Future<void> updateTodo(TodoEntity todo) async {
    try {
      developer.log("Updating todo ${todo.id}: ${todo.todo}");

      // Primeiro verifica se a tarefa já existe na lista
      final existsInList = _todos.any((t) => t.id == todo.id);

      // Se não existir na lista, adiciona à lista primeiro
      if (!existsInList) {
        developer.log("Todo not found in list, adding it directly");

        if (todo.completed) {
          final completedTodos = _todos.where((t) => t.completed).toList();
          completedTodos.insert(
              0, todo); // Coloca no início se for uma tarefa nova
          final incompleteTodos = _todos.where((t) => !t.completed).toList();
          _todos = [...incompleteTodos, ...completedTodos];
        } else {
          final incompleteTodos = _todos.where((t) => !t.completed).toList();
          incompleteTodos.insert(
              0, todo); // Coloca no início se for uma tarefa nova
          final completedTodos = _todos.where((t) => t.completed).toList();
          _todos = [...incompleteTodos, ...completedTodos];
        }
        _error = null;
        notifyListeners();
        return;
      }

      // Guarda a posição absoluta na lista completa para preservá-la
      final index = _todos.indexWhere((t) => t.id == todo.id);
      var wasCompletedBefore = false;

      if (index != -1) {
        final currentTodo = _todos[index];
        wasCompletedBefore = currentTodo.completed;
      }

      // Tenta atualizar no usecase
      final updatedTodo = await _useCases.updateTodo(todo);
      if (updatedTodo != null) {
        developer.log("Todo updated successfully in usecase");

        // Se o status de completude não mudou, apenas substitui o item na lista
        // mantendo exatamente a mesma posição
        if (wasCompletedBefore == updatedTodo.completed && index != -1) {
          _todos[index] = updatedTodo;
          developer.log(
              "Todo updated in-place at position $index, preserving exact position");
        } else {
          // Se o status mudou, aplicamos a lógica de reorganização
          // Remove o todo da posição atual
          if (index != -1) {
            _todos.removeAt(index);
            developer
                .log("Removed todo from position $index due to status change");
          }

          // Reorganiza a lista mantendo a ordem de seções
          List<TodoEntity> incompleteTodos =
              _todos.where((t) => !t.completed).toList();
          List<TodoEntity> completedTodos =
              _todos.where((t) => t.completed).toList();

          // Adiciona o todo atualizado na seção correta com base no novo status
          if (updatedTodo.completed) {
            // Se mudou para completado, coloca no início da seção de completados
            completedTodos.insert(0, updatedTodo);
            developer
                .log("Todo moved to completed section, added to beginning");
          } else {
            // Se mudou para não completado, coloca no início da seção de não completados
            incompleteTodos.insert(0, updatedTodo);
            developer
                .log("Todo moved to incomplete section, added to beginning");
          }

          // Reconstrói a lista mantendo TO DO primeiro, COMPLETED depois
          _todos = [...incompleteTodos, ...completedTodos];
        }
        _error = null;
      } else {
        // Se falhar no usecase, trata da mesma forma, sem reorganização se o status não mudou
        developer
            .log("Failed to update todo in usecase, updating in list only");

        if (wasCompletedBefore == todo.completed && index != -1) {
          // Se o status não mudou, apenas substitui na mesma posição
          _todos[index] = todo;
          developer.log(
              "Todo updated in-place at position $index, preserving exact position (fallback)");
        } else {
          // Se o status mudou, reorganiza
          // Remove o todo da posição atual
          if (index != -1) {
            _todos.removeAt(index);
          }

          // Reorganiza a lista mantendo a ordem de seções
          List<TodoEntity> incompleteTodos =
              _todos.where((t) => !t.completed).toList();
          List<TodoEntity> completedTodos =
              _todos.where((t) => t.completed).toList();

          // Adiciona o todo atualizado na seção correta
          if (todo.completed) {
            completedTodos.insert(0, todo);
          } else {
            incompleteTodos.insert(0, todo);
          }

          // Reconstrói a lista mantendo TO DO primeiro, COMPLETED depois
          _todos = [...incompleteTodos, ...completedTodos];
        }
        _error = null;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      developer.log("Error updating todo: $e", error: e);
      notifyListeners();
    }
  }

  /// Delete a todo
  Future<void> deleteTodo(int id) async {
    try {
      final success = await _useCases.deleteTodo(id);
      if (success) {
        _todos.removeWhere((todo) => todo.id == id);
        _error = null;
      } else {
        _error = 'Erro ao excluir tarefa';
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
