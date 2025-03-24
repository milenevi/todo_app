import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/repositories/todo_repository_impl.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';
import 'package:todo_app/domain/usecases/todo_usecases.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/screens/todo_list_screen.dart';
import 'package:todo_app/screens/todo_detail_screen.dart';
import 'theme/app_themes.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TodoRepository>(
          create: (_) => TodoRepositoryImpl(),
        ),
        Provider<TodoUseCases>(
          create: (context) => TodoUseCases(
            repository: context.read<TodoRepository>(),
          ),
        ),
        ChangeNotifierProvider<TodoProvider>(
          create: (context) => TodoProvider(
            useCases: context.read<TodoUseCases>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Todo App',
            theme: AppThemes.getLightTheme(),
            darkTheme: AppThemes.getDarkTheme(),
            themeMode:
            themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const TodoListScreen(),
            routes: {
              '/todo-detail': (context) {
                final todoId =
                ModalRoute.of(context)!.settings.arguments as int;
                return TodoDetailScreen(todoId: todoId);
              },
            },
          );
        },
      ),
    );
  }
}
