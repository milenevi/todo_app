import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoDetailScreen extends StatefulWidget {
  final int todoId;

  const TodoDetailScreen({
    Key? key,
    required this.todoId,
  }) : super(key: key);

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late TextEditingController _textController;
  late Todo _todo;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _todo = Provider.of<TodoProvider>(context, listen: false)
        .todos
        .firstWhere((todo) => todo.id == widget.todoId);
    _textController = TextEditingController(text: _todo.todo);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        // Save changes
        final updatedTodo = _todo.copyWith(todo: _textController.text);
        Provider.of<TodoProvider>(context, listen: false)
            .updateTodo(updatedTodo);
        _todo = updatedTodo;
      }
      _isEditing = !_isEditing;
    });
  }

  void _deleteTodo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Mostrar indicador de carregamento
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                // Deletar a task
                Provider.of<TodoProvider>(context, listen: false)
                    .deleteTodo(widget.todoId);

                // Fechar o diálogo de confirmação
                Navigator.of(context).pop();

                // Fechar o diálogo de carregamento
                Navigator.of(context).pop();

                // Voltar para a lista
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } catch (e) {
                // Fechar o diálogo de carregamento
                Navigator.of(context).pop();

                // Mostrar mensagem de erro
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting task: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTodo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isEditing)
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Task Description',
                ),
                autofocus: true,
              )
            else
              Text(
                _todo.todo,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Status: '),
                Consumer<TodoProvider>(
                  builder: (context, todoProvider, child) {
                    final todo = todoProvider.todos
                        .firstWhere((t) => t.id == widget.todoId);
                    return Switch(
                      value: todo.completed,
                      onChanged: (value) {
                        todoProvider.toggleTodoCompletion(todo);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
