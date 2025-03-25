import 'dart:convert';
import 'package:http/http.dart' as http;
import '../error/failures.dart';

class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({
    required this.client,
    required this.baseUrl,
  });

  Future<Map<String, dynamic>> get(String path) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl$path'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        throw const NotFoundFailure();
      } else {
        throw ServerFailure(message: response.body);
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw const ServerFailure();
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ServerFailure(message: response.body);
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw const ServerFailure();
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ServerFailure(message: response.body);
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw const ServerFailure();
    }
  }

  Future<void> delete(String path) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl$path'),
      );

      if (response.statusCode != 200) {
        throw ServerFailure(message: response.body);
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw const ServerFailure();
    }
  }
}
