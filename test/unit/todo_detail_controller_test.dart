import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_app/controllers/todo_detail_controller.dart';
import 'package:todo_app/domain/usecases/todo_usecases.dart';
import 'todo_detail_controller_test.mocks.dart';

// Uma classe simples para substituir BuildContext nos testes
class TestBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

@GenerateMocks([TodoUseCases])
void main() {
  late TodoDetailController controller;
  late MockTodoUseCases mockUseCases;

  setUp(() {
    mockUseCases = MockTodoUseCases();
    controller = TodoDetailController(todoId: 1, useCases: mockUseCases);
  });

  group('TodoDetailController', () {
    test('should initialize with correct values', () {
      expect(controller.todoId, equals(1));
      expect(controller.todo.value, isNull);
      expect(controller.isLoading.value, isFalse);
      expect(controller.error.value, isNull);
    });

    test('should dispose resources', () {
      // Basta verificar que não lança exceção
      expect(() => controller.dispose(), returnsNormally);
    });
  });
}
