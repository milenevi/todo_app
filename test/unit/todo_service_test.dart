import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/services/todo_service.dart';

// Cliente mock que implementa http.Client
class MockHttpClient implements http.Client {
  Map<Uri, http.Response> responses = {};

  void mockGet(String url, http.Response response) {
    responses[Uri.parse(url)] = response;
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    if (responses.containsKey(url)) {
      return responses[url]!;
    }
    throw Exception('No mock response for $url');
  }

  // Implementações necessárias da interface
  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw UnimplementedError();
  }

  @override
  void close() {
    // No-op for tests
  }
}

void main() {
  late TodoService todoService;
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    todoService = TodoService(client: mockClient);
  });

  group('TodoService', () {
    test('TodoService has correct base URL', () {
      expect(todoService.baseUrl, equals('https://dummyjson.com'));
    });

    test('getTodos returns a list of todos when response is successful',
            () async {
          // Mock data
          final mockTodosJson = {
            'todos': [
              {'id': 1, 'todo': 'Test Todo 1', 'completed': false, 'userId': 1},
              {'id': 2, 'todo': 'Test Todo 2', 'completed': true, 'userId': 1}
            ]
          };

          // Setup the mock response
          mockClient.mockGet('${todoService.baseUrl}/todos',
              http.Response(json.encode(mockTodosJson), 200));

          // Call the method
          final todos = await todoService.getTodos();

          // Verify results
          expect(todos.length, equals(2));
          expect(todos[0].id, equals(1));
          expect(todos[0].todo, equals('Test Todo 1'));
          expect(todos[0].completed, isFalse);
          expect(todos[1].id, equals(2));
          expect(todos[1].completed, isTrue);
        });

    test('getTodos throws exception when response is not successful', () async {
      // Setup the mock response
      mockClient.mockGet(
          '${todoService.baseUrl}/todos', http.Response('Not Found', 404));

      // Verify that calling the method throws an exception
      expect(() => todoService.getTodos(), throwsException);
    });

    test('getTodoById returns a todo when response is successful', () async {
      // Mock data
      final mockTodoJson = {
        'id': 1,
        'todo': 'Test Todo 1',
        'completed': false,
        'userId': 1
      };

      // Setup the mock response
      mockClient.mockGet('${todoService.baseUrl}/todos/1',
          http.Response(json.encode(mockTodoJson), 200));

      // Call the method
      final todo = await todoService.getTodoById(1);

      // Verify results
      expect(todo.id, equals(1));
      expect(todo.todo, equals('Test Todo 1'));
      expect(todo.completed, isFalse);
    });

    test('getTodoById throws exception when response is not successful',
            () async {
          // Setup the mock response
          mockClient.mockGet(
              '${todoService.baseUrl}/todos/999', http.Response('Not Found', 404));

          // Verify that calling the method throws an exception
          expect(() => todoService.getTodoById(999), throwsException);
        });
  });
}
