import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/todo_provider.dart';
import 'presentation/theme/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => sl<TodoProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Todo App',
            theme: themeProvider.isDarkMode
                ? AppThemes.getDarkTheme()
                : AppThemes.getLightTheme(),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: AppRouter.getRoutes(),
            onGenerateRoute: AppRouter.generateRoute,
            onUnknownRoute: AppRouter.unknownRoute,
          );
        },
      ),
    );
  }
}
