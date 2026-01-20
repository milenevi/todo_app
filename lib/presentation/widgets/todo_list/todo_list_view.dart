import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../providers/todo_provider.dart';
import '../todo_item.dart';
import 'section_title.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return ListView(
      children: [
        if (todoProvider.incompleteTodos.isNotEmpty) ...[
          const SectionTitle(title: 'TO DO'),
          const SizedBox(height: 8),
          ...todoProvider.incompleteTodos.map(
            (todo) => TodoItem(
              todo: todo,
              onToggleCompletion: () => todoProvider.toggleTodoCompletion(todo),
              onTodoSelected: (todoId) async {
                await AppRouter.navigateTo(
                  context,
                  AppRoute.todoDetails,
                  arguments: todoId,
                );

                // Não recarregamos a lista após edição ou exclusão
                // porque o provider já foi atualizado diretamente
              },
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
              onTodoSelected: (todoId) async {
                await AppRouter.navigateTo(
                  context,
                  AppRoute.todoDetails,
                  arguments: todoId,
                );

                // Não recarregamos a lista após edição ou exclusão
                // porque o provider já foi atualizado diretamente
              },
            ),
          ),
        ],
      ],
    );
  }
}
