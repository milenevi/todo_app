import 'package:flutter/material.dart';

class DueDate extends StatelessWidget {
  final bool isCompleted;
  final bool isDarkMode;

  const DueDate({
    Key? key,
    required this.isCompleted,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}
