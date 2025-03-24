import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/usecases/todo_usecases.dart';
import 'todo_detail_controller.dart';

class TodoDetailControllerFactory {
  static TodoDetailController create(BuildContext context, int todoId) {
    return TodoDetailController(
      todoId: todoId,
      useCases: context.read<TodoUseCases>(),
    );
  }
}
