import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/providers/todo_provider.dart';


void main() {
  group('TodoProvider Integration Tests', () {
    late TodoProvider todoProvider;

    setUp(() {
      todoProvider = TodoProvider();
    });

    test('Initial state should be empty', () {
      expect(todoProvider.todos, isEmpty);
      expect(todoProvider.isLoading, isFalse);
      expect(todoProvider.error, isNull);
    });

    test('Provider should have the correct structure', () {
      expect(todoProvider, isNotNull);
      expect(todoProvider.todos, isA<List<Todo>>());
      expect(todoProvider.completedTodos, isA<List<Todo>>());
      expect(todoProvider.incompleteTodos, isA<List<Todo>>());
    });

    test('Provider should expose correct methods', () {
      expect(todoProvider.addTodo, isA<Function>());
      expect(todoProvider.deleteTodo, isA<Function>());
      expect(todoProvider.updateTodo, isA<Function>());
      expect(todoProvider.toggleTodoCompletion, isA<Function>());
      expect(todoProvider.fetchTodos, isA<Function>());
    });
  });
}
