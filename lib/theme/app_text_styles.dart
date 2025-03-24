import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextTheme getLightTextTheme() {
    return const TextTheme(
      titleLarge: TextStyle(color: AppColors.lightTextTitle),
      bodyLarge: TextStyle(color: AppColors.lightTextBody),
      bodyMedium: TextStyle(color: AppColors.lightTextBody),
    );
  }

  static TextTheme getDarkTextTheme() {
    return const TextTheme(
      titleLarge: TextStyle(color: AppColors.darkTextTitle),
      bodyLarge: TextStyle(color: AppColors.darkTextBody),
      bodyMedium: TextStyle(color: AppColors.darkTextBody),
    );
  }
}
