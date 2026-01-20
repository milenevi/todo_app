import '../../core/error/failures.dart';

/// Uma classe que encapsula um resultado que pode ser um sucesso ou um erro.
/// Esta classe substitui o uso do Either do pacote dartz.
class Result<T> {

  /// Construtor privado para criar um resultado de sucesso
  const Result._success(this._data) : _failure = null;

  /// Construtor privado para criar um resultado de erro
  const Result._failure(this._failure) : _data = null;
  final T? _data;
  final Failure? _failure;

  /// Cria um resultado de sucesso com os dados fornecidos
  static Result<T> success<T>(T data) => Result<T>._success(data);

  /// Cria um resultado de erro com a falha fornecida
  static Result<T> failure<T>(Failure failure) => Result<T>._failure(failure);

  /// Retorna verdadeiro se o resultado for um sucesso
  bool get isSuccess => _failure == null;

  /// Retorna verdadeiro se o resultado for um erro
  bool get isFailure => _failure != null;

  /// Obtém os dados do resultado, ou null se for um erro
  T? get value => _data;

  /// Obtém a falha do resultado, ou null se for um sucesso
  Failure? get errorValue => _failure;

  /// Executa a função correspondente ao tipo de resultado
  R fold<R>(
      R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    if (isFailure) {
      return onFailure(_failure!);
    } else {
      return onSuccess(_data as T);
    }
  }
}
