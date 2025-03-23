import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item.dart';
import '../theme/theme_provider.dart';
import '../theme/app_colors.dart';
import 'about_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
            () => Provider.of<TodoProvider>(context, listen: false).fetchTodos());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(
            hintText: 'Enter task description',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _textController.clear();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                Provider.of<TodoProvider>(context, listen: false)
                    .addTodo(_textController.text);
                Navigator.of(context).pop();
                _textController.clear();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white54
                : Colors.black54,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'CHORES',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white54
                  : Colors.black54,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          if (todoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (todoProvider.error != null) {
            return Center(child: Text(todoProvider.error!));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkSecondary
                        : AppColors.lightSecondary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Add Item',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.add, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: _showAddTodoDialog,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      if (todoProvider.incompleteTodos.isNotEmpty) ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'TO DO',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...todoProvider.incompleteTodos
                            .map((todo) => TodoItem(todo: todo)),
                      ],
                      if (todoProvider.completedTodos.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'COMPLETED',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...todoProvider.completedTodos
                            .map((todo) => TodoItem(todo: todo)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
