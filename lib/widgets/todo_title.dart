import 'package:flutter/material.dart';
import '../../models/todo.dart';

class TodoTitle extends StatelessWidget {
  final Todo todo;

  const TodoTitle({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Text(
      todo.todo,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: isDarkMode ? Colors.white70 : Colors.black87,
        decoration: todo.completed ? TextDecoration.lineThrough : null,
        decorationColor: Colors.grey,
      ),
    );
  }
}
