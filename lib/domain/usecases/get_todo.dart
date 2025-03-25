// import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/result/result.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use case for get a todo by id
class GetTodo {
  final TodoRepository repository;

  GetTodo(this.repository);

  Future<Result<TodoEntity>> call(int id) async {
    return await repository.getTodoById(id);
  }
}
