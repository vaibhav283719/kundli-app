import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primarySaffron = Color(0xFFFF6B00);
  static const Color primaryGold = Color(0xFFFFD700);
  static const Color deepPurple = Color(0xFF1A0533);
  static const Color darkBg = Color(0xFF0D0221);
  static const Color cardDark = Color(0xFF1E0A3C);
  static const Color cardLight = Color(0xFFFFF8F0);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textLight = Color(0xFFF5F5F5);
  static const Color accentGreen = Color(0xFF00C853);
  static const Color accentRed = Color(0xFFD32F2F);

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySaffron,
        brightness: Brightness.light,
        primary: primarySaffron,
        secondary: primaryGold,
        surface: Colors.white,
        background: const Color(0xFFFFF8F0),
        onPrimary: Colors.white,
        onSecondary: textDark,
        onSurface: textDark,
        onBackground: textDark,
      ),
    );

    return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme, textDark),
      appBarTheme: AppBarTheme(
        backgroundColor: primarySaffron,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shadowColor: primarySaffron.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySaffron,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primarySaffron.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primarySaffron,
          side: const BorderSide(color: primarySaffron, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primarySaffron, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentRed),
        ),
        labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardLight,
        selectedColor: primarySaffron,
        labelStyle: GoogleFonts.poppins(fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primarySaffron,
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primarySaffron,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: primarySaffron,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEEEEEE),
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primarySaffron;
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primarySaffron.withOpacity(0.4);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySaffron,
        brightness: Brightness.dark,
        primary: primarySaffron,
        secondary: primaryGold,
        surface: cardDark,
        background: darkBg,
        onPrimary: Colors.white,
        onSecondary: textDark,
        onSurface: textLight,
        onBackground: textLight,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: darkBg,
      textTheme: _buildTextTheme(base.textTheme, textLight),
      appBarTheme: AppBarTheme(
        backgroundColor: cardDark,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        iconTheme: const IconThemeData(color: textLight),
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 4,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySaffron,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGold,
          side: const BorderSide(color: primaryGold, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A0F4A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3D1A6B)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3D1A6B)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primarySaffron, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentRed),
        ),
        labelStyle: GoogleFonts.poppins(color: Colors.grey[400]),
        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardDark,
        selectedColor: primarySaffron,
        labelStyle: GoogleFonts.poppins(fontSize: 13, color: textLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardDark,
        selectedItemColor: primarySaffron,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primarySaffron,
        unselectedLabelColor: Colors.grey[500],
        indicatorColor: primarySaffron,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A0F4A),
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primarySaffron;
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primarySaffron.withOpacity(0.4);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return base.copyWith(
      displayLarge: GoogleFonts.poppins(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textColor.withOpacity(0.7),
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textColor.withOpacity(0.7),
      ),
    );
  }
}
