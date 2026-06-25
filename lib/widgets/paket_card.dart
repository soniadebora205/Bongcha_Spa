import 'package:flutter/material.dart';
import '../models/paket_spa.dart';
import 'paket_bottom_sheet.dart';

class PaketCard extends StatelessWidget {
  final PaketSpa paket;
  final bool isSelected;
  final VoidCallback onToggle;

  const PaketCard({
    super.key, required this.paket, 
    required this.isSelected, 
    required this.onToggle,
    });

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
      builder: (context) => PaketBottomSheet(
        paket: paket,
        isSelected: isSelected,
        onToggle: onToggle,
      ),
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
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar kiri
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
              child: SizedBox(
                width: 110,
                height: 160,
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
                        color: Color(0xFF1E1E1E),
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
                        const Icon(Icons.lunch_dining, size: 18, color: Color(0xFF555555)),
                        const SizedBox(width: 4),
                        const Icon(Icons.local_cafe, size: 18, color: Color(0xFF555555)),
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
      
                    // Menggunakan Spacer atau isi dinamis agar jarak tombol selalu di paling bawah
                    const Spacer(),
                    const SizedBox(height: 10),
      
                    // Tombol Pilih Paket
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: onToggle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? const Color(0xFF2C1810)
                                : const Color(0xFFD4956A),
                            foregroundColor: isSelected 
                                ? Colors.white 
                                : const Color(0xFF411E19),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            isSelected ? 'Batalkan Pilihan' : 'Pilih Paket',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.3),
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
      ),
    );
  }

  Widget _buildImagePlaceholder(String nama) {
    String imageAssetPath = 'assets/images/package_7_in_one.png'; 
    
    if (nama == 'For Kids') {
      imageAssetPath = 'assets/images/package_for_kids.png';
    } else if (nama == 'For Brides') {
      imageAssetPath = 'assets/images/package_for_brides.png';
    }

    return Container(
      color: const Color(0xFF2C1810), // Warna cokelat gelap biar nge-blend kalau ada sisa ruang
      child: Image.asset(
        imageAssetPath,
        fit: BoxFit.contain, 
        alignment: Alignment.topCenter, 
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(); // Kosongin aja kalau error, karena udah ada warna background
        },
      ),
    );
  }
}