import 'package:flutter/material.dart';

class CompletionCircle extends StatelessWidget {
  final bool isCompleted;
  final bool isDarkMode;
  final VoidCallback onTap;

  const CompletionCircle({
    Key? key,
    required this.isCompleted,
    required this.isDarkMode,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted
              ? Colors.green.withAlpha(51)
              : (isDarkMode ? Colors.white : Colors.white),
          border: Border.all(
            color: isCompleted ? Colors.green : Colors.grey.withAlpha(128),
            width: 2,
          ),
        ),
        child: isCompleted
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
