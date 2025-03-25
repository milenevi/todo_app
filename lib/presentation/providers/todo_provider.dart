import 'package:flutter/foundation.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/todo_usecases.dart';
import 'dart:math' as Math;

/// Provider for Todo state management
class TodoProvider extends ChangeNotifier {
  final TodoUseCases _useCases;
  List<TodoEntity> _todos = [];
  bool _isLoading = false;
  String? _error;
  bool _initialized = false;
  // Conjunto para armazenar IDs de tarefas excluídas
  final Set<int> _deletedIds = {};

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
      // Tenta carregar do repositório
      final result = await _useCases.getTodos();

      // Combina os resultados obtidos do repositório com os locais
      final localTodos = _useCases.getLocalTodos();

      if (result.isNotEmpty) {
        // Use a combinação dos dois conjuntos de dados
        final Map<int, TodoEntity> todoMap = {};

        // Primeiro adiciona os locais
        for (var todo in localTodos) {
          // Pula tarefas que foram excluídas localmente
          if (_deletedIds.contains(todo.id)) continue;
          todoMap[todo.id] = todo;
        }

        // Depois adiciona os da API (não sobrescreve os locais com mesmo ID)
        for (var todo in result) {
          // Pula tarefas que foram excluídas localmente
          if (_deletedIds.contains(todo.id)) continue;
          if (!todoMap.containsKey(todo.id)) {
            todoMap[todo.id] = todo;
          }
        }

        _todos = todoMap.values.toList();
      } else {
        // Se não houver dados no repositório, usa os dados locais
        // (filtrando os que foram excluídos)
        _todos =
            localTodos.where((todo) => !_deletedIds.contains(todo.id)).toList();
      }

      _sortTodosByCompletion(); // Garante a ordem correta após carregar
      _error = null;
      _initialized = true;
    } catch (e) {
      // Em caso de erro, usa os dados locais (filtrando os que foram excluídos)
      _todos = _useCases
          .getLocalTodos()
          .where((todo) => !_deletedIds.contains(todo.id))
          .toList();
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
      final updatedTodo = await _useCases.toggleTodoCompletion(todo);
      if (updatedTodo != null) {
        // Remove o todo da posição atual
        _todos.removeWhere((t) => t.id == todo.id);

        // Reorganiza a lista mantendo a ordem de seções
        final incompleteTodos = _todos.where((t) => !t.completed).toList();
        final completedTodos = _todos.where((t) => t.completed).toList();

        // Adiciona o todo atualizado na seção correta
        if (updatedTodo.completed) {
          // Se está concluída, coloca no início das concluídas
          completedTodos.insert(0, updatedTodo);
          _todos = [...incompleteTodos, ...completedTodos];
        } else {
          // Se não está concluída, coloca no início das não concluídas
          incompleteTodos.insert(0, updatedTodo);
          _todos = [...incompleteTodos, ...completedTodos];
        }

        _error = null;
        notifyListeners();
      } else {
        _error = 'Erro ao atualizar status da tarefa';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Update an existing todo
  Future<void> updateTodo(TodoEntity todo) async {
    try {
      // Verifica se a tarefa foi excluída
      if (_deletedIds.contains(todo.id)) {
        _error = 'Tarefa não existe mais';
        notifyListeners();
        return;
      }

      // Encontra a posição atual da tarefa na lista
      final index = _todos.indexWhere((t) => t.id == todo.id);
      final existsInList = index != -1;

      // Se a tarefa não existe na lista
      if (!existsInList) {
        // Adiciona a tarefa como nova no início da seção correta
        final incompleteTodos = _todos.where((t) => !t.completed).toList();
        final completedTodos = _todos.where((t) => t.completed).toList();

        if (todo.completed) {
          completedTodos.insert(0, todo);
        } else {
          incompleteTodos.insert(0, todo);
        }

        _todos = [...incompleteTodos, ...completedTodos];
        _error = null;
        notifyListeners();
        return;
      }

      // A tarefa existe, vamos verificar se o status de conclusão mudou
      final currentTodo = _todos[index];
      final statusChanged = currentTodo.completed != todo.completed;

      if (!statusChanged) {
        // Se apenas o texto foi modificado (status não mudou), mantém a tarefa na mesma posição exata
        _todos[index] = todo;
        _error = null;
        notifyListeners();
        return;
      }

      // Se o status de conclusão mudou, reorganiza a lista

      // Remove a tarefa da posição atual
      _todos.removeAt(index);

      // Obtém as listas de tarefas incompletas e completas
      final incompleteTodos = _todos.where((t) => !t.completed).toList();
      final completedTodos = _todos.where((t) => t.completed).toList();

      // Adiciona a tarefa na seção correta
      if (todo.completed) {
        // Se mudou para completada, coloca no início da seção de completadas
        completedTodos.insert(0, todo);
      } else {
        // Se mudou para não completada, coloca no início da seção de não completadas
        incompleteTodos.insert(0, todo);
      }

      // Reconstrói a lista
      _todos = [...incompleteTodos, ...completedTodos];
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Delete a todo
  Future<void> deleteTodo(int id) async {
    try {
      // Registra o ID como excluído
      _deletedIds.add(id);

      // Remove da lista de exibição imediatamente
      final existingIndex = _todos.indexWhere((todo) => todo.id == id);
      if (existingIndex != -1) {
        _todos.removeAt(existingIndex);
        notifyListeners(); // Notifica UI imediatamente
      }

      // Depois remove do storage local
      await _useCases.deleteTodo(id);
      _error = null;
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
