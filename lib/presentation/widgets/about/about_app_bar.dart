import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';

class AboutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AboutAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDarkMode ? Colors.white54 : Colors.black54,
        ),
        onPressed: () => AppRouter.goBack(context),
      ),
      title: Text(
        'Sobre',
        style: TextStyle(
          color: isDarkMode ? Colors.white54 : Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
