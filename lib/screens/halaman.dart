import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

/// [halaman.dart]
/// File ini berfungsi sebagai wrapper navigasi utama.
/// Saat ini hanya memuat DashboardScreen.
/// Ke depannya bisa ditambahkan BottomNavigationBar
/// atau drawer untuk navigasi antar halaman.

class Halaman extends StatefulWidget {
  const Halaman({super.key});

  @override
  State<Halaman> createState() => _HalamanState();
}

class _HalamanState extends State<Halaman> {
  int _selectedIndex = 0;

  // Daftar halaman — bisa ditambah ke depannya
  final List<Widget> _pages = [
    const DashboardScreen(),
    // Placeholder untuk halaman History (bisa ditambah nanti)
    const _PlaceholderPage(label: 'Riwayat Pendaftaran'),
    // Placeholder untuk halaman Profil
    const _PlaceholderPage(label: 'Profil'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}

/// Placeholder page untuk halaman yang belum dibuat
class _PlaceholderPage extends StatelessWidget {
  final String label;

  const _PlaceholderPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEBE4),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.construction_rounded,
              size: 60,
              color: Color(0xFFD4956A),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1C1C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Halaman ini akan segera hadir',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF888888),
              ),
            ),
          ],
        ),
      ),
    );
  }
}