// import 'package:dartz/dartz.dart';
import '../../core/result/result.dart';
import '../repositories/todo_repository.dart';

/// Use case for delete a todo by id
class DeleteTodo {

  DeleteTodo(this.repository);
  final TodoRepository repository;

  Future<Result<bool>> call(int id) async {
    return await repository.deleteTodo(id);
  }
}
