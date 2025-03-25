import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/usecases/todo_usecases.dart';
import '../providers/todo_provider.dart';
import 'todo_list_controller.dart';

/// Factory class for creating TodoListController instances
class TodoListControllerFactory {
  /// Creates a TodoListController with dependencies from the provider tree
  static TodoListController create(BuildContext context) {
    return TodoListController(
      todoProvider: Provider.of<TodoProvider>(context, listen: false),
      useCases: Provider.of<TodoUseCases>(context, listen: false),
    );
  }
}
