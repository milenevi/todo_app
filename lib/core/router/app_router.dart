import 'package:flutter/material.dart';
import '../../presentation/screens/todo_list_screen.dart';
import '../../presentation/screens/todo_detail_screen.dart';
import '../../presentation/screens/about_screen.dart';

enum AppRoute {
  home,

  todoDetails,

  about,
}

class AppRouter {
  static const String homeRoute = '/';
  static const String todoDetailRoute = '/todo-detail';

  /// Navigate to a route
  static Future<dynamic> navigateTo(
    BuildContext context,
    AppRoute route, {
    Object? arguments,
  }) async {
    switch (route) {
      case AppRoute.home:
        return await Navigator.pushReplacementNamed(context, '/');
      case AppRoute.todoDetails:
        return await Navigator.pushNamed(
          context,
          '/todo-detail',
          arguments: arguments,
        );
      case AppRoute.about:
        return await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AboutScreen()),
        );
    }
  }

  /// Retorna para a tela anterior com resultado
  static void goBack(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }

  /// Generate routes for MaterialApp
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      homeRoute: (context) => const TodoListScreen(),
    };
  }

  /// Generate route for onGenerateRoute callback
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case todoDetailRoute:
        final todoId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => TodoDetailScreen(todoId: todoId),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const TodoListScreen(),
          settings: settings,
        );
    }
  }

  /// Handle unknown routes
  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Nenhuma rota definida para ${settings.name}'),
        ),
      ),
    );
  }
}
