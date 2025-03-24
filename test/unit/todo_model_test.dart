import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/todo.dart';

void main() {
  group('Todo Model', () {
    test('should create a Todo object from constructor', () {
      // Arrange
      const id = 1;
      const todoText = 'Buy groceries';
      const completed = false;
      const userId = 1;

      // Act
      final todo = Todo(
        id: id,
        todo: todoText,
        completed: completed,
        userId: userId,
      );

      // Assert
      expect(todo.id, equals(id));
      expect(todo.todo, equals(todoText));
      expect(todo.completed, equals(completed));
      expect(todo.userId, equals(userId));
    });

    test('should create a Todo object from JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'todo': 'Buy groceries',
        'completed': false,
        'userId': 1,
      };

      // Act
      final todo = Todo.fromJson(json);

      // Assert
      expect(todo.id, equals(1));
      expect(todo.todo, equals('Buy groceries'));
      expect(todo.completed, equals(false));
      expect(todo.userId, equals(1));
    });

    test('should convert Todo object to JSON', () {
      // Arrange
      final todo = Todo(
        id: 1,
        todo: 'Buy groceries',
        completed: false,
        userId: 1,
      );

      // Act
      final json = todo.toJson();

      // Assert
      expect(
          json,
          equals({
            'id': 1,
            'todo': 'Buy groceries',
            'completed': false,
            'userId': 1,
          }));
    });

    test('should create a copy with modified values', () {
      // Arrange
      final todo = Todo(
        id: 1,
        todo: 'Buy groceries',
        completed: false,
        userId: 1,
      );

      // Act
      final modifiedTodo = todo.copyWith(
        todo: 'Buy fruits',
        completed: true,
      );

      // Assert
      expect(modifiedTodo.id, equals(todo.id));
      expect(modifiedTodo.todo, equals('Buy fruits'));
      expect(modifiedTodo.completed, equals(true));
      expect(modifiedTodo.userId, equals(todo.userId));
    });
  });
}
