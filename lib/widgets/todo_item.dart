import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/widgets/todo_container.dart';
import 'package:todo_app/widgets/todo_title.dart';
import '../components/completion_circle.dart';
import '../components/due_date.dart';
import '../components/todo_text.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../screens/todo_detail_screen.dart';
import 'completion_checkbox.dart';
import 'due_date_indicator.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TodoContainer(
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: CompletionCheckbox(
          todo: todo,
          onTap: () {
            Provider.of<TodoProvider>(context, listen: false)
                .toggleTodoCompletion(todo);
          },
        ),
        title: TodoTitle(todo: todo),
        trailing: DueDateIndicator(todo: todo),
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