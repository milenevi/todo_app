import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/domain/models/todo.dart';

void main() {
  group('Todo Model', () {
    test('should create a Todo instance with correct values', () {
      final todo = Todo(
        id: 1,
        todo: 'Test todo',
        completed: false,
        userId: 1,
      );

      expect(todo.id, equals(1));
      expect(todo.todo, equals('Test todo'));
      expect(todo.completed, equals(false));
      expect(todo.userId, equals(1));
    });

    test('should create a Todo from JSON', () {
      final json = {
        'id': 1,
        'todo': 'Test todo',
        'completed': false,
        'userId': 1,
      };

      final todo = Todo.fromJson(json);

      expect(todo.id, equals(1));
      expect(todo.todo, equals('Test todo'));
      expect(todo.completed, equals(false));
      expect(todo.userId, equals(1));
    });

    test('should convert Todo to JSON', () {
      final todo = Todo(
        id: 1,
        todo: 'Test todo',
        completed: false,
        userId: 1,
      );

      final json = todo.toJson();

      expect(json['id'], equals(1));
      expect(json['todo'], equals('Test todo'));
      expect(json['completed'], equals(false));
      expect(json['userId'], equals(1));
    });

    test('should create a copy with modified values', () {
      final todo = Todo(
        id: 1,
        todo: 'Test todo',
        completed: false,
        userId: 1,
      );

      final modifiedTodo = todo.copyWith(
        todo: 'Modified todo',
        completed: true,
      );

      expect(modifiedTodo.id, equals(todo.id));
      expect(modifiedTodo.todo, equals('Modified todo'));
      expect(modifiedTodo.completed, equals(true));
      expect(modifiedTodo.userId, equals(todo.userId));
    });
  });
}
