import 'package:flutter/material.dart';
import '../models/paket_spa.dart';
import 'paket_bottom_sheet.dart';

class PaketCard extends StatelessWidget {
  final PaketSpa paket;

  const PaketCard({super.key, required this.paket});

  String _formatHarga(int harga) {
    String hargaStr = harga.toString();
    String result = '';
    int counter = 0;
    for (int i = hargaStr.length - 1; i >= 0; i--) {
      if (counter != 0 && counter % 3 == 0) {
        result = '.$result';
      }
      result = hargaStr[i] + result;
      counter++;
    }
    return 'Rp. $result';
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaketBottomSheet(paket: paket),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar kiri
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
            child: SizedBox(
              width: 140,
              height: 130,
              child: paket.imagePath != null
                  ? Image.asset(
                      paket.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildImagePlaceholder(paket.nama),
                    )
                  : _buildImagePlaceholder(paket.nama),
            ),
          ),

          // Konten kanan
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama paket
                  Text(
                    paket.nama,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1C1C),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Durasi
                  Text(
                    'Durasi : ${paket.durasi} menit',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF555555),
                    ),
                  ),

                  // Harga
                  Text(
                    'Harga : ${_formatHarga(paket.harga)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Icon treatment
                  Row(
                    children: [
                      const Icon(Icons.spa, size: 18, color: Color(0xFF555555)),
                      const SizedBox(width: 4),
                      const Icon(Icons.hot_tub, size: 18, color: Color(0xFF555555)),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Baca selengkapnya
                  GestureDetector(
                    onTap: () => _showBottomSheet(context),
                    child: const Text(
                      'baca selengkapnya',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF888888),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tombol Pilih Paket
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () => _showBottomSheet(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4956A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Pilih paket',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(String nama) {
    // Warna berbeda tiap paket
    final Map<String, Color> colors = {
      '7 In One': const Color(0xFF3D2B1F),
      'For Kids': const Color(0xFF5C3D1E),
      'For Brides': const Color(0xFF2C1810),
    };

    return Container(
      color: colors[nama] ?? const Color(0xFF3D2B1F),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                'https://www.transparenttextures.com/patterns/batik.png',
                repeat: ImageRepeat.repeat,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),
          // Text overlay
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'KOREAN SPA',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  nama,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFD4A843),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Text(
                  'PACKAGE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}