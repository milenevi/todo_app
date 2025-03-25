import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';
import 'app_title.dart';
import 'theme_toggle_button.dart';

class TodoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TodoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 28,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white54
              : Colors.black54,
        ),
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.aboutRoute);
        },
      ),
      title: const AppTitle(),
      actions: const [ThemeToggleButton()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
