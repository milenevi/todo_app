import 'package:flutter/material.dart';

import '../../presentation/screens/about_screen.dart';
import '../../presentation/screens/todo_detail_screen.dart';
import '../../presentation/screens/todo_list_screen.dart';

enum AppRoute {
  home,

  todoDetails,

  about,
}

class AppRouter {
  static const String homeRoute = '/';
  static const String todoDetailRoute = '/todo-detail';
  static const String aboutRoute = '/about';

  /// Navigate to a route
  static Future<dynamic> navigateTo(
    BuildContext context,
    AppRoute route, {
    Object? arguments,
  }) async {
    switch (route) {
      case AppRoute.home:
        return await Navigator.pushReplacementNamed(context, homeRoute);
      case AppRoute.todoDetails:
        return await Navigator.pushNamed(
          context,
          todoDetailRoute,
          arguments: arguments,
        );
      case AppRoute.about:
        return await Navigator.pushNamed(context, aboutRoute);
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
      aboutRoute: (context) => const AboutScreen(),
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
