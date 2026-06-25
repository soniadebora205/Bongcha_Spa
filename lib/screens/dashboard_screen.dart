import 'dart:async';
import 'package:flutter/material.dart';
import '../data/paket_data.dart';
import '../models/paket_spa.dart';
import '../widgets/paket_card.dart';
import '../widgets/layanan_card.dart';

class DashboardScreen extends StatefulWidget {
  final List<PaketSpa> selectedPaket;
  final Function(PaketSpa) onToggle;

  const DashboardScreen({
    super.key,
    required this.selectedPaket,
    required this.onToggle,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentImageIndex = 0;
  Timer? _timer;

  final List<String> _heroBannerImages = [
    'assets/images/hero_banner1.jpeg',
    'assets/images/hero_banner2.jpeg',
    'assets/images/hero_banner3.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _currentImageIndex =
            (_currentImageIndex + 1) % _heroBannerImages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
            _buildHeroBanner(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Paket Bongcha Spa:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1C1C),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...paketKorean.map((paket) => PaketCard(
                        paket: paket,
                        isSelected:
                            widget.selectedPaket.any((p) => p.id == paket.id),
                        onToggle: () => widget.onToggle(paket),
                      )),
                  const SizedBox(height: 8),
                  const Text(
                    'Layanan lainnya :',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1C1C),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...layananLainnya.map((paket) => LayananCard(
                        paket: paket,
                        isSelected:
                            widget.selectedPaket.any((p) => p.id == paket.id),
                        onToggle: () => widget.onToggle(paket),
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

  Widget _buildHeroBanner() {
    return Stack(
      children: [
        // ─── Foto background dengan efek fade ──────────────────────────
        SizedBox(
          width: double.infinity,
          height: 260,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800), // durasi fade
            child: Image.asset(
              _heroBannerImages[_currentImageIndex],
              key: ValueKey(_currentImageIndex), // wajib ada agar AnimatedSwitcher tahu ada perubahan
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback kalau foto belum ada
                return Container(
                  key: ValueKey('fallback_$_currentImageIndex'),
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
        ),

        // ─── Overlay gelap ─────────────────────────────────────────────
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

        // ─── Teks + dot indicator ──────────────────────────────────────
        Positioned(
          bottom: 24,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Selamat Datang\ndi ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.25,
                        letterSpacing: 0.5,
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
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                ),
              ),

              // Dot indicator
              const SizedBox(height: 10),
              Row(
                children: List.generate(
                  _heroBannerImages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 5),
                    width: _currentImageIndex == index ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white38,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}