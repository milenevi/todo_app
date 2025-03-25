// import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/result/result.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use case for update an existing todo
class UpdateTodo {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  Future<Result<TodoEntity>> call(TodoEntity todo) async {
    return await repository.updateTodo(todo);
  }
}
