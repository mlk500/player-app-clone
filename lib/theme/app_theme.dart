import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppTheme {
  static ThemeData buildTheme() {
    return (ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        backgroundColor: const Color.fromRGBO(244, 239, 209, 1),
        errorColor: const Color.fromRGBO(254, 0, 0, 1),
      ),
      primaryColor: const Color.fromRGBO(255, 88, 0, 1),
      hintColor: const Color.fromRGBO(34, 85, 80, 1),
      focusColor: const Color.fromRGBO(153, 177, 130, 1),
      hoverColor: const Color.fromRGBO(255, 246, 217, 1),
      highlightColor: const Color.fromRGBO(30, 48, 35, 1),
      canvasColor: const Color.fromRGBO(123, 123, 123, 1),
      disabledColor: const Color.fromRGBO(255, 104, 104, 1),
      textTheme: GoogleFonts.montserratTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ));
  }
}
