import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

ThemeData plannerTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.indigo,
        brightness: brightness,
      ).copyWith(
        primary: dark ? const Color(0xFFC0C1FF) : AppColors.primaryDark,
        surface: dark ? AppColors.darkSurface : AppColors.lightSurface,
        onSurface: dark ? AppColors.darkText : AppColors.lightText,
        onSurfaceVariant: dark
            ? const Color(0xFFB9C0D9)
            : AppColors.secondaryText,
        outlineVariant: dark
            ? const Color(0xFF39415B)
            : const Color(0xFFE0E5F0),
      );
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  return base.copyWith(
    scaffoldBackgroundColor: dark
        ? AppColors.darkBackground
        : AppColors.lightBackground,
    textTheme: base.textTheme.merge(plannerTypography),
    appBarTheme: AppBarTheme(
      backgroundColor: dark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
  );
}
