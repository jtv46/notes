import 'package:flutter/material.dart';

class AppPalette {
  // Light
  static const lightBg            = Color(0xFFF5F3EE);
  static const lightSidebar       = Color(0xFFEAE7E0);
  static const lightSidebarHover  = Color(0xFFDDD9D0);
  static const lightSurface       = Color(0xFFFFFFFF);
  static const lightBorder        = Color(0xFFD4D0C8);
  static const lightText          = Color(0xFF1C1B18);
  static const lightTextMuted     = Color(0xFF7A776E);
  static const lightAccent        = Color(0xFF4A7C6F);
  static const lightTabActive     = Color(0xFFFFFFFF);
  static const lightTabInactive   = Color(0xFFE0DDD6);

  // Dark
  static const darkBg             = Color(0xFF1A1917);
  static const darkSidebar        = Color(0xFF141312);
  static const darkSidebarHover   = Color(0xFF2A2826);
  static const darkSurface        = Color(0xFF1F1E1C);
  static const darkBorder         = Color(0xFF302E2C);
  static const darkText           = Color(0xFFEDE9E0);
  static const darkTextMuted      = Color(0xFF8A877E);
  static const darkAccent         = Color(0xFF6BA898);
  static const darkTabActive      = Color(0xFF1F1E1C);
  static const darkTabInactive    = Color(0xFF141312);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      surface:   AppPalette.lightSurface,
      onSurface: AppPalette.lightText,
      primary:   AppPalette.lightAccent,
      onPrimary: AppPalette.lightSurface,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      surface:   AppPalette.darkSurface,
      onSurface: AppPalette.darkText,
      primary:   AppPalette.darkAccent,
      onPrimary: AppPalette.darkSurface,
    ),
  );
}