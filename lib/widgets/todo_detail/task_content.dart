import 'package:flutter/material.dart';
import '../../domain/models/todo.dart';

class TaskContent extends StatelessWidget {
  final Todo? todo;
  final TextEditingController textController;
  final bool isEditing;
  final Function(Todo) onSave;
  final Function(bool) onStatusChanged;

  const TaskContent({
    super.key,
    required this.todo,
    required this.textController,
    required this.isEditing,
    required this.onSave,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (todo == null) {
      return const Center(child: Text('No task data available'));
    }

    return Container(
      color:
          isDarkMode
              ? const Color(0xFF1F2937) // Dark blue background for dark mode
              : const Color(0xFFF5F9FC), // Light blue background for light mode
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isEditing
              ? TextField(
                controller: textController,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  labelText: 'Task Description',
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                autofocus: true,
                onSubmitted: (value) {
                  onSave(todo!.copyWith(todo: value));
                },
              )
              : Text(
                todo!.todo,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              Switch(value: todo!.completed, onChanged: onStatusChanged),
            ],
          ),
        ],
      ),
    );
  }
}
