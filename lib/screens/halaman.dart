import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'pilih_tanggal_screen.dart';
import '../models/paket_spa.dart';

class Halaman extends StatefulWidget {
  const Halaman({super.key});

  @override
  State<Halaman> createState() => _HalamanState();
}

class _HalamanState extends State<Halaman> {
  final List<PaketSpa> _selectedPaket = [];

  void _togglePaket(PaketSpa paket) {
    setState(() {
      if (_selectedPaket.any((p) => p.id == paket.id)) {
        _selectedPaket.removeWhere((p) => p.id == paket.id);
      } else {
        _selectedPaket.add(paket);
      }
    });
  }

  int get _totalHarga => _selectedPaket.fold(0, (sum, p) => sum + p.harga);

  String _formatHarga(int harga) {
    String hargaStr = harga.toString();
    String result = '';
    int counter = 0;
    for (int i = hargaStr.length - 1; i >= 0; i--) {
      if (counter != 0 && counter % 3 == 0) result = '.$result';
      result = hargaStr[i] + result;
      counter++;
    }
    return 'Rp. $result';
  }

  void _showPesanan(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F0EB),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text('Paket yang Dipilih',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._selectedPaket.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(p.nama,
                              style: const TextStyle(fontSize: 14))),
                      Text(_formatHarga(p.harga),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text(_formatHarga(_totalHarga),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFFE7A372))),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // tutup bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PilihTanggalScreen(
                        selectedPaket: _selectedPaket,
                        totalHarga: _totalHarga,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE7A372),
                  foregroundColor: const Color(0xFF411E19),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Lanjutkan Pemesanan',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashboardScreen(
        selectedPaket: _selectedPaket,
        onToggle: _togglePaket,
      ),
      floatingActionButton: _selectedPaket.isNotEmpty
          ? GestureDetector(
              onTap: () => _showPesanan(context),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C1810),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedPaket.length} paket · ${_formatHarga(_totalHarga)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 12),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}