import 'package:flutter/material.dart';
import '../../../domain/entities/todo_entity.dart';

class TaskContent extends StatelessWidget {

  const TaskContent({
    Key? key,
    required this.todo,
    required this.titleController,
    required this.formKey,
    required this.onToggleComplete,
    required this.onSave,
  }) : super(key: key);
  final TodoEntity todo;
  final TextEditingController titleController;
  final GlobalKey<FormState> formKey;
  final Function(TodoEntity) onToggleComplete;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Digite o título da tarefa',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, digite um título';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Concluída'),
              value: todo.completed,
              onChanged: (value) {
                final updatedTodo = todo.copyWith(completed: value);
                onToggleComplete(updatedTodo);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onSave,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
