import 'package:flutter/material.dart';
import '../models/paket_spa.dart';

/// Model sederhana untuk item add-on.
class AddOnItem {
  final String nama;
  final int harga;
  const AddOnItem(this.nama, this.harga);
}

class FormDataDiriScreen extends StatefulWidget {
  final List<PaketSpa> selectedPaket;
  final int totalHargaPaket;
  final int jumlahTamu;
  final DateTime selectedDate;
  final String selectedWaktu;

  const FormDataDiriScreen({
    super.key,
    required this.selectedPaket,
    required this.totalHargaPaket,
    required this.jumlahTamu,
    required this.selectedDate,
    required this.selectedWaktu,
  });

  @override
  State<FormDataDiriScreen> createState() => _FormDataDiriScreenState();
}

class _FormDataDiriScreenState extends State<FormDataDiriScreen> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _umurController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _pesanController = TextEditingController();

  // ─── Add-on (multi-select) ────────────────────────────────────────────────
  final List<AddOnItem> _addOnList = const [
    AddOnItem('Susu bubuk', 10000),
    AddOnItem('Masker timun', 20000),
    AddOnItem('Masker mata', 10000),
    AddOnItem('Vitamin rambut', 5000),
  ];
  final Set<int> _selectedAddOnIndex = {};

  // ─── Pembayaran (single-select) ───────────────────────────────────────────
  String _metodePembayaran = 'tunai'; // 'qris' | 'tunai'

  @override
  void dispose() {
    _namaController.dispose();
    _umurController.dispose();
    _whatsappController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

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

  int get _totalAddOn => _selectedAddOnIndex.fold(
      0, (sum, i) => sum + _addOnList[i].harga);

  int get _totalKeseluruhan => widget.totalHargaPaket + _totalAddOn;

  String get _tanggalFormatted {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    final d = widget.selectedDate;
    return '${d.day} ${namaBulan[d.month - 1]} ${d.year}';
  }

  /// Data siap dikirim ke Supabase (tabel `reservasi`, misalnya).
  Map<String, dynamic> _buildPayload() {
    return {
      'nama': _namaController.text.trim(),
      'umur': int.tryParse(_umurController.text.trim()),
      'nomor_whatsapp': _whatsappController.text.trim(),
      'pesan_tambahan': _pesanController.text.trim(),
      'paket': widget.selectedPaket.map((p) => p.nama).toList(),
      'tanggal_reservasi': widget.selectedDate.toIso8601String(),
      'waktu_reservasi': widget.selectedWaktu,
      'jumlah_tamu': widget.jumlahTamu,
      'add_on': _selectedAddOnIndex.map((i) => _addOnList[i].nama).toList(),
      'metode_pembayaran': _metodePembayaran, // 'qris' | 'tunai'
      'total_harga_paket': widget.totalHargaPaket,
      'total_harga_addon': _totalAddOn,
      'total_pembayaran': _totalKeseluruhan,
      'status': 'menunggu_pembayaran',
    };
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final payload = _buildPayload();

    // TODO: kirim payload ke Supabase, contoh:
    // await supabase.from('reservasi').insert(payload);

    // TODO: navigasi ke halaman Pembayaran, bawa payload + totalKeseluruhan
    debugPrint(payload.toString());
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCDC2B6),
      appBar: AppBar(
        title: const Text(
          'FORM DATA DIRI',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE9E3DA),
        foregroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Nama'),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _namaController,
                      hint: 'Masukkan nama lengkap',
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 18),

                    _fieldLabel('Umur'),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _umurController,
                      hint: 'Masukkan umur',
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Umur wajib diisi';
                        if (int.tryParse(v.trim()) == null) return 'Umur harus berupa angka';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    _fieldLabel('Nomor Whatsapp'),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _whatsappController,
                      hint: '08xx-xxxx-xxxx',
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Nomor Whatsapp wajib diisi' : null,
                    ),
                    const SizedBox(height: 18),

                    _fieldLabel('Pesan tambahan (dapat diisi dengan keluhan)'),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _pesanController,
                      hint: 'Tulis keluhan atau permintaan khusus...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 22),

                    _fieldLabel('Add on :'),
                    const SizedBox(height: 8),
                    ...List.generate(_addOnList.length, (i) {
                      final item = _addOnList[i];
                      final selected = _selectedAddOnIndex.contains(i);
                      return _checkboxRow(
                        label: '${item.nama} (${_formatHarga(item.harga)})',
                        selected: selected,
                        onTap: () => setState(() {
                          selected
                              ? _selectedAddOnIndex.remove(i)
                              : _selectedAddOnIndex.add(i);
                        }),
                      );
                    }),
                    const SizedBox(height: 14),

                    _fieldLabel('Pembayaran via :'),
                    const SizedBox(height: 8),
                    _checkRow(
                      label: 'QRIS / E-Wallet',
                      selected: _metodePembayaran == 'qris',
                      onTap: () => setState(() => _metodePembayaran = 'qris'),
                    ),
                    _checkRow(
                      label: 'Tunai (bayar di tempat)',
                      selected: _metodePembayaran == 'tunai',
                      onTap: () => setState(() => _metodePembayaran = 'tunai'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ─── Ringkasan total (paket + add-on) ─────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reservasi · ${_tanggalFormatted} · ${widget.selectedWaktu} WIB',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pembayaran',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(_formatHarga(_totalKeseluruhan),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFFD4956A))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4956A),
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
      ),
    );
  }

  // ─── Sub-widgets ─────────────────────────────────────────────────────────

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1C1C1C),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Color(0xFF5C4A33)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB8A98C)),
        filled: true,
        fillColor: const Color(0xFFFBEFD4),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color(0xFFE8D6A8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color(0xFFE8D6A8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD4956A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _checkRow({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD4956A), width: 1.5),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD4956A),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1C1C1C))),
          ],
        ),
      ),
    );
  }

  /// Versi checkbox (kotak) untuk pilihan multi-select, mis. Add-on.
  Widget _checkboxRow({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5),
                color: selected ? const Color(0xFFD4956A) : Colors.transparent,
                border: Border.all(color: const Color(0xFFD4956A), width: 1.5),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1C1C1C))),
          ],
        ),
      ),
    );
  }
}