import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/core/network/api_client.dart';
import 'package:todo_app/core/network/network_config.dart';
import 'package:todo_app/data/datasources/todo_remote_datasource.dart';

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

  MockApiClient()
      : super(client: http.Client(), baseUrl: NetworkConfig.baseUrl);
  final Map<String, Map<String, dynamic>> getResponses = {};
  final Map<String, Failure> errors = {};

  void mockGet(String endpoint, Map<String, dynamic> responseData) {
    getResponses[endpoint] = responseData;
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

    // Nota: Os métodos getTodoById e createTodo não são utilizados na aplicação real.
    // São mantidos apenas para compatibilidade com a interface e poderiam ser removidos
    // ou modificados para lançar uma exceção de "não implementado" caso a aplicação
    // evolua para utilizar essas operações remotamente no futuro.
  });
}
