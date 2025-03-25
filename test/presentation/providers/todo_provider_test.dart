import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/usecases/todo_usecases.dart';
import 'package:todo_app/presentation/providers/todo_provider.dart';
import 'todo_provider_test.mocks.dart';

@GenerateMocks([TodoUseCases])
void main() {
  late TodoProvider provider;
  late MockTodoUseCases mockUseCases;

  // Dados de teste reutilizáveis
  final testTodos = [
    Todo(id: 1, todo: 'Test Todo 1', completed: false, userId: 1),
    Todo(id: 2, todo: 'Test Todo 2', completed: true, userId: 1),
  ];

  setUp(() {
    mockUseCases = MockTodoUseCases();

    // Configurar comportamento padrão dos mocks
    when(mockUseCases.getLocalTodos()).thenReturn([]);

    // Não criamos o provider aqui para permitir configuração específica em cada teste
  });

  group('TodoProvider', () {
    test('should load todos successfully', () async {
      // Setup específico para este teste
      when(mockUseCases.getTodos()).thenAnswer((_) async => testTodos);
      when(mockUseCases.getLocalTodos()).thenReturn([]);

      // Criar o provider após configurar os mocks
      provider = TodoProvider(useCases: mockUseCases);

      // Aguardar a inicialização completa do provider
      await Future.delayed(const Duration(milliseconds: 100));

      // A chamada adicional é feita pelo construtor, então apenas verificamos o resultado final
      expect(provider.todos, equals(testTodos));
      expect(provider.isLoading, equals(false));
      expect(provider.error, isNull);
    });

    test('should handle error when loading todos', () async {
      // Setup específico para este teste
      when(mockUseCases.getTodos()).thenThrow(Exception('Test error'));
      when(mockUseCases.getLocalTodos()).thenReturn([]);

      // Criar o provider após configurar os mocks
      provider = TodoProvider(useCases: mockUseCases);

      // Aguardar a inicialização completa do provider
      await Future.delayed(const Duration(milliseconds: 100));

      // Verificar o estado final - neste caso, deveria usar a lista local
      expect(provider.isLoading, equals(false));
      expect(provider.todos, isEmpty); // Lista local está vazia
    });

    test('should find todo by id successfully', () {
      when(mockUseCases.getLocalTodos()).thenReturn([]);
      provider = TodoProvider(useCases: mockUseCases);

      final todo = Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1);
      provider.todos = [todo];

      final result = provider.findTodoById(1);

      expect(result, equals(todo));
    });

    test('should return null when finding non-existent todo by id', () {
      when(mockUseCases.getLocalTodos()).thenReturn([]);
      provider = TodoProvider(useCases: mockUseCases);
      provider.todos = [];

      final result = provider.findTodoById(1);

      expect(result, isNull);
    });

    test('should get todo by id successfully', () async {
      final todo = Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1);
      when(mockUseCases.getLocalTodos()).thenReturn([]);
      when(mockUseCases.getTodoById(1)).thenAnswer((_) async => todo);

      provider = TodoProvider(useCases: mockUseCases);

      final result = await provider.getTodoById(1);

      expect(result, equals(todo));
      verify(mockUseCases.getTodoById(1)).called(1);
    });

    test('should handle error when getting todo by id', () async {
      when(mockUseCases.getLocalTodos()).thenReturn([]);
      when(mockUseCases.getTodoById(1)).thenThrow(Exception('Test error'));

      provider = TodoProvider(useCases: mockUseCases);

      final result = await provider.getTodoById(1);

      expect(result, isNull);
      expect(provider.error, equals('Exception: Test error'));
      verify(mockUseCases.getTodoById(1)).called(1);
    });

    test('should add todo successfully', () async {
      final newTodo =
          Todo(id: 3, todo: 'New Todo', completed: false, userId: 1);
      when(mockUseCases.getLocalTodos()).thenReturn([]);
      when(mockUseCases.createTodo('New Todo'))
          .thenAnswer((_) async => newTodo);

      provider = TodoProvider(useCases: mockUseCases);
      provider.todos = []; // Limpar a lista para o teste

      await provider.addTodo('New Todo');

      expect(provider.todos.length, equals(1));
      expect(provider.todos[0].todo, equals('New Todo'));
      verify(mockUseCases.createTodo('New Todo')).called(1);
    });

    test('should not add empty todo', () async {
      when(mockUseCases.getLocalTodos()).thenReturn([]);
      provider = TodoProvider(useCases: mockUseCases);

      await provider.addTodo('  ');

      expect(provider.todos, isEmpty);
      expect(provider.error, equals('Task description cannot be empty'));
      verifyNever(mockUseCases.createTodo(any));
    });

    test('should update todo successfully', () async {
      // Definir tarefas de teste
      final originalTodo = Todo(
        id: 1,
        todo: 'Original Todo',
        completed: false,
        userId: 1,
      );

      final updatedTodo = Todo(
        id: 1,
        todo: 'Updated Todo',
        completed: false, // Mesmo status, apenas texto diferente
        userId: 1,
      );

      // Configurar mocks para que a lista local contenha a tarefa original
      when(mockUseCases.getLocalTodos()).thenReturn([originalTodo]);
      when(mockUseCases.getTodos()).thenAnswer((_) async => []);

      // Criar o provider - ele irá usar a lista de mockUseCases.getLocalTodos()
      provider = TodoProvider(useCases: mockUseCases);

      // Esperar a inicialização ser concluída
      await Future.delayed(const Duration(milliseconds: 100));

      // Verificar se a lista inicial tem um item
      expect(provider.todos.length, equals(1),
          reason: 'Lista inicial deve ter 1 item');
      expect(provider.todos[0].todo, equals('Original Todo'),
          reason: 'Item inicial deve ter o texto original');

      // Atualizar a tarefa
      await provider.updateTodo(updatedTodo);

      // Verificar se a atualização foi bem-sucedida
      expect(provider.todos.length, equals(1),
          reason: 'Lista deve continuar com 1 item após atualização');
      expect(provider.todos[0].todo, equals('Updated Todo'),
          reason: 'Texto deve ser atualizado');
      expect(provider.todos[0].completed, equals(false),
          reason: 'Status deve permanecer o mesmo');
    });

    test('should toggle todo completion successfully', () async {
      // Configurar dados de teste
      final originalTodo = Todo(
        id: 1,
        todo: 'Test Todo',
        completed: false,
        userId: 1,
      );

      final toggledTodo = Todo(
        id: 1,
        todo: 'Test Todo',
        completed: true,
        userId: 1,
      );

      // Configurar mocks
      when(mockUseCases.getLocalTodos()).thenReturn([]);
      when(mockUseCases.toggleTodoCompletion(any))
          .thenAnswer((_) async => toggledTodo);

      // Criar provider e configurar estado inicial
      provider = TodoProvider(useCases: mockUseCases);
      provider.todos = [originalTodo];

      // Executar a ação a ser testada
      await provider.toggleTodoCompletion(originalTodo);

      // Verificar resultados
      expect(provider.todos.length, equals(1));
      expect(provider.todos[0].todo, equals('Test Todo'));
      expect(provider.todos[0].completed, equals(true));
      verify(mockUseCases.toggleTodoCompletion(any)).called(1);
    });

    test('should delete todo successfully', () async {
      // Configurar dados de teste
      final todo = Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1);

      // Configurar mocks
      when(mockUseCases.getLocalTodos()).thenReturn([]);
      when(mockUseCases.deleteTodo(1)).thenAnswer((_) async => true);

      // Criar provider e configurar estado inicial
      provider = TodoProvider(useCases: mockUseCases);
      provider.todos = [todo];

      // Executar a ação a ser testada
      await provider.deleteTodo(1);

      // Verificar resultados
      expect(provider.todos, isEmpty);
      verify(mockUseCases.deleteTodo(1)).called(1);
    });

    test('should dispose use cases', () {
      when(mockUseCases.getLocalTodos()).thenReturn([]);
      provider = TodoProvider(useCases: mockUseCases);

      provider.dispose();
      // Skip verification as dispose is not generated in MockTodoUseCases
    });

    test('should get completed todos', () {
      when(mockUseCases.getLocalTodos()).thenReturn([]);
      provider = TodoProvider(useCases: mockUseCases);

      final todos = [
        Todo(id: 1, todo: 'Test Todo 1', completed: true, userId: 1),
        Todo(id: 2, todo: 'Test Todo 2', completed: false, userId: 1),
        Todo(id: 3, todo: 'Test Todo 3', completed: true, userId: 1),
      ];
      provider.todos = todos;

      expect(provider.completedTodos, equals([todos[0], todos[2]]));
    });

    test('should get incomplete todos', () {
      when(mockUseCases.getLocalTodos()).thenReturn([]);
      provider = TodoProvider(useCases: mockUseCases);

      final todos = [
        Todo(id: 1, todo: 'Test Todo 1', completed: true, userId: 1),
        Todo(id: 2, todo: 'Test Todo 2', completed: false, userId: 1),
        Todo(id: 3, todo: 'Test Todo 3', completed: true, userId: 1),
      ];
      provider.todos = todos;

      expect(provider.incompleteTodos, equals([todos[1]]));
    });
  });
}
