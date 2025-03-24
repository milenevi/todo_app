import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AddItemButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddItemButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color:
              isDarkMode ? AppColors.darkSecondary : AppColors.lightSecondary,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.withAlpha(77), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Add Item',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Center(
                child: Icon(Icons.add, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
