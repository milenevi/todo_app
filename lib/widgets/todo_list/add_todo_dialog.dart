import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/todo_provider.dart';

class AddTodoDialog {
  static void show(BuildContext context, TextEditingController textController) {
    textController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter task description',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                Provider.of<TodoProvider>(context, listen: false)
                    .addTodo(textController.text);
                Navigator.of(context).pop();
                textController.clear();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
