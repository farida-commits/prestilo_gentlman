import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gentleman/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgMain,
      primaryColor: AppColors.accent,
      fontFamily: GoogleFonts.raleway().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgMain,
        elevation: 0,
        titleTextStyle: GoogleFonts.dancingScript(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: GoogleFonts.dancingScript(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
        bodyMedium: GoogleFonts.raleway(
          fontSize: 14,
          color: AppColors.white,
        ),
        bodySmall: GoogleFonts.raleway(
          fontSize: 12,
          color: AppColors.brown,
        ),
      ),
    );
  }
}