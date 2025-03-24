import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppThemes {
  static ThemeData getLightTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        surface: AppColors.lightBackground,
        primary: AppColors.primary,
        secondary: AppColors.lightSecondary,
      ),
      textTheme: AppTextStyles.getLightTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        surface: AppColors.darkBackground,
        primary: AppColors.primary,
        secondary: AppColors.darkSecondary,
      ),
      textTheme: AppTextStyles.getDarkTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
    );
  }
}
