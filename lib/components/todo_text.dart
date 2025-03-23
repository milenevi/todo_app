import 'package:flutter/material.dart';

class TodoText extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final bool isDarkMode;

  const TodoText({
    Key? key,
    required this.text,
    required this.isCompleted,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: isDarkMode ? Colors.white70 : Colors.black87,
        decoration: isCompleted ? TextDecoration.lineThrough : null,
        decorationColor: Colors.grey,
      ),
    );
  }
}
