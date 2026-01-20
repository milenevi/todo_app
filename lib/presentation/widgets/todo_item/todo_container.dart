import 'package:flutter/material.dart';

class TodoContainer extends StatelessWidget {

  const TodoContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF384060) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: child,
    );
  }
}
