import 'package:flutter/material.dart';
import 'screens/halaman.dart';
import 'package:google_fonts/google_fonts.dart'; // Pastikan ini tetap di-import

void main() {
  runApp(const BongchaSpaApp());
}

class BongchaSpaApp extends StatelessWidget {
  const BongchaSpaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bongcha Spa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4956A),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFEFEBE4),
        useMaterial3: true,

        textTheme: GoogleFonts.playfairDisplayTextTheme(
          ThemeData.light().textTheme,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
      ),
      home: const Halaman(),
    );
  }
}