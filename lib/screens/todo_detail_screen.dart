import 'package:flutter/material.dart';
import '../controllers/todo_detail_controller.dart';
import '../widgets/todo_detail/delete_confirmation_dialog.dart';
import '../widgets/todo_detail/detail_app_bar.dart';
import '../widgets/todo_detail/loading_screen.dart';
import '../widgets/todo_detail/status_row.dart';
import '../widgets/todo_detail/task_content.dart';

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
  late TodoDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = TodoDetailController(
      context: context,
      todoId: widget.todoId,
    );
    _loadTodo();
  }

  void _loadTodo() {
    final success = controller.loadTodo();
    if (!success) {
      // Mostrar erro e voltar para a tela anterior
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task not found'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await DeleteConfirmationDialog.show(context);

    if (shouldDelete == true) {
      await _deleteTodo();
    }
  }

  Future<void> _deleteTodo() async {
    final success = await controller.deleteTodo();

    if (!mounted) return;

    if (success) {
      // Mostrar mensagem de sucesso e voltar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else {
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting task'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const LoadingScreen();
        }

        return ValueListenableBuilder<bool>(
          valueListenable: controller.isEditing,
          builder: (context, isEditing, _) {
            return Scaffold(
              appBar: DetailAppBar(
                isEditing: isEditing,
                onEditToggle: controller.toggleEdit,
                onDelete: _confirmDelete,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TaskContent(
                        todo: controller.todo,
                        textController: controller.textController,
                        isEditing: isEditing,
                      ),
                      const SizedBox(height: 16),
                      StatusRow(todoId: widget.todoId),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
