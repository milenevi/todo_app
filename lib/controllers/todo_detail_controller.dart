import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoDetailController {
  final BuildContext context;
  final int todoId;
  final TextEditingController textController = TextEditingController();
  late Todo? todo;

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
      textController.text = todo!.todo;
      return true;
    } else {
      return false;
    }
  }

  void toggleEdit() {
    if (isEditing.value && todo != null) {
      // Save changes
      final updatedTodo = todo!.copyWith(todo: textController.text);
      Provider.of<TodoProvider>(context, listen: false).updateTodo(updatedTodo);
      todo = updatedTodo;
    }
    isEditing.value = !isEditing.value;
  }

  Future<bool> deleteTodo() async {
    isLoading.value = true;

    try {
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      await todoProvider.deleteTodo(todoId);
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }
}
