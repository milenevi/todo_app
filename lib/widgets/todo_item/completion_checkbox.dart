import 'package:flutter/material.dart';
import '../../../models/todo.dart';

class CompletionCheckbox extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;

  const CompletionCheckbox({
    Key? key,
    required this.todo,
    required this.onTap,
  }) : super(key: key);

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
