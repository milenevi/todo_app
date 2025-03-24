import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_detail/delete_confirmation_dialog.dart';

class TodoDetailController {
  final BuildContext context;
  final int todoId;
  final TextEditingController textController = TextEditingController();
  late Todo todo;

  final ValueNotifier<bool> isEditing = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  TodoDetailController({
    required this.context,
    required this.todoId,
  });

  void dispose() {
    textController.dispose();
    isEditing.dispose();
    isLoading.dispose();
  }

  bool loadTodo() {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    final loadedTodo = todoProvider.findTodoById(todoId);

    if (loadedTodo != null) {
      todo = loadedTodo;
      textController.text = todo.todo;
      return true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task not found'),
            backgroundColor: Colors.red,
          ),
        );
      });
      return false;
    }
  }

  void toggleEdit() {
    if (isEditing.value) {
      // Save changes
      final updatedTodo = todo.copyWith(todo: textController.text);
      Provider.of<TodoProvider>(context, listen: false).updateTodo(updatedTodo);
      todo = updatedTodo;
    }
    isEditing.value = !isEditing.value;
  }

  Future<void> confirmDelete() async {
    final shouldDelete = await DeleteConfirmationDialog.show(context);

    if (shouldDelete == true) {
      await deleteTodo();
    }
  }

  Future<void> deleteTodo() async {
    isLoading.value = true;

    try {
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      await todoProvider.deleteTodo(todoId);

      isLoading.value = false;

      // Show success message and navigate back
      if (!_contextIsValid()) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!_contextIsValid()) return;

      isLoading.value = false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting task: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _contextIsValid() {
    try {
      return WidgetsBinding.instance.rootElement != null;
    } catch (e) {
      return false;
    }
  }
}
