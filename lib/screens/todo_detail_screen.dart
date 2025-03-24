import 'package:flutter/material.dart';
import '../domain/models/todo.dart';
import '../controllers/todo_detail_controller.dart';
import '../controllers/todo_detail_controller_factory.dart';
import '../widgets/todo_detail/task_content.dart';
import '../widgets/todo_detail/detail_app_bar.dart';
import '../widgets/todo_detail/delete_confirmation_dialog.dart';

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
  late final TodoDetailController controller;
  late final TextEditingController _textController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    controller = TodoDetailControllerFactory.create(context, widget.todoId);
    _textController = TextEditingController();
    _loadTodo();
  }

  Future<void> _loadTodo() async {
    if (!mounted) return;

    final success = await controller.loadTodo(context);
    if (success && mounted) {
      _textController.text = controller.todo.value?.todo ?? '';
    }
  }

  Future<void> _deleteTodo() async {
    if (!mounted) return;
    final confirmed = await DeleteConfirmationDialog.show(context);

    if (confirmed == true && mounted) {
      final success = await controller.deleteTodo(context);
      if (success && mounted) {
        Navigator.of(context).pop(); // Pop detail screen
      }
    }
  }

  void _toggleEditing() {
    setState(() {
      if (_isEditing) {
        // Save changes
        final todo = controller.todo.value;
        if (todo != null) {
          _updateTodo(todo.copyWith(todo: _textController.text));
        }
      }
      _isEditing = !_isEditing;
    });
  }

  void _updateTodo(Todo updatedTodo) {
    controller.updateTodo(context, updatedTodo);
  }

  @override
  void dispose() {
    controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar(
        isEditing: _isEditing,
        onEditToggle: _toggleEditing,
        onDelete: _deleteTodo,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<String?>(
            valueListenable: controller.error,
            builder: (context, error, _) {
              if (error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(error),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadTodo,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return ValueListenableBuilder<Todo?>(
                valueListenable: controller.todo,
                builder: (context, todo, _) {
                  if (todo == null) {
                    return const Center(
                      child: Text('Todo not found'),
                    );
                  }

                  return TaskContent(
                    todo: todo,
                    textController: _textController,
                    isEditing: _isEditing,
                    onSave: _updateTodo,
                    onStatusChanged: (value) {
                      _updateTodo(todo.copyWith(completed: value));
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
