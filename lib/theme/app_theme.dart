import 'package:flutter/material.dart';

/// Colors that are not part of the Material color scheme.
abstract final class AppColors {
  static const brand = Colors.indigo;

  static const friends = Color(0xFF3B82F6);
  static const publicEvent = Color(0xFFF59E0B);
  static const group = Color(0xFF10B981);
  static const sharedInterest = Color(0xFF8B5CF6);
  static const event = Color(0xFF7C3AED);
}

ThemeData buildAppTheme({Brightness brightness = Brightness.light}) =>
    ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brand,
        brightness: brightness,
      ),
      useMaterial3: true,
    );
