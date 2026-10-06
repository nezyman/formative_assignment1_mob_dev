import 'package:flutter/material.dart';

/// All colours used in the app.
class AppColors {
  static const primary = Color(0xFF3F51B5);
  static const background = Color(0xFFF5F6FA);
  static const textDark = Color(0xFF1F2430);
  static const textGrey = Color(0xFF6B7280);

  // SLA status colours
  static const onTrack = Color(0xFF2E7D32);
  static const atRisk = Color(0xFFEF6C00);
  static const overdue = Color(0xFFD32F2F);
  static const completed = Color(0xFF1565C0);
}

/// Standard spacing values so layouts look consistent.
class AppSpacing {
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
}

/// The one theme used by the whole app.
class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
            fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
        titleMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textGrey),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}