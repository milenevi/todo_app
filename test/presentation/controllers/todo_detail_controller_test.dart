import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/domain/entities/todo_entity.dart';
import 'package:todo_app/domain/usecases/todo_usecases.dart';
import 'package:todo_app/presentation/controllers/todo_detail_controller.dart';
import 'package:todo_app/presentation/providers/todo_provider.dart';

import 'todo_detail_controller_test.mocks.dart';

@GenerateMocks([TodoUseCases, TodoProvider])
void main() {
  late TodoDetailController controller;
  late MockTodoUseCases mockUseCases;
  late MockTodoProvider mockTodoProvider;
  const testTodo = TodoEntity(id: 1, todo: 'Test Todo', completed: false, userId: 1);

  setUp(() {
    mockUseCases = MockTodoUseCases();
    mockTodoProvider = MockTodoProvider();

    // Mock básico para evitar erros durante o construtor (que chama loadTodo)
    when(mockTodoProvider.findTodoById(any)).thenReturn(null);
    when(mockUseCases.getTodoById(any)).thenAnswer((_) async => null);

    controller = TodoDetailController(
      todoId: 1,
      useCases: mockUseCases,
      todoProvider: mockTodoProvider,
    );
  });

  group('TodoDetailController', () {
    test('should initialize with correct values', () {
      expect(controller.todoId, equals(1));
    });

    test('should load todo successfully from provider', () async {
      // Arrange
      when(mockTodoProvider.findTodoById(1)).thenReturn(testTodo);

      // Act
      final result = await controller.loadTodo(1);

      // Assert
      expect(result, isTrue);
      expect(controller.todo.value, equals(testTodo));
      expect(controller.isLoading.value, isFalse);
      expect(controller.error.value, isNull);
      verify(mockTodoProvider.findTodoById(1));
    });

    test('should load todo successfully from use case', () async {
      // Arrange
      when(mockTodoProvider.findTodoById(1)).thenReturn(null);
      when(mockUseCases.getTodoById(1)).thenAnswer((_) async => testTodo);

      // Act
      final result = await controller.loadTodo(1);

      // Assert
      expect(result, isTrue);
      expect(controller.todo.value, equals(testTodo));
      expect(controller.isLoading.value, isFalse);
      expect(controller.error.value, isNull);
      verify(mockTodoProvider.findTodoById(1));
      verify(mockUseCases.getTodoById(1)).called(greaterThan(0));
    });

    test('should dispose resources', () {
      expect(() => controller.dispose(), returnsNormally);
    });
  });
}
