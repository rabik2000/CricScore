import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const slateColor = Color(0xFF0F172A); // Rich Slate
  static const emeraldColor = Color(0xFF059669); // Emerald Green
  static const slateLight = Color(0xFF64748B); // Slate Gray
  static const errorColor = Color(0xFFD32F2F);
  static const bgColor = Color(0xFFF8FAFC); // Very Light Slate

  // Placeholders for compatibility
  static const primaryColor = emeraldColor;
  static const accentColor = slateColor;
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: slateColor,
        primary: emeraldColor,
        onPrimary: Colors.white,
        secondary: slateColor,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: slateColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme.copyWith(
          titleLarge: const TextStyle(
            color: slateColor,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          labelSmall: const TextStyle(
            color: slateLight,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            fontSize: 11,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: slateLight.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: slateLight.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: emeraldColor, width: 2),
        ),
        hintStyle: TextStyle(color: slateLight.withValues(alpha: 0.5)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: slateColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: slateColor),
        titleTextStyle: TextStyle(
          color: slateColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: emeraldColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const darkSurface = Color(0xFF1E293B);
    const darkBg = Color(0xFF0F172A);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: darkBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: emeraldColor,
        primary: emeraldColor,
        onPrimary: Colors.white,
        secondary: const Color(0xFF334155),
        onSecondary: Colors.white,
        surface: darkSurface,
        onSurface: Colors.white,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
