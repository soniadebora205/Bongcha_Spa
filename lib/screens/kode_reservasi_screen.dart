import 'dart:math';
import 'package:flutter/material.dart';

// ─── Enum status pembayaran ───────────────────────────────────────────────────
enum StatusPembayaran { menunggu, berhasil }

class KodeReservasiScreen extends StatelessWidget {
  final StatusPembayaran status;
  final String namaCustomer;
  final String tanggalRelaksasi;
  final String waktu;
  final int jumlahTamu;
  final String namaPaket;
  final int totalHarga;
  final String metodePembayaran;
  final String kodeReservasi;

  const KodeReservasiScreen({
    super.key,
    required this.status,
    required this.namaCustomer,
    required this.tanggalRelaksasi,
    required this.waktu,
    required this.jumlahTamu,
    required this.namaPaket,
    required this.totalHarga,
    required this.metodePembayaran,
    required this.kodeReservasi,
  });

  // ─── Static helper: generate kode reservasi ──
  static String generateKode() {
    const huruf = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final rand = Random();
    final angka = 100 + rand.nextInt(900);
    final akhir = huruf[rand.nextInt(huruf.length)];
    return 'BGC-$angka$akhir';
  }

  // ─── Format harga ─────────────────────────────────────────────────────────
  String _formatHarga(int harga) {
    final s = harga.toString();
    String result = '';
    int counter = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (counter != 0 && counter % 3 == 0) result = '.$result';
      result = s[i] + result;
      counter++;
    }
    return 'Rp. $result';
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final bool isPaid = status == StatusPembayaran.berhasil;

    return Scaffold(
      backgroundColor: const Color(0xFFC1BAB4),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'KODE RESERVASI',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFD9D9D9),
        foregroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ─── Gambar Status Pembayaran ───────────────────────────────────────────────
            Image.asset(
              isPaid
                  ? 'assets/images/success_icon.png'
                  : 'assets/images/waiting_icon.png',
              width: 120,
              height: 120,
              errorBuilder: (_, __, ___) => Icon(
              isPaid ? Icons.check_circle : Icons.hourglass_empty_rounded,
              size: 90,
              color: const Color(0xFF2C1810),
            ),
          ),

            // ─── Judul status ──────────────────────────────────────────────
            Text(
              isPaid ? 'Pembayaran Berhasil' : 'Menunggu Pembayaran',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1C1C),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Tunjukkan kode reservasi Anda ke kasir',
              style: TextStyle(fontSize: 13, color: Color(0xFF411E19)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // ─── Card utama ────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kode reservasi
                  Center(
                    child: Text(
                      kodeReservasi,
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C1C1C),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // ── Detail layanan ────────────────────────────────────────
                  _label('Detail layanan:'),
                  const SizedBox(height: 8),

                  _buildDetailTable(),

                  const SizedBox(height: 22),

                  // ── Rincian pembayaran ────────────────────────────────────
                  _label('Rincian pembayaran:'),
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5E6C8),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: const Color(0xFF8b7355), width: 1.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total tagihan:',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF888888))),
                        const SizedBox(height: 2),
                        Text(
                          _formatHarga(totalHarga),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1C1C1C),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(metodePembayaran,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF777777))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Terima kasih
                  const Center(
                    child: Text(
                      'Terima kasih atas reservasi Anda.',
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF555555)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ─── Catatan kecil ─────────────────────────────────────────────
            const Text(
              '* Mohon hadir 15 menit sebelum jadwal terapi dimulai untuk persiapan.',
              style: TextStyle(fontSize: 11, color: Color(0xFF411E19)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // ─── Tombol kembali ke beranda ─────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Kembali langsung ke halaman pertama (beranda)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4956A),
                  foregroundColor: const Color(0xFF411E19),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Kembali ke Beranda',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Widget helpers ────────────────────────────────────────────────────────

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1C1C)),
    );
  }

Widget _buildDetailTable() {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFF8B7355), width: 1.0),
      borderRadius: BorderRadius.circular(6),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        // Baris 1: Nama | Tanggal
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _tableCell(
                  label: 'Nama:',
                  value: namaCustomer.toUpperCase(),
                  bgColor: Colors.white,          // ← putih
                  kananBorder: true,
                  bawahBorder: true,
                ),
              ),
              Expanded(
                child: _tableCell(
                  label: 'Tanggal relaksasi:',
                  value: tanggalRelaksasi.toUpperCase(),
                  bgColor: Colors.white,
                  kananBorder: false,
                  bawahBorder: true,
                ),
              ),
            ],
          ),
        ),
        // Baris 2: Waktu | Jumlah tamu | Nama paket
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _tableCell(
                  label: 'Waktu:',
                  value: '$waktu WIB',
                  bgColor: const Color(0xFFF5E6C8), // ← kuning
                  kananBorder: true,
                  bawahBorder: false,
                ),
              ),
              Expanded(
                child: _tableCell(
                  label: 'Jumlah tamu:',
                  value: '$jumlahTamu ORANG',
                  bgColor: Colors.white,          // ← putih
                  kananBorder: true,
                  bawahBorder: false,
                ),
              ),
              Expanded(
                child: _tableCell(
                  label: 'Nama',
                  value: namaPaket.toUpperCase(),
                  bgColor: const Color(0xFFF5E6C8), // ← kuning
                  kananBorder: false,
                  bawahBorder: false,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _tableCell({
  required String label,
  required String value,
  required Color bgColor,
  required bool kananBorder,
  required bool bawahBorder,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: bgColor,
      border: Border(
        right: kananBorder
            ? const BorderSide(color: Color(0xFF8B7355), width: 1.0)
            : BorderSide.none,
        bottom: bawahBorder
            ? const BorderSide(color: Color(0xFF8B7355), width: 1.0)
            : BorderSide.none,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF888888))),
        const SizedBox(height: 3),
        Text(value,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1C1C))),
      ],
    ),
  );
  }
}


