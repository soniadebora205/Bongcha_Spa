import 'package:flutter/material.dart';
import '../models/paket_spa.dart';

class PaketBottomSheet extends StatefulWidget {
  final PaketSpa paket;
  final bool isSelected;
  final VoidCallback onToggle;

  const PaketBottomSheet({
    super.key,
    required this.paket,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  State<PaketBottomSheet> createState() => _PaketBottomSheetState();
}

class _PaketBottomSheetState extends State<PaketBottomSheet> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F0EB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Judul paket
          Center(
            child: Text(
              widget.paket.nama,
              style: const TextStyle(
                fontFamily: 'Serif',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Rincian treatment
          const Text(
            'Rincian treatment:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 8),
          ...widget.paket.rincianTreatment.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('✓ ',
                      style: TextStyle(fontSize: 14, color: Color(0xFF1E1E1E))),
                  Expanded(
                    child: Text(item,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF1E1E1E))),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Durasi & Harga
          Text(
            'Durasi : ${widget.paket.durasi} menit',
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E)),
          ),
          const SizedBox(height: 4),
          Text(
            'Harga : ${_formatHarga(widget.paket.harga)}',
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E)),
          ),
          const SizedBox(height: 24),

          // Tombol Pilih / Batalkan Paket
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _isSelected = !_isSelected);
                widget.onToggle();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSelected
                    ? const Color(0xFF2C1810)
                    : const Color(0xFFD4956A),
                foregroundColor: const Color(0xFFffffff),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _isSelected ? 'Batalkan Pilihan' : 'Pilih Paket',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}