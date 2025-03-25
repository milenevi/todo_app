import 'package:flutter/material.dart';

class LoadingErrorHandler extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final Widget child;

  const LoadingErrorHandler({
    super.key,
    required this.isLoading,
    this.errorMessage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    return child;
  }
}
