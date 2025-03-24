import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/todo_provider.dart';

class StatusRow extends StatelessWidget {
  final int todoId;

  const StatusRow({
    Key? key,
    required this.todoId,
  }) : super(key: key);

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
