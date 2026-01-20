// import 'package:dartz/dartz.dart';
import '../../core/result/result.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use case for create a new todo
class CreateTodo {

  CreateTodo(this.repository);
  final TodoRepository repository;

  Future<Result<TodoEntity>> call(String title) async {
    return await repository.createTodo(title);
  }
}
