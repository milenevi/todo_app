import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Provider.of<ThemeProvider>(context).isDarkMode
            ? Icons.light_mode
            : Icons.dark_mode,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white54
            : Colors.black54,
      ),
      onPressed: () {
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      },
    );
  }
}
