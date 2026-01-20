import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/domain/entities/todo_entity.dart';

void main() {
  group('Todo Model', () {
    test('should create a TodoModel instance with correct values', () {
      final todo = TodoModel(id: 1, todo: 'Test todo', completed: false, userId: 1);

      expect(todo.id, equals(1));
      expect(todo.todo, equals('Test todo'));
      expect(todo.completed, equals(false));
      expect(todo.userId, equals(1));
    });

    test('should be a subclass of TodoEntity', () {
      final todo = TodoModel(id: 1, todo: 'Test todo', completed: false, userId: 1);

      expect(todo, isA<TodoEntity>());
    });

    test('should create a TodoModel from JSON', () {
      final json = {
        'id': 1,
        'todo': 'Test todo',
        'completed': false,
        'userId': 1,
      };

      final todo = TodoModel.fromJson(json);

      expect(todo.id, equals(1));
      expect(todo.todo, equals('Test todo'));
      expect(todo.completed, equals(false));
      expect(todo.userId, equals(1));
    });

    test('should convert TodoModel to JSON', () {
      final todo = TodoModel(id: 1, todo: 'Test todo', completed: false, userId: 1);

      final json = todo.toJson();

      expect(json['id'], equals(1));
      expect(json['todo'], equals('Test todo'));
      expect(json['completed'], equals(false));
      expect(json['userId'], equals(1));
    });

    test('should create TodoModel from Entity', () {
      const entity = TodoEntity(id: 1, todo: 'Test todo', completed: false, userId: 1);

      final model = TodoModel.fromEntity(entity);

      expect(model.id, equals(entity.id));
      expect(model.todo, equals(entity.todo));
      expect(model.completed, equals(entity.completed));
      expect(model.userId, equals(entity.userId));
    });
  });
}