import '../entities/todo_entity.dart';

/// Implementation of TodoEntity for use in the application
class Todo implements TodoEntity {
  @override
  final int id;

  @override
  final String todo;

  @override
  final bool completed;

  @override
  final int userId;

  Todo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          todo == other.todo &&
          completed == other.completed &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^ todo.hashCode ^ completed.hashCode ^ userId.hashCode;

  @override
  String toString() =>
      'Todo(id: $id, todo: $todo, completed: $completed, userId: $userId)';

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      todo: json['todo'] as String,
      completed: json['completed'] as bool,
      userId: json['userId'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'todo': todo, 'completed': completed, 'userId': userId};
  }

  @override
  Todo copyWith({int? id, String? todo, bool? completed, int? userId}) {
    return Todo(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }
}
