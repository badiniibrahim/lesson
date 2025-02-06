import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = const Color.fromARGB(255, 112, 185, 190);
  static const Color secondary = Color(0xFF32B5FF);
  static const Color accent = Color(0xFFFF6584);
  static const Color background = Color(0xFFF8F9FE);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF9098B1);
  static const Color success = Color(0xFF4CAF50);
  static const Color border = Color(0xFFEAECF0);

  static final LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,
      primary.withOpacity(0.8),
    ],
  );

  static final LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accent,
      accent.withOpacity(0.8),
    ],
  );
}
