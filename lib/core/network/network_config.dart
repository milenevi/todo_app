class NetworkConfig {
  static const String baseUrl = 'https://dummyjson.com';
  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Endpoints
  // A aplicação usa apenas um endpoint para carregar dados iniciais
  static const String todosEndpoint =
      '/todos'; // GET /todos para carregar a lista inicial

  // Nota: Todas as operações de CRUD (criar, atualizar, excluir) são realizadas localmente
  // sem qualquer comunicação com a API externa.

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
}
