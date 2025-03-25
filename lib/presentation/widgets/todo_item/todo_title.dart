import 'package:flutter/material.dart';
import '../../../domain/entities/todo_entity.dart';

class TodoTitle extends StatelessWidget {
  final TodoEntity todo;

  const TodoTitle({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      todo.todo,
      style: TextStyle(
        decoration: todo.completed ? TextDecoration.lineThrough : null,
        color: todo.completed ? Colors.grey : null,
      ),
    );
  }
}
