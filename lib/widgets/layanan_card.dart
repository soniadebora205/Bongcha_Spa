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

  String? _getImagePath(String? iconName) {
    switch (iconName) {
      case 'creambath':
        return 'assets/images/Creambath icon.png';
      case 'creambath_sauna':
        return 'assets/images/Creambath + Sauna.png';
      case 'pijat':
        return 'assets/images/Massage.png';
      case 'pijat_scrub':
        return 'assets/images/Massage + Scrub.png';
      case 'sauna':
        return 'assets/images/Sauna.png';
      default:
        return null;
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
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: _getImagePath(paket.iconName) != null
                ? Image.asset(
                    _getImagePath(paket.iconName)!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.spa,
                      size: 28,
                      color: Color(0xFF2C1810),
                    ),
                  )
                  : const Icon(
                    Icons.spa,
                    size: 28,
                    color: Color(0xFF2C1810),
                  ),
          ),

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
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(width: 14),
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
                backgroundColor: isSelected 
                    ? const Color(0xFF2C1810) 
                    : const Color(0xFFE7A372),
                foregroundColor: isSelected 
                    ? Colors.white 
                    : const Color(0xFF411E19),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                isSelected ? 'Batalkan Pilihan' : 'Pilih Paket',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}