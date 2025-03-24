import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_app/controllers/todo_detail_controller.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/usecases/todo_usecases.dart';

import 'todo_detail_controller_test.mocks.dart';


@GenerateMocks([TodoUseCases])
void main() {
  late TodoDetailController controller;
  late MockTodoUseCases mockUseCases;
  late Todo testTodo;
  late BuildContext mockContext;

  setUp(() {
    mockUseCases = MockTodoUseCases();
    controller = TodoDetailController(
      todoId: 1,
      useCases: mockUseCases,
    );
    testTodo = Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1);
    mockContext = MockBuildContext();
  });

  group('TodoDetailController', () {
    test('should load todo successfully', () async {
      when(mockUseCases.getTodoById(1)).thenAnswer((_) async => testTodo);

      final success = await controller.loadTodo(mockContext);

      expect(success, true);
      expect(controller.todo.value, equals(testTodo));
      expect(controller.isLoading.value, false);
      expect(controller.error.value, isNull);
      verify(mockUseCases.getTodoById(1)).called(1);
    });

    test('should handle error when loading todo', () async {
      when(mockUseCases.getTodoById(1)).thenThrow(Exception('Test error'));

      final success = await controller.loadTodo(mockContext);

      expect(success, false);
      expect(controller.todo.value, isNull);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, equals('Test error'));
      verify(mockUseCases.getTodoById(1)).called(1);
    });

    test('should update todo successfully', () async {
      when(mockUseCases.updateTodo(any)).thenAnswer((_) async => testTodo);

      final success = await controller.updateTodo(mockContext, testTodo);

      expect(success, true);
      expect(controller.todo.value, equals(testTodo));
      expect(controller.isLoading.value, false);
      expect(controller.error.value, isNull);
      verify(mockUseCases.updateTodo(testTodo)).called(1);
    });

    test('should handle error when updating todo', () async {
      when(mockUseCases.updateTodo(any)).thenThrow(Exception('Test error'));

      final success = await controller.updateTodo(mockContext, testTodo);

      expect(success, false);
      expect(controller.todo.value, isNull);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, equals('Test error'));
      verify(mockUseCases.updateTodo(testTodo)).called(1);
    });

    test('should delete todo successfully', () async {
      when(mockUseCases.deleteTodo(1)).thenAnswer((_) async => true);

      final success = await controller.deleteTodo(mockContext);

      expect(success, true);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, isNull);
      verify(mockUseCases.deleteTodo(1)).called(1);
    });

    test('should handle error when deleting todo', () async {
      when(mockUseCases.deleteTodo(1)).thenThrow(Exception('Test error'));

      final success = await controller.deleteTodo(mockContext);

      expect(success, false);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, equals('Test error'));
      verify(mockUseCases.deleteTodo(1)).called(1);
    });

    test('should dispose resources', () {
      controller.dispose();
      verify(mockUseCases.dispose()).called(1);
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}
