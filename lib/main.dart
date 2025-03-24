import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/todo_list_screen.dart';
import 'providers/todo_provider.dart';
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
        ChangeNotifierProvider(create: (_) => TodoProvider()),
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
            home: const TodoListScreen(),
          );
        },
      ),
    );
  }
}