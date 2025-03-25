// import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/result/result.dart';
import '../repositories/todo_repository.dart';

/// Use case for delete a todo by id
class DeleteTodo {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  Future<Result<bool>> call(int id) async {
    return await repository.deleteTodo(id);
  }
}
