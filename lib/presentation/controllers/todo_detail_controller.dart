import 'package:flutter/material.dart';

import '../../core/router/app_router.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/todo_usecases.dart';
import '../providers/todo_provider.dart';
import '../utils/ui_helpers.dart';
import '../widgets/todo_detail/delete_confirmation_dialog.dart';

/// Controller for the Todo Detail screen
class TodoDetailController extends ChangeNotifier {

  /// Creates a new TodoDetailController
  TodoDetailController({
    required TodoUseCases useCases,
    required TodoProvider todoProvider,
    required this.todoId,
  })  : _useCases = useCases,
        _todoProvider = todoProvider {
    loadTodo(todoId);
  }
  final TodoUseCases _useCases;
  final TodoProvider _todoProvider;
  final int todoId;

  /// Value notifier for loading state
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  /// Value notifier for error state
  final ValueNotifier<String?> _error = ValueNotifier<String?>(null);

  /// Value notifier for the current todo
  final ValueNotifier<TodoEntity?> _todo = ValueNotifier<TodoEntity?>(null);

  ValueNotifier<TodoEntity?> get todo => _todo;
  ValueNotifier<bool> get isLoading => _isLoading;
  ValueNotifier<String?> get error => _error;

  /// Loads the todo from the repository
  Future<bool> loadTodo(int id) async {
    _isLoading.value = true;
    _error.value = null;
    notifyListeners();

    try {
      // Primeiro tenta buscar do provider
      final todo = _todoProvider.findTodoById(id);
      if (todo != null) {
        _todo.value = todo;
        _error.value = null;
        _isLoading.value = false;
        notifyListeners();
        return true;
      }

      // Se não encontrou no provider, tenta buscar via usecase (que vai ao repositório)
      final todoFromUseCase = await _useCases.getTodoById(id);
      if (todoFromUseCase != null) {
        _todo.value = todoFromUseCase;
        _error.value = null;
        _isLoading.value = false;
        notifyListeners();
        return true;
      }

      _error.value = 'Tarefa não encontrada';
      _isLoading.value = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error.value = 'Erro ao carregar tarefa: $e';
      _isLoading.value = false;
      notifyListeners();
      return false;
    }
  }

  /// Carrega o todo e atualiza o controller de texto
  Future<void> loadTodoAndUpdateTextField(
      TextEditingController titleController) async {
    await loadTodo(todoId);
    if (_todo.value != null) {
      titleController.text = _todo.value!.todo;
    }
  }

  /// Updates the todo
  Future<bool> updateTodoItem(TodoEntity todo) async {
    try {
      if (todo.todo.trim().isEmpty) {
        _error.value = 'A descrição da tarefa não pode estar vazia';
        notifyListeners();
        return false;
      }

      // Atualiza o usecase para garantir persistência
      final updated = await _useCases.updateTodo(todo);

      if (updated != null) {
        // Atualiza o provider com a tarefa atualizada
        await _todoProvider.updateTodo(updated);

        _todo.value = updated;
        _error.value = null;
        notifyListeners();
        return true;
      } else {
        // Se falhou no usecase, tenta adicionar em vez de atualizar
        final created = await _useCases.createTodo(todo.todo);
        if (created != null) {
          await _todoProvider.updateTodo(created);
          _todo.value = created;
          _error.value = null;
          notifyListeners();
          return true;
        }

        _error.value =
            'Erro ao atualizar tarefa: não foi possível encontrar ou criar a tarefa';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error.value = 'Erro ao atualizar tarefa: $e';
      notifyListeners();
      return false;
    }
  }

  /// Salva a tarefa com o novo título
  Future<bool> saveTodo(String title) async {
    if (title.trim().isEmpty) {
      _error.value = 'A descrição da tarefa não pode estar vazia';
      notifyListeners();
      return false;
    }

    final currentTodo = _todo.value;
    if (currentTodo == null) {
      _error.value = 'Tarefa não encontrada';
      notifyListeners();
      return false;
    }

    final updatedTodo = currentTodo.copyWith(
      todo: title,
    );

    return await updateTodoItem(updatedTodo);
  }

  /// Salva a tarefa e gerencia a navegação e feedback
  Future<void> saveAndNavigateBack(
      BuildContext context, String title, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final success = await saveTodo(title);

    if (!context.mounted) return;

    if (success) {
      // Retorna null em vez de true para não forçar recarregamento
      AppRouter.goBack(context, null);
      UIHelpers.showSuccess(context, 'Tarefa atualizada com sucesso!');
    } else if (_error.value != null) {
      UIHelpers.showError(context, _error.value!);
    }
  }

  /// Confirma e executa a exclusão da tarefa
  Future<void> confirmAndDeleteTodo(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteConfirmationDialog(),
    );

    if (confirmed != true || !context.mounted) return;

    final success = await removeTodo();

    if (!context.mounted) return;

    if (success) {
      // Retorna false para indicar que a tarefa foi excluída e não deve recarregar a lista
      AppRouter.goBack(context, false);
      UIHelpers.showSuccess(context, 'Tarefa excluída com sucesso!');
    } else if (_error.value != null) {
      UIHelpers.showError(context, _error.value!);
    }
  }

  /// Deletes the todo
  Future<bool> removeTodo() async {
    if (_todo.value == null) return false;

    try {
      final todoId = _todo.value!.id;

      // Remove dos dados locais primeiro
      final success = await _useCases.deleteTodo(todoId);

      // Depois remove do provider (que atualiza a UI)
      await _todoProvider.deleteTodo(todoId);

      if (success) {
        _todo.value = null;
        _error.value = null;
        notifyListeners();
        return true;
      } else {
        _error.value = 'Erro ao excluir tarefa';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error.value = 'Erro ao excluir tarefa: $e';
      notifyListeners();
      return false;
    }
  }

  /// Disposes resources
  @override
  void dispose() {
    _todo.dispose();
    _isLoading.dispose();
    _error.dispose();
    super.dispose();
  }
}
