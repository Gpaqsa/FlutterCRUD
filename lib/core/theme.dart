import 'package:flutter/material.dart';

class AppColors {
  static const cream = Color(0xFFF5F0E8);
  static const creamDark = Color(0xFFEDE6D6);
  static const creamBorder = Color(0xFFD9D0BC);
  static const green = Color(0xFF2D5A27);
  static const greenMid = Color(0xFF4A7C43);
  static const greenLight = Color(0xFFE8F0E6);
  static const greenAccent = Color(0xFF6B9E63);
  static const textDark = Color(0xFF1C2B1A);
  static const textMid = Color(0xFF5A6B58);
  static const textLight = Color(0xFF8A9A87);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    fontFamily: 'DMSans',
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: const ColorScheme.light(
      primary: AppColors.green,
      secondary: AppColors.greenMid,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textDark,
    ),

    // App Bar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.textDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'DMSerifDisplay',
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
      ),
      iconTheme: IconThemeData(color: AppColors.textDark),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.creamBorder),
      ),
    ),

    // FAB
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.green,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.creamBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.creamBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.greenMid, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE24B4A)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE24B4A), width: 1.5),
      ),
      labelStyle: const TextStyle(
        color: AppColors.textMid,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
    ),

    // Elevated button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(
          fontFamily: 'DMSans',
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Text button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.greenMid,
        textStyle: const TextStyle(
          fontFamily: 'DMSans',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Outlined button (used for delete/secondary actions)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textMid,
        side: const BorderSide(color: AppColors.creamBorder),
        backgroundColor: AppColors.creamDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        textStyle: const TextStyle(
          fontFamily: 'DMSans',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // List tile
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.creamDark,
      thickness: 1,
      space: 1,
    ),

    // Icon
    iconTheme: const IconThemeData(color: AppColors.textMid, size: 20),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textDark,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'DMSans',
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.cream,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      titleTextStyle: const TextStyle(
        fontFamily: 'DMSerifDisplay',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 13,
        color: AppColors.textMid,
      ),
    ),

    // Text
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'DMSerifDisplay',
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'DMSerifDisplay',
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
      ),
      titleLarge: TextStyle(
        fontFamily: 'DMSerifDisplay',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
      ),
      titleMedium: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textDark,
      ),
      titleSmall: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textDark,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textMid,
      ),
      bodySmall: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textLight,
      ),
      labelLarge: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textMid,
        letterSpacing: 0.04,
      ),
    ),

    useMaterial3: true,
  );
}
