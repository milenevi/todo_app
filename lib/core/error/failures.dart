abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

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

/// Falha de servidor - Usada quando há problemas de comunicação com a API
class ServerFailure extends Failure {
  const ServerFailure({String? message})
      : super(message: message ?? 'Falha na comunicação com o servidor');
}

/// Falha de recurso não encontrado - Usada pelo ApiClient quando recebe 404
class NotFoundFailure extends Failure {
  const NotFoundFailure({String? message})
      : super(message: message ?? 'Recurso não encontrado');
}

/// Falha de operação não implementada - Usada pelo repositório para indicar
/// que certas operações são apenas simuladas e não são realmente implementadas
class NotImplementedFailure extends Failure {
  const NotImplementedFailure({String? message})
      : super(message: message ?? 'Operação não implementada');
}
