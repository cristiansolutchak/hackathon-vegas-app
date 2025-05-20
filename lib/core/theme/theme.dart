// Tema personalizado do Bitcoin Locker
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BitcoinLockerTheme {
  // Cores principais
  static const Color primaryOrange = Color(0xFFF7931A);
  static const Color lightOrange = Color(0xFFFFB74D);
  static const Color darkOrange = Color(0xFFE67E00);
  
  static const Color darkBackground = Color(0xFF121212);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color surfaceColor = Color(0xFF2A2A2A);
  
  static const Color textLight = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textDisabled = Color(0xFF757575);
  
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);
  static const Color warning = Color(0xFFFFB300);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color accent= Colors.tealAccent;
  
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [primaryOrange, darkOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkBackground, Color(0xFF1A1A1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: textLight,
    ),
    displayMedium: GoogleFonts.montserrat(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: textLight,
    ),
    displaySmall: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: textLight,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textLight,
    ),
    titleLarge: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: textLight,
    ),
    titleMedium: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: textLight,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      color: textLight,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
      color: textSecondary,
    ),
    labelLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: textLight,
    ),
  );
  
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryOrange,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
  
  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: surfaceColor,
    foregroundColor: textLight,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
  
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
  
  static BoxDecoration glassCardDecoration = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.2),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
  
  static InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryOrange, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: GoogleFonts.roboto(
      color: textDisabled,
    ),
  );
  
  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryOrange,
    scaffoldBackgroundColor: darkBackground,
    textTheme: textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: primaryButtonStyle,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textLight,
        side: const BorderSide(color: textLight),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryOrange,
        textStyle: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textLight,
      ),
      iconTheme: const IconThemeData(
        color: textLight,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    cardTheme: CardTheme(
      color: cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    iconTheme: const IconThemeData(
      color: textLight,
    ),
    colorScheme: const ColorScheme.dark(
      primary: primaryOrange,
      secondary: lightOrange,
      surface: surfaceColor,
      error: error,
    ),
  );
}