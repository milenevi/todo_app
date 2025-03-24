import '../domain/models/todo.dart';
import '../repositories/todo_repository.dart';
import 'todo_state.dart';

class TodoOperations {
  final TodoRepository _repository;

  TodoOperations({required TodoRepository repository})
      : _repository = repository;

  /// Adiciona uma nova tarefa ao estado
  ///
  /// Retorna um novo estado com a tarefa adicionada ou um erro
  TodoState addTodo(TodoState state, String title) {
    // Validar entrada
    if (title.trim().isEmpty) {
      return state.copyWith(
        error: 'Task description cannot be empty',
      );
    }

    try {
      // Calcular o próximo ID baseado no valor mais alto existente
      final newId = _calculateNextId(state.todos);

      // Criar nova tarefa
      final newTodo = Todo(
        id: newId,
        todo: title,
        completed: false,
        userId: 1, // Using a default userId
      );

      // Adicionar a nova tarefa no início da lista
      final updatedTodos = [newTodo, ...state.todos];

      // Retornar estado atualizado
      return state.copyWith(
        todos: updatedTodos,
        error: null,
      );
    } catch (e) {
      return state.copyWith(
        error: 'Failed to add todo: ${e.toString()}',
      );
    }
  }

  /// Calcula o próximo ID baseado na lista de tarefas atual
  ///
  /// Retorna 1 se a lista estiver vazia, ou (maior ID + 1) caso contrário
  int _calculateNextId(List<Todo> todos) {
    if (todos.isEmpty) {
      return 1;
    }

    // Encontrar o ID mais alto na lista atual
    int highestId = 0;
    for (final todo in todos) {
      if (todo.id > highestId) {
        highestId = todo.id;
      }
    }

    // Retornar o próximo ID (maior ID + 1)
    return highestId + 1;
  }

  /// Alterna o status de conclusão de uma tarefa
  ///
  /// Retorna um novo estado com a tarefa atualizada
  TodoState toggleTodoCompletion(TodoState state, Todo todo) {
    // Criar uma tarefa atualizada com o status completado invertido
    final updatedTodo = todo.copyWith(completed: !todo.completed);

    // Encontrar o índice da tarefa na lista
    final index = state.todos.indexWhere((t) => t.id == todo.id);

    // Se a tarefa foi encontrada, atualize-a
    if (index != -1) {
      // Criar uma nova lista com a tarefa atualizada
      final updatedTodos = List<Todo>.from(state.todos);
      updatedTodos[index] = updatedTodo;

      // Retornar estado atualizado
      return state.copyWith(
        todos: updatedTodos,
        error: null,
      );
    }

    // Retornar estado sem alterações se a tarefa não foi encontrada
    return state;
  }

  /// Remove uma tarefa do estado
  ///
  /// Retorna um novo estado sem a tarefa removida ou com erro
  TodoState deleteTodo(TodoState state, int id) {
    // Encontrar o índice da tarefa a ser excluída
    final todoIndex = state.todos.indexWhere((todo) => todo.id == id);

    // Se a tarefa não foi encontrada, retornar erro
    if (todoIndex == -1) {
      return state.copyWith(
        error: 'Todo not found',
      );
    }

    try {
      // Criar uma nova lista sem a tarefa excluída
      final updatedTodos = List<Todo>.from(state.todos);
      updatedTodos.removeAt(todoIndex);

      // Retornar estado atualizado
      return state.copyWith(
        todos: updatedTodos,
        error: null,
      );
    } catch (e) {
      return state.copyWith(
        error: 'Error deleting todo: ${e.toString()}',
      );
    }
  }

  /// Atualiza uma tarefa existente
  ///
  /// Retorna um novo estado com a tarefa atualizada ou com erro
  TodoState updateTodo(TodoState state, Todo updatedTodo) {
    // Encontrar o índice da tarefa a ser atualizada
    final index = state.todos.indexWhere((todo) => todo.id == updatedTodo.id);

    // Se a tarefa não foi encontrada, retornar erro
    if (index == -1) {
      return state.copyWith(
        error: 'Todo not found',
      );
    }

    try {
      // Criar uma nova lista com a tarefa atualizada
      final updatedTodos = List<Todo>.from(state.todos);
      updatedTodos[index] = updatedTodo;

      // Retornar estado atualizado
      return state.copyWith(
        todos: updatedTodos,
        error: null,
      );
    } catch (e) {
      return state.copyWith(
        error: 'Failed to update todo: ${e.toString()}',
      );
    }
  }

  Future<List<Todo>> loadTodos() async {
    return _repository.fetchTodos();
  }

  Future<Todo> loadTodoById(int id) async {
    return _repository.fetchTodoById(id);
  }

  void dispose() {
    _repository.dispose();
  }
}
