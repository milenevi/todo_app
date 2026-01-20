import 'package:flutter/material.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {

  const DetailAppBar({
    super.key,
    required this.isEditing,
    required this.onEditToggle,
    required this.onDelete,
  });
  final bool isEditing;
  final VoidCallback onEditToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Task Details'),
      actions: [
        IconButton(
          icon: Icon(isEditing ? Icons.save : Icons.edit),
          onPressed: onEditToggle,
        ),
        IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
