/// TodoEntity represents a task in the application
class TodoEntity {

  const TodoEntity({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  /// Create a copy of this entity with some fields changed
  TodoEntity copyWith({
    int? id,
    String? todo,
    bool? completed,
    int? userId,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }

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
      'TodoEntity(id: $id, todo: $todo, completed: $completed, userId: $userId)';
}
