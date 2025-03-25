import 'package:flutter/material.dart';
import '../../../domain/entities/todo_entity.dart';

class DueDateIndicator extends StatelessWidget {
  final TodoEntity todo;

  const DueDateIndicator({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_today,
          size: 16,
          color: isDarkMode ? Colors.white30 : Colors.black26,
        ),
        const SizedBox(width: 4),
        Text(
          'Due today',
          style: TextStyle(
            color: isDarkMode ? Colors.white38 : Colors.black38,
            fontSize: 14,
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}
