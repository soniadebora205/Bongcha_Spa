class PaketSpa {
  final String id;
  final String nama;
  final int durasi; // dalam menit
  final int harga; // dalam rupiah
  final String deskripsi;
  final List<String> rincianTreatment;
  final String? imagePath; // untuk paket Korean Spa
  final String? iconName; // untuk layanan lainnya
  final bool isKoreanPackage;

  PaketSpa({
    required this.id,
    required this.nama,
    required this.durasi,
    required this.harga,
    required this.deskripsi,
    required this.rincianTreatment,
    this.imagePath,
    this.iconName,
    this.isKoreanPackage = false,
  });
}