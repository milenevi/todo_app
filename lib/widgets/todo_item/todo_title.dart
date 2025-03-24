import 'package:flutter/material.dart';
import '../../domain/models/todo.dart';

class TodoTitle extends StatelessWidget {
  final Todo todo;

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
