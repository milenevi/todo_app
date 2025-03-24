import 'package:flutter/material.dart';
import '../../models/todo.dart';

class DueDateIndicator extends StatelessWidget {
  final Todo todo;

  const DueDateIndicator({
    Key? key,
    required this.todo,
  }) : super(key: key);

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
