class NetworkConfig {
  static const String baseUrl = 'https://dummyjson.com';
  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Endpoints
  static const String todosEndpoint = '/todos';
  static const String todoEndpoint = '/todos';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
}
