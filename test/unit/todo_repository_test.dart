import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/repositories/todo_repository.dart';

// Mock para TodoService
class MockTodoServiceForRepository implements TodoService {
  String baseUrl = 'https://dummyjson.com';
  bool disposeCalled = false;
  List<Todo>? todosToReturn;
  Todo? todoToReturn;
  Exception? exceptionToThrow;

  @override
  Future<List<Todo>> getTodos() async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return todosToReturn ?? [];
  }

  @override
  Future<Todo> getTodoById(int id) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return todoToReturn ??
        Todo(id: id, todo: 'Default', completed: false, userId: 1);
  }

  @override
  void dispose() {
    disposeCalled = true;
  }
}

@GenerateMocks([TodoService])
void main() {
  late TodoRepository repository;
  late MockTodoServiceForRepository mockService;

  setUp(() {
    mockService = MockTodoServiceForRepository();
    repository = TodoRepository(todoService: mockService);
  });

  group('TodoRepository', () {
    test('should fetch todos from service', () async {
      final todos = [
        Todo(id: 1, todo: 'Test Todo 1', completed: false, userId: 1),
        Todo(id: 2, todo: 'Test Todo 2', completed: true, userId: 1)
      ];
      when(mockService.getTodos()).thenAnswer((_) async => todos);

      final result = await repository.fetchTodos();

      expect(result, equals(todos));
      verify(mockService.getTodos()).called(1);
    });

    test('should fetch todo by id from service', () async {
      final todo =
      Todo(id: 1, todo: 'Test Todo 1', completed: false, userId: 1);
      when(mockService.getTodoById(1)).thenAnswer((_) async => todo);

      final result = await repository.fetchTodoById(1);

      expect(result, equals(todo));
      verify(mockService.getTodoById(1)).called(1);
    });

    test('should dispose service', () {
      repository.dispose();
      verify(mockService.dispose()).called(1);
    });
  });
}
