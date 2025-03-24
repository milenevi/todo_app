// Automatic generated file by mockito
import 'package:mockito/mockito.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';

class MockTodoService extends Mock implements TodoService {
  @override
  String get baseUrl => 'https://dummyjson.com';

  @override
  Future<List<Todo>> getTodos() => super.noSuchMethod(
    Invocation.method(#getTodos, []),
    returnValue: Future.value([]),
    returnValueForMissingStub: Future.value([]),
  );

  @override
  Future<Todo> getTodoById(int id) => super.noSuchMethod(
    Invocation.method(#getTodoById, [id]),
    returnValue: Future.value(
      Todo(id: id, todo: '', completed: false, userId: 1),
    ),
    returnValueForMissingStub: Future.value(
      Todo(id: id, todo: '', completed: false, userId: 1),
    ),
  );

  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []));
}
