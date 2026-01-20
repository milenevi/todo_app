import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppThemes {
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ).copyWith(
        surface: AppColors.lightBackground,
        primary: AppColors.primary,
        secondary: AppColors.lightSecondary,
      ),
      textTheme: AppTextStyles.getLightTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ).copyWith(
        surface: AppColors.darkBackground,
        primary: AppColors.primary,
        secondary: AppColors.darkSecondary,
      ),
      textTheme: AppTextStyles.getDarkTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardTheme: const CardThemeData(
        color: AppColors.darkSecondary,
      ),
    );
  }
}