import 'package:flutter/material.dart';
import '../../../domain/entities/todo_entity.dart';

class CompletionCheckbox extends StatelessWidget {

  const CompletionCheckbox({
    super.key,
    required this.todo,
    required this.onTap,
  });
  final TodoEntity todo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: todo.completed
              ? Colors.green.withAlpha(51)
              : (isDarkMode ? Colors.white : Colors.white),
          border: Border.all(
            color: todo.completed ? Colors.green : Colors.grey.withAlpha(128),
            width: 2,
          ),
        ),
        child: todo.completed
            ? const Icon(
                Icons.check,
                size: 20,
                color: Colors.green,
              )
            : null,
      ),
    );
  }
}
