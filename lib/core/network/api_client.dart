import 'dart:convert';
import 'package:http/http.dart' as http;
import '../error/failures.dart';

/// Cliente para acessar a API remota.
///
/// IMPORTANTE: Na arquitetura atual da aplicação, apenas o método get() é utilizado
/// para carregar a lista inicial de tarefas. Todas as operações CRUD
/// (criar, atualizar, excluir) são realizadas localmente.
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
}
