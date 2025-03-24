import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/completion_circle.dart';
import '../components/due_date.dart';
import '../components/todo_text.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../screens/todo_detail_screen.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF384060) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: CompletionCircle(
          isCompleted: todo.completed,
          isDarkMode: isDarkMode,
          onTap: () {
            Provider.of<TodoProvider>(context, listen: false)
                .toggleTodoCompletion(todo);
          },
        ),
        title: TodoText(
          text: todo.todo,
          isCompleted: todo.completed,
          isDarkMode: isDarkMode,
        ),
        trailing: DueDate(
          isCompleted: todo.completed,
          isDarkMode: isDarkMode,
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TodoDetailScreen(todoId: todo.id),
            ),
          );
        },
      ),
    );
  }
}