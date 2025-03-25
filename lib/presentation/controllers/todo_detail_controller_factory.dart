import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/di/injection_container.dart';
import '../providers/todo_provider.dart';
import 'todo_detail_controller.dart';

/// Factory class for creating TodoDetailController instances
class TodoDetailControllerFactory {
  /// Creates a TodoDetailController with dependencies from the provider tree
  static TodoDetailController create(BuildContext context, int todoId) {
    return TodoDetailController(
      useCases: sl(),
      todoProvider: Provider.of<TodoProvider>(context, listen: false),
      todoId: todoId,
    );
  }
}
