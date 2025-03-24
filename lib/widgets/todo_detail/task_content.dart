import 'package:flutter/material.dart';
import '../../models/todo.dart';

class TaskContent extends StatelessWidget {
  final Todo todo;
  final TextEditingController textController;
  final bool isEditing;

  const TaskContent({
    Key? key,
    required this.todo,
    required this.textController,
    required this.isEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isEditing
        ? TextField(
      controller: textController,
      decoration: const InputDecoration(
        labelText: 'Task Description',
      ),
      autofocus: true,
    )
        : Text(
      todo.todo,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
