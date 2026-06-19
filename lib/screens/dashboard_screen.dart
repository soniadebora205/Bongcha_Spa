import 'package:flutter/material.dart';
import '../data/paket_data.dart';
import '../widgets/paket_card.dart';
import '../widgets/layanan_card.dart';
import '../models/paket_spa.dart';

class DashboardScreen extends StatelessWidget {
  final List<PaketSpa> selectedPaket;
  final Function(PaketSpa) onToggle;

  const DashboardScreen({
    super.key,
    required this.selectedPaket,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final paketKorean = PaketData.getPaketKorean();
    final layananLainnya = PaketData.getLayananLainnya();

    return Scaffold(
      backgroundColor: const Color(0xFFEFEBE4),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Hero Banner ───────────────────────────────────────────
            _buildHeroBanner(context),

            // ─── Konten Utama ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Daftar Paket
                  const Text(
                    'Daftar Paket Bongcha Spa:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1C1C),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // List Korean Spa Package
                  ...paketKorean.map((paket) => PaketCard(
                        paket: paket,
                        isSelected: selectedPaket.any((p) => p.id == paket.id),
                        onToggle: () => onToggle(paket),
                      )),

                  const SizedBox(height: 8),

                  // Judul Layanan Lainnya
                  const Text(
                    'Layanan lainnya :',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1C1C),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // List Layanan Lainnya
                  ...layananLainnya.map((paket) => LayananCard(
                    paket: paket, 
                    isSelected: selectedPaket.any((p) => p.id == paket.id),
                    onToggle: () => onToggle(paket),
                  )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Stack(
      children: [
        // Gambar background hero
        SizedBox(
          width: double.infinity,
          height: 260,
          child: Image.asset(
            'assets/images/hero_banner.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback jika gambar belum ada
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2C1810),
                      Color(0xFF5C3D1E),
                      Color(0xFF8B6340),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Overlay gelap
        Container(
          width: double.infinity,
          height: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.55),
              ],
            ),
          ),
        ),

        // Teks overlay
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Selamat Datang\ndi ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.25,
                        letterSpacing: 0.5,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    TextSpan(
                      text: 'Bongcha Spa',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFD4A843),
                        height: 1.25,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Mau relaksasi apa hari ini?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}