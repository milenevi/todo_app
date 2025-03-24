import 'package:flutter/material.dart';
import '../domain/models/todo.dart';
import 'todo_item/completion_checkbox.dart';
import 'todo_item/due_date_indicator.dart';
import 'todo_item/todo_container.dart';
import 'todo_item/todo_title.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggleCompletion;
  final ValueChanged<int> onTodoSelected;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggleCompletion,
    required this.onTodoSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TodoContainer(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: CompletionCheckbox(todo: todo, onTap: onToggleCompletion),
        title: TodoTitle(todo: todo),
        trailing: DueDateIndicator(todo: todo),
        onTap: () => onTodoSelected(todo.id),
      ),
    );
  }
}
