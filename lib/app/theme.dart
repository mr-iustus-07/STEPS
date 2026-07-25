import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Prevent instantiation
  AppTheme._();

  // Strict Monochrome Palette
  static const Color background = Color(0xFF000000); // Pitch Black
  static const Color surface = Color(0xFF121212); // Slightly elevated black for cards
  static const Color primaryText = Color(0xFFFFFFFF); // Pure White
  static const Color secondaryText = Color(0xFFA0A0A0); // Muted Grey for subtext
  static const Color accent = Color(0xFFFFFFFF); // White for active states/buttons
  static const Color border = Color(0xFF2A2A2A); // Subtle borders

  static ThemeData get monochromeTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        surface: surface,
        onPrimary: background, // Black text on white buttons
        onSurface: primaryText,
      ),
      
      // Typography: Space Grotesk for that engineered, command-center feel
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
          color: primaryText,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.5,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(
          color: primaryText,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          color: secondaryText,
          fontSize: 14,
        ),
      ),

      // Component Styling
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryText),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: background, // Black text on white button
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
    );
  }
}