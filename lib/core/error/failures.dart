// Removendo import do Equatable
// import 'package:equatable/equatable.dart';

abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  // Implementação manual dos métodos de Equatable
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ (code?.hashCode ?? 0);

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

class ServerFailure extends Failure {
  const ServerFailure({String? message})
      : super(message: message ?? 'Falha na comunicação com o servidor');
}

class CacheFailure extends Failure {
  const CacheFailure({String? message})
      : super(message: message ?? 'Falha no cache local');
}

class NetworkFailure extends Failure {
  const NetworkFailure({String? message})
      : super(message: message ?? 'Falha na conexão com a internet');
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({String? message})
      : super(message: message ?? 'Recurso não encontrado');
}

class NotImplementedFailure extends Failure {
  const NotImplementedFailure({String? message})
      : super(message: message ?? 'Operação não implementada');
}
