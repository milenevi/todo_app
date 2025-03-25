import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/core/network/api_client.dart';
import 'package:todo_app/data/datasources/todo_remote_datasource.dart';
import 'package:todo_app/core/network/network_config.dart';
import 'package:todo_app/core/error/failures.dart';

// Cliente mock que implementa http.Client
class MockHttpClient implements http.Client {
  Map<Uri, http.Response> responses = {};
  Duration? delay;

  void mockGet(String url, http.Response response, {Duration? delay}) {
    responses[Uri.parse(url)] = response;
    this.delay = delay;
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    if (delay != null) {
      await Future.delayed(delay!);
    }

    if (responses.containsKey(url)) {
      return responses[url]!;
    }
    throw Exception('No mock response for $url');
  }

  // Implementações necessárias da interface
  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    if (responses.containsKey(url)) {
      return responses[url]!;
    }
    throw UnimplementedError();
  }

  @override
  Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    if (responses.containsKey(url)) {
      return responses[url]!;
    }
    throw UnimplementedError();
  }

  @override
  Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    if (responses.containsKey(url)) {
      return responses[url]!;
    }
    throw UnimplementedError();
  }

  @override
  Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    if (responses.containsKey(url)) {
      return responses[url]!;
    }
    throw UnimplementedError();
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) async {
    if (responses.containsKey(url)) {
      return responses[url]!;
    }
    throw UnimplementedError();
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) async {
    if (responses.containsKey(url)) {
      return responses[url]!.body;
    }
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) async {
    if (responses.containsKey(url)) {
      return responses[url]!.bodyBytes;
    }
    throw UnimplementedError();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    throw UnimplementedError();
  }

  @override
  void close() {
    // No-op for tests
  }
}

// Mock ApiClient para testes
class MockApiClient extends ApiClient {
  final Map<String, Map<String, dynamic>> getResponses = {};
  final Map<String, Map<String, dynamic>> postResponses = {};
  final Map<String, Map<String, dynamic>> putResponses = {};
  final Map<String, Map<String, dynamic>> deleteResponses = {};
  final Map<String, Failure> errors = {};

  MockApiClient()
      : super(client: http.Client(), baseUrl: NetworkConfig.baseUrl);

  void mockGet(String endpoint, Map<String, dynamic> responseData) {
    getResponses[endpoint] = responseData;
  }

  void mockPost(String endpoint, Map<String, dynamic> responseData) {
    postResponses[endpoint] = responseData;
  }

  void mockPut(String endpoint, Map<String, dynamic> responseData) {
    putResponses[endpoint] = responseData;
  }

  void mockDelete(String endpoint, Map<String, dynamic> responseData) {
    deleteResponses[endpoint] = responseData;
  }

  void mockError(String endpoint, Failure error) {
    errors[endpoint] = error;
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    if (errors.containsKey(endpoint)) {
      throw errors[endpoint]!;
    }
    if (getResponses.containsKey(endpoint)) {
      return getResponses[endpoint]!;
    }
    throw const ServerFailure();
  }

  @override
  Future<Map<String, dynamic>> post(String endpoint,
      {required Map<String, dynamic> body}) async {
    if (errors.containsKey(endpoint)) {
      throw errors[endpoint]!;
    }
    if (postResponses.containsKey(endpoint)) {
      return postResponses[endpoint]!;
    }
    throw const ServerFailure();
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint,
      {required Map<String, dynamic> body}) async {
    if (errors.containsKey(endpoint)) {
      throw errors[endpoint]!;
    }
    if (putResponses.containsKey(endpoint)) {
      return putResponses[endpoint]!;
    }
    throw const ServerFailure();
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint) async {
    if (errors.containsKey(endpoint)) {
      throw errors[endpoint]!;
    }
    if (deleteResponses.containsKey(endpoint)) {
      return deleteResponses[endpoint]!;
    }
    throw const ServerFailure();
  }
}

void main() {
  late TodoRemoteDataSource dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = TodoRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  group('TodoRemoteDataSource', () {
    test('getTodos returns a list of todos when response is successful',
        () async {
      // Mock data
      final mockTodosJson = {
        'todos': [
          {'id': 1, 'todo': 'Test Todo 1', 'completed': false, 'userId': 1},
          {'id': 2, 'todo': 'Test Todo 2', 'completed': true, 'userId': 1},
        ],
      };

      // Setup the mock response
      mockApiClient.mockGet(NetworkConfig.todosEndpoint, mockTodosJson);

      // Call the method
      final todos = await dataSource.getTodos();

      // Verify results
      expect(todos.length, equals(2));
      expect(todos[0].id, equals(1));
      expect(todos[0].todo, equals('Test Todo 1'));
      expect(todos[0].completed, isFalse);
      expect(todos[1].id, equals(2));
      expect(todos[1].completed, isTrue);
    });

    test('getTodos throws ServerFailure when API fails', () async {
      // Setup the mock error
      mockApiClient.mockError(
          NetworkConfig.todosEndpoint, const ServerFailure());

      // Verify that calling the method throws ServerFailure
      expect(() => dataSource.getTodos(), throwsA(isA<ServerFailure>()));
    });

    test('getTodoById returns a todo when response is successful', () async {
      // Mock data
      final mockTodoJson = {
        'id': 1,
        'todo': 'Test Todo 1',
        'completed': false,
        'userId': 1,
      };

      // Setup the mock response
      mockApiClient.mockGet('${NetworkConfig.todoEndpoint}/1', mockTodoJson);

      // Call the method
      final todo = await dataSource.getTodoById(1);

      // Verify results
      expect(todo.id, equals(1));
      expect(todo.todo, equals('Test Todo 1'));
      expect(todo.completed, isFalse);
    });

    test('getTodoById throws ServerFailure when API fails', () async {
      // Setup the mock error
      mockApiClient.mockError(
          '${NetworkConfig.todoEndpoint}/999', const ServerFailure());

      // Verify that calling the method throws ServerFailure
      expect(() => dataSource.getTodoById(999), throwsA(isA<ServerFailure>()));
    });

    test('createTodo returns a new todo when response is successful', () async {
      // Mock data
      final mockResponse = {
        'id': 101,
        'todo': 'New Task',
        'completed': false,
        'userId': 1,
      };

      // Setup the mock response
      mockApiClient.mockPost(NetworkConfig.todoEndpoint, mockResponse);

      // Call the method
      final todo = await dataSource.createTodo('New Task');

      // Verify results
      expect(todo.id, equals(101));
      expect(todo.todo, equals('New Task'));
      expect(todo.completed, isFalse);
    });

    test('createTodo throws ServerFailure when API fails', () async {
      // Setup the mock error
      mockApiClient.mockError(
          NetworkConfig.todoEndpoint, const ServerFailure());

      // Verify that calling the method throws ServerFailure
      expect(() => dataSource.createTodo('New Task'),
          throwsA(isA<ServerFailure>()));
    });
  });
}
