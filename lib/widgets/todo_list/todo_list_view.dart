import 'package:flutter/material.dart';
import '../../providers/todo_provider.dart';
import '../todo_item.dart';
import 'section_title.dart';

class TodoListView extends StatelessWidget {
  final TodoProvider todoProvider;

  const TodoListView({super.key, required this.todoProvider});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (todoProvider.incompleteTodos.isNotEmpty) ...[
          const SectionTitle(title: 'TO DO'),
          const SizedBox(height: 8),
          ...todoProvider.incompleteTodos.map(
            (todo) => TodoItem(
              todo: todo,
              onToggleCompletion: () => todoProvider.toggleTodoCompletion(todo),
              onTodoSelected:
                  (todoId) => Navigator.of(
                    context,
                  ).pushNamed('/todo-detail', arguments: todoId),
            ),
          ),
        ],
        if (todoProvider.completedTodos.isNotEmpty) ...[
          const SizedBox(height: 16),
          const SectionTitle(title: 'COMPLETED'),
          const SizedBox(height: 8),
          ...todoProvider.completedTodos.map(
            (todo) => TodoItem(
              todo: todo,
              onToggleCompletion: () => todoProvider.toggleTodoCompletion(todo),
              onTodoSelected:
                  (todoId) => Navigator.of(
                    context,
                  ).pushNamed('/todo-detail', arguments: todoId),
            ),
          ),
        ],
      ],
    );
  }
}
