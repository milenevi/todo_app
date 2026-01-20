// import 'package:dartz/dartz.dart';
import '../../core/result/result.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use case for get all todos
class GetTodos {

  GetTodos(this.repository);
  final TodoRepository repository;

  Future<Result<List<TodoEntity>>> call() async {
    return await repository.getTodos();
  }
}
