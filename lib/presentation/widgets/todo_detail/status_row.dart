import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/todo_provider.dart';

class StatusRow extends StatelessWidget {

  const StatusRow({super.key, required this.todoId});
  final int todoId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Status: '),
        Consumer<TodoProvider>(
          builder: (context, todoProvider, child) {
            final todo = todoProvider.findTodoById(todoId);
            if (todo != null) {
              return Switch(
                value: todo.completed,
                onChanged: (value) {
                  todoProvider.toggleTodoCompletion(todo);
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
