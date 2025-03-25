import 'package:flutter/material.dart';

/// Classe de utilitários para interface do usuário
class UIHelpers {
  /// Exibe uma mensagem de feedback para o usuário
  static void showFeedback(
      BuildContext context, String message, Color backgroundColor,
      {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Exibe uma mensagem de sucesso
  static void showSuccess(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2)}) {
    showFeedback(context, message, Colors.green, duration: duration);
  }

  /// Exibe uma mensagem de erro
  static void showError(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    showFeedback(context, message, Colors.red, duration: duration);
  }
}
