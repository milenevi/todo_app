import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_list/add_item_button.dart';
import '../widgets/todo_list/add_todo_dialog.dart';
import '../widgets/todo_list/app_bar_widget.dart';
import '../widgets/todo_list/divider_line.dart';
import '../widgets/todo_list/loading_error_handler.dart';
import '../widgets/todo_list/todo_list_view.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carregar tarefas após o primeiro frame
    Future.microtask(() {
      if (mounted) {
        context.read<TodoProvider>().fetchTodos();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TodoAppBar(),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return LoadingErrorHandler(
            isLoading: todoProvider.isLoading,
            errorMessage: todoProvider.error,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  AddItemButton(
                    onPressed: () =>
                        AddTodoDialog.show(context, _textController),
                  ),
                  const SizedBox(height: 24),
                  const DividerLine(),
                  const SizedBox(height: 24),
                  const Expanded(child: TodoListView()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
