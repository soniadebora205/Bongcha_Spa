import 'package:flutter/material.dart';
import 'screens/halaman.dart';

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
        fontFamily: 'Merriweather', // fallback ke default jika belum ditambahkan
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1C1C1C),
          elevation: 0,
        ),
      ),
      home: const Halaman(),
    );
  }
}