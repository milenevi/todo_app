import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {

  const InfoSection({super.key, required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white38 : Colors.black38,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }
}
