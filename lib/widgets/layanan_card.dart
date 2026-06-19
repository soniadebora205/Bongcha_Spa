import 'package:flutter/material.dart';
import '../models/paket_spa.dart';
import 'paket_bottom_sheet.dart';

class LayananCard extends StatelessWidget {
  final PaketSpa paket;
  final bool isSelected;
  final VoidCallback onToggle;

  const LayananCard({
    super.key, 
    required this.paket,
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

  IconData _getIcon(String? iconName) {
    switch (iconName) {
      case 'creambath':
        return Icons.brush; // sisir / creambath
      case 'creambath_sauna':
        return Icons.hot_tub;
      case 'pijat':
        return Icons.self_improvement;
      case 'sauna':
        return Icons.local_fire_department;
      default:
        return Icons.spa;
    }
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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F0EB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getIcon(paket.iconName),
              size: 28,
              color: const Color(0xFF2C1810),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paket.nama,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1C1C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Durasi : ${paket.durasi} menit',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF777777),
                  ),
                ),
                Text(
                  'Harga : ${_formatHarga(paket.harga)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),

          // Tombol Pilih Paket
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: onToggle,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected? const Color(0xFF2C1810) : const Color(0xFFD4956A),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isSelected ? 'Dipilih' : 'Pilih Paket',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}