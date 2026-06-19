import 'package:flutter/material.dart';
import '../models/paket_spa.dart';
import 'form_data_diri_screen.dart';

class PilihTanggalScreen extends StatefulWidget {
  final List<PaketSpa> selectedPaket;
  final int totalHarga;

  const PilihTanggalScreen({
    super.key,
    required this.selectedPaket,
    required this.totalHarga,
  });

  @override
  State<PilihTanggalScreen> createState() => _PilihTanggalScreenState();
}

class _PilihTanggalScreenState extends State<PilihTanggalScreen> {
  int _jumlahTamu = 1;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  String? _selectedWaktu;

  final List<String> _waktuList = [
    '10.00', '11.00', '12.00',
    '13.00', '14.00', '15.00',
    '16.00', '17.00', '18.00',
  ];

  final List<String> _namaHari = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  final List<String> _namaBulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  // ─── Helpers ─────────────────────────────────────────────────────────────

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

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

  /// Membangun list tanggal untuk grid kalender.
  /// - null  → sel kosong (sebelum hari ke-1)
  /// - bulan berbeda → tanggal bulan berikutnya (ditampilkan abu-abu)
  List<DateTime?> _buildCalendarDays() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay  = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    // Dart weekday: Mon=1 … Sun=7. Untuk layout Su-first: posisi = weekday % 7
    final int startPos = firstDay.weekday % 7;

    final List<DateTime?> days = [];

    // Sel kosong sebelum hari pertama
    for (int i = 0; i < startPos; i++) {
      days.add(null);
    }

    // Hari-hari bulan ini
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(_focusedMonth.year, _focusedMonth.month, i));
    }

    // Isi sisa baris terakhir dengan hari bulan berikutnya (abu-abu)
    final int remaining = days.length % 7 == 0 ? 0 : 7 - (days.length % 7);
    for (int i = 1; i <= remaining; i++) {
      days.add(DateTime(_focusedMonth.year, _focusedMonth.month + 1, i));
    }

    return days;
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final calendarDays = _buildCalendarDays();

    return Scaffold(
      backgroundColor: const Color(0xFFEFEBE4),
      appBar: AppBar(
        title: const Text(
          'Pilih Tanggal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Ringkasan Paket yang Dipilih ──────────────────────────────
            _buildRingkasanPaket(),
            const SizedBox(height: 24),

            // ─── Jumlah Tamu ─────────────────────────────────────────────
            _sectionLabel('Jumlah tamu:'),
            const SizedBox(height: 10),
            _buildJumlahTamuSelector(),
            const SizedBox(height: 24),

            // ─── Tanggal ─────────────────────────────────────────────────
            _sectionLabel('Tanggal:'),
            const SizedBox(height: 10),
            _buildCalendar(calendarDays),
            const SizedBox(height: 24),

            // ─── Waktu ───────────────────────────────────────────────────
            _sectionLabel('Waktu:'),
            const SizedBox(height: 10),
            _buildWaktuGrid(),
            const SizedBox(height: 32),

            // ─── Tombol Konfirmasi ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _selectedWaktu != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FormDataDiriScreen(
                              selectedPaket: widget.selectedPaket,
                              totalHargaPaket: widget.totalHarga,
                              jumlahTamu: _jumlahTamu,
                              selectedDate: _selectedDate,
                              selectedWaktu: _selectedWaktu!,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4956A),
                  disabledBackgroundColor:
                      const Color(0xFFD4956A).withOpacity(0.45),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Konfirmasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ─── Ringkasan Paket ─────────────────────────────────────────────────────

  Widget _buildRingkasanPaket() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paket yang Dipilih',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...widget.selectedPaket.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(p.nama,
                            style: const TextStyle(fontSize: 13))),
                    Text(_formatHarga(p.harga),
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(_formatHarga(widget.totalHarga),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFFD4956A))),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Section Label ───────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1C1C1C),
      ),
    );
  }

  // ─── Jumlah Tamu ─────────────────────────────────────────────────────────

  Widget _buildJumlahTamuSelector() {
    return Row(
      children: [
        _circleButton(
          icon: Icons.remove,
          onTap: () {
            if (_jumlahTamu > 1) setState(() => _jumlahTamu--);
          },
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text(
                '$_jumlahTamu',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1C),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _circleButton(
          icon: Icons.add,
          onTap: () => setState(() => _jumlahTamu++),
        ),
      ],
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFF2C1810),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  // ─── Kalender ────────────────────────────────────────────────────────────

  Widget _buildCalendar(List<DateTime?> days) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: navigasi bulan & tahun
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tombol bulan sebelumnya
              GestureDetector(
                onTap: () => setState(() {
                  _focusedMonth = DateTime(
                      _focusedMonth.year, _focusedMonth.month - 1);
                }),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.chevron_left,
                      size: 20, color: Color(0xFF1C1C1C)),
                ),
              ),

              // Dropdown bulan + tahun
              Row(
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _focusedMonth.month,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1C1C)),
                      icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                      items: List.generate(
                        12,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text(_namaBulan[i]),
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _focusedMonth =
                              DateTime(_focusedMonth.year, val));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _focusedMonth.year,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1C1C)),
                      icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                      items: List.generate(
                        5,
                        (i) => DropdownMenuItem(
                          value: DateTime.now().year + i,
                          child: Text('${DateTime.now().year + i}'),
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _focusedMonth =
                              DateTime(val, _focusedMonth.month));
                        }
                      },
                    ),
                  ),
                ],
              ),

              // Tombol bulan berikutnya
              GestureDetector(
                onTap: () => setState(() {
                  _focusedMonth = DateTime(
                      _focusedMonth.year, _focusedMonth.month + 1);
                }),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.chevron_right,
                      size: 20, color: Color(0xFF1C1C1C)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Header nama hari
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _namaHari
                .map((d) => SizedBox(
                      width: 36,
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF888888),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 4),

          // Grid tanggal (baris per minggu)
          ...List.generate(days.length ~/ 7, (weekIndex) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                return _buildDayCell(days[weekIndex * 7 + dayIndex]);
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDayCell(DateTime? date) {
    // Sel kosong
    if (date == null) {
      return const SizedBox(width: 36, height: 40);
    }

    final bool isCurrentMonth = date.month == _focusedMonth.month;
    final bool isSelected =
        isCurrentMonth && _isSameDay(date, _selectedDate);

    return GestureDetector(
      onTap: isCurrentMonth
          ? () => setState(() => _selectedDate = date)
          : null,
      child: Container(
        width: 36,
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFD4956A).withOpacity(0.28),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.normal,
              color: !isCurrentMonth
                  ? const Color(0xFFCCCCCC)         // abu-abu → bulan lain
                  : isSelected
                      ? const Color(0xFF8B5E3C)     // coklat → dipilih
                      : const Color(0xFF1C1C1C),    // hitam  → normal
            ),
          ),
        ),
      ),
    );
  }

  // ─── Grid Waktu ──────────────────────────────────────────────────────────

  Widget _buildWaktuGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.5,
      ),
      itemCount: _waktuList.length,
      itemBuilder: (context, index) {
        final String waktu = _waktuList[index];
        final bool isSelected = _selectedWaktu == waktu;

        return GestureDetector(
          onTap: () => setState(() => _selectedWaktu = waktu),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFD4956A).withOpacity(0.28)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFD4956A)
                    : Colors.grey.shade200,
              ),
            ),
            child: Center(
              child: Text(
                waktu,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.normal,
                  color: isSelected
                      ? const Color(0xFF8B5E3C)
                      : const Color(0xFF1C1C1C),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}