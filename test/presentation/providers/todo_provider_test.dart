import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/domain/entities/todo_entity.dart';
import 'package:todo_app/domain/usecases/todo_usecases.dart';
import 'package:todo_app/presentation/providers/todo_provider.dart';

import 'todo_provider_test.mocks.dart';

@GenerateMocks([TodoUseCases])
void main() {
  late TodoProvider provider;
  late MockTodoUseCases mockUseCases;

  // Dados de teste reutilizáveis
  final testTodos = [
    const TodoEntity(id: 1, todo: 'Test Todo 1', completed: false, userId: 1),
    const TodoEntity(id: 2, todo: 'Test Todo 2', completed: true, userId: 1),
  ];

  setUp(() {
    mockUseCases = MockTodoUseCases();
  });

  group('TodoProvider', () {
    test('should load todos successfully', () async {
      // Setup específico para este teste
      when(mockUseCases.getTodos()).thenAnswer((_) async => testTodos);

      // Criar o provider após configurar os mocks
      provider = TodoProvider(useCases: mockUseCases);

      // Aguardar a inicialização completa do provider
      await Future.delayed(const Duration(milliseconds: 100));

      // A chamada adicional é feita pelo construtor, então apenas verificamos o resultado final
      expect(provider.todos, contains(testTodos[0]));
      expect(provider.todos, contains(testTodos[1]));
      expect(provider.isLoading, equals(false));
      expect(provider.error, isNull);
    });

    test('should handle error when loading todos', () async {
      // Setup específico para este teste
      when(mockUseCases.getTodos()).thenThrow(Exception('Test error'));

      // Criar o provider após configurar os mocks
      provider = TodoProvider(useCases: mockUseCases);

      // Aguardar a inicialização completa do provider
      await Future.delayed(const Duration(milliseconds: 100));

      // Verificar o estado final
      expect(provider.isLoading, equals(false));
      expect(provider.todos, isEmpty);
    });

    test('should find todo by id successfully', () {
      when(mockUseCases.getTodos()).thenAnswer((_) async => []);
      provider = TodoProvider(useCases: mockUseCases);

      const todo = TodoEntity(id: 1, todo: 'Test Todo', completed: false, userId: 1);
      provider.todos = [todo];

      final result = provider.findTodoById(1);

      expect(result, equals(todo));
    });

    test('should get todo by id successfully', () async {
      const todo = TodoEntity(id: 1, todo: 'Test Todo', completed: false, userId: 1);
      when(mockUseCases.getTodos()).thenAnswer((_) async => []);
      when(mockUseCases.getTodoById(1)).thenAnswer((_) async => todo);

      provider = TodoProvider(useCases: mockUseCases);

      final result = await provider.getTodoById(1);

      expect(result, equals(todo));
      verify(mockUseCases.getTodoById(1)).called(1);
    });

    test('should add todo successfully', () async {
      const newTodo =
          TodoEntity(id: 3, todo: 'New Todo', completed: false, userId: 1);
      when(mockUseCases.getTodos()).thenAnswer((_) async => []);
      when(mockUseCases.createTodo('New Todo'))
          .thenAnswer((_) async => newTodo);

      provider = TodoProvider(useCases: mockUseCases);
      provider.todos = []; // Limpar a lista para o teste

      await provider.addTodo('New Todo');

      expect(provider.todos.length, equals(1));
      expect(provider.todos[0].todo, equals('New Todo'));
      verify(mockUseCases.createTodo('New Todo')).called(1);
    });

    test('should update todo successfully', () async {
      const originalTodo = TodoEntity(
        id: 1,
        todo: 'Original Todo',
        completed: false,
        userId: 1,
      );

      const updatedTodo = TodoEntity(
        id: 1,
        todo: 'Updated Todo',
        completed: false,
        userId: 1,
      );

      when(mockUseCases.getTodos()).thenAnswer((_) async => [originalTodo]);

      provider = TodoProvider(useCases: mockUseCases);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.todos.length, equals(1));

      await provider.updateTodo(updatedTodo);

      expect(provider.todos.length, equals(1));
      expect(provider.todos[0].todo, equals('Updated Todo'));
    });

    test('should toggle todo completion successfully', () async {
      const originalTodo = TodoEntity(
        id: 1,
        todo: 'Test Todo',
        completed: false,
        userId: 1,
      );

      const toggledTodo = TodoEntity(
        id: 1,
        todo: 'Test Todo',
        completed: true,
        userId: 1,
      );

      when(mockUseCases.getTodos()).thenAnswer((_) async => []);
      when(mockUseCases.toggleTodoCompletion(any))
          .thenAnswer((_) async => toggledTodo);

      provider = TodoProvider(useCases: mockUseCases);
      provider.todos = [originalTodo];

      await provider.toggleTodoCompletion(originalTodo);

      expect(provider.todos.length, equals(1));
      expect(provider.todos[0].completed, equals(true));
      verify(mockUseCases.toggleTodoCompletion(any)).called(1);
    });

    test('should delete todo successfully', () async {
      const todo = TodoEntity(id: 1, todo: 'Test Todo', completed: false, userId: 1);

      when(mockUseCases.getTodos()).thenAnswer((_) async => []);
      when(mockUseCases.deleteTodo(1)).thenAnswer((_) async => true);

      provider = TodoProvider(useCases: mockUseCases);
      provider.todos = [todo];

      await provider.deleteTodo(1);

      expect(provider.todos, isEmpty);
      verify(mockUseCases.deleteTodo(1)).called(1);
    });
  });
}
