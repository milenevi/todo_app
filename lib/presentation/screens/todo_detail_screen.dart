import 'package:flutter/material.dart';
import '../controllers/todo_detail_controller.dart';
import '../controllers/todo_detail_controller_factory.dart';
import '../widgets/todo_detail/task_content.dart';

class TodoDetailScreen extends StatefulWidget {
  final int todoId;

  const TodoDetailScreen({
    super.key,
    required this.todoId,
  });

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late final TodoDetailController _controller;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = TodoDetailControllerFactory.create(context, widget.todoId);
    _controller.loadTodoAndUpdateTextField(_titleController);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Tarefa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _controller.confirmAndDeleteTodo(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          _controller.isLoading,
          _controller.error,
          _controller.todo,
        ]),
        builder: (context, _) {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.error.value != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _controller.error.value!,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _controller
                        .loadTodoAndUpdateTextField(_titleController),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          final todo = _controller.todo.value;
          if (todo == null) {
            return const Center(
              child: Text('Tarefa não encontrada'),
            );
          }

          return TaskContent(
            todo: todo,
            titleController: _titleController,
            formKey: _formKey,
            onToggleComplete: (updatedTodo) {
              _controller.updateTodoItem(updatedTodo);
            },
            onSave: () => _controller.saveAndNavigateBack(
                context, _titleController.text, _formKey),
          );
        },
      ),
    );
  }
}
