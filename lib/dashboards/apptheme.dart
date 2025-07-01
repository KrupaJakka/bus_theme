import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final dark = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4F46E5),
      secondary: Color(0xFFF59E0B),
      error: Color(0xFFEF4444),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  );
}
