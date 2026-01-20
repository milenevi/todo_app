// import 'package:dartz/dartz.dart';
import '../../core/result/result.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use case for get a todo by id
class GetTodo {

  GetTodo(this.repository);
  final TodoRepository repository;

  Future<Result<TodoEntity>> call(int id) async {
    return await repository.getTodoById(id);
  }
}
