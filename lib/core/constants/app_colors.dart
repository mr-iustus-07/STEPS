import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core Backgrounds
  static const Color background = Color(0xFF000000); // Pitch Black
  static const Color surface = Color(0xFF121212); // Elevated Black
  static const Color surfaceHighlight = Color(0xFF1E1E1E); // Active states

  // Typography
  static const Color textPrimary = Color(0xFFFFFFFF); // Pure White
  static const Color textSecondary = Color(0xFFA0A0A0); // Muted Grey
  static const Color textDisabled = Color(0xFF555555); // Dark Grey

  // Accents & Interactive
  static const Color accent = Color(0xFFFFFFFF);
  static const Color border = Color(0xFF2A2A2A);
  static const Color divider = Color(0xFF1A1A1A);

  // Semantic (Desaturated to fit the monochrome premium vibe)
  static const Color success = Color(0xFF81C784); // Muted Green
  static const Color error = Color(0xFFE57373); // Muted Red
  static const Color warning = Color(0xFFFFD54F); // Muted Yellow

  // Streak/Progress specifics
  static const Color streakActive = Color(0xFFE0E0E0);
  static const Color streakInactive = Color(0xFF222222);
}