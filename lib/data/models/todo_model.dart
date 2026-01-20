import '../../domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {

  factory TodoModel.fromEntity(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      todo: entity.todo,
      completed: entity.completed,
      userId: entity.userId,
    );
  }
  TodoModel({
    required super.id,
    required super.todo,
    required super.completed,
    required super.userId,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as int,
      todo: json['todo'] as String,
      completed: json['completed'] as bool,
      userId: json['userId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }
}
