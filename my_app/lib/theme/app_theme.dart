import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Color(0xFF0E7CF4),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 1.0,
        foregroundColor: Color(0xFF0E7CF4),
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0E7CF4),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF0E7CF4),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        elevation: 8.0,
      ),
      textTheme: TextTheme(
        bodyLarge:
            GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium:
            GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w400),
        titleLarge:
            GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
