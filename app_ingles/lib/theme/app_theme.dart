import 'package:flutter/material.dart';
import '../config/app_config.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color get primaryColor => AppConfig.primaryColor;
  static const Color accentColor = Color(0xFF10B981); // Mantido o verde de sucesso como acento global
  
  static const backgroundDark = Color(0xFF0F172A); // Slate 900
  static const surfaceDark = Color(0xFF1E293B); // Slate 800

  static const backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const surfaceLight = Color(0xFFFFFFFF); // White

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
  
  static bool get isDark => themeNotifier.value == ThemeMode.dark;

  static Color get backgroundColor => isDark ? backgroundDark : backgroundLight;
  static Color get surfaceColor => isDark ? surfaceDark : surfaceLight;

  static Color get textColor => isDark ? Colors.white : Colors.black87;
  static Color get textSecondaryColor => isDark ? Colors.white70 : Colors.black54;
  static Color get textHintColor => isDark ? Colors.white54 : Colors.black38;
  static Color get iconColor => isDark ? Colors.white : Colors.black87;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundLight,
      cardColor: surfaceLight,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
        headlineLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black87),
        headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black87),
        titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black87),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.normal),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundDark,
      cardColor: surfaceDark,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        headlineLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white),
        headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.white),
        titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
      ),
    );
  }

  static BoxDecoration get gradientBackground {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark 
          ? const [
              Color(0xFF0F172A), // Slate 900
              Color(0xFF1E1B4B), // Indigo 950
              Color(0xFF831843), // Pink 950 (subtle)
            ]
          : const [
              Color(0xFFF8FAFC), // Slate 50
              Color(0xFFE0E7FF), // Indigo 100
              Color(0xFFFCE7F3), // Pink 100
            ],
        stops: const [0.0, 0.6, 1.0],
      ),
    );
  }

  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: isDark ? Colors.white.withAlpha(15) : Colors.white.withAlpha(200), // Glassmorphism layer
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(10)),
      boxShadow: isDark 
          ? [] 
          : [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 20, offset: const Offset(0, 10))],
    );
  }
}
