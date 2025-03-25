import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar Exclusão'),
      content: const Text('Tem certeza que deseja excluir esta tarefa?'),
      actions: [
        TextButton(
          onPressed: () => AppRouter.goBack(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => AppRouter.goBack(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text('Excluir'),
        ),
      ],
    );
  }
}
