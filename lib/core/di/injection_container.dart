import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../data/datasources/todo_local_datasource.dart';
import '../../data/datasources/todo_remote_datasource.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/todo_usecases.dart';
import '../../presentation/providers/todo_provider.dart';
import '../network/api_client.dart';
import '../network/network_config.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(
    () => ApiClient(
      client: sl(),
      baseUrl: NetworkConfig.baseUrl,
    ),
  );

  // Data sources
  sl.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => TodoUseCases(repository: sl()));

  // Providers
  sl.registerFactory(() => TodoProvider(useCases: sl()));
}
