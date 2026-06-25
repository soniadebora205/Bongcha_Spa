import '../models/paket_spa.dart';

class PaketData {
  static List<PaketSpa> getPaketKorean() {
    return [
      PaketSpa(
        id: 'korean_7in1',
        nama: '7 In One',
        durasi: 120,
        harga: 250000,
        deskripsi: 'Paket lengkap Korean Spa dengan 7 treatment terbaik untuk perawatan tubuh menyeluruh.',
        rincianTreatment: [
          'Creambath',
          'Sauna',
          'Washlap Korea',
          'Scrub and message',
          'Mandi susu',
          'Face relax Bong Cha',
          'Cuci rambut',
        ],
        imagePath: 'assets/images/package_7_in_one.png',
        isKoreanPackage: true,
      ),
      PaketSpa(
        id: 'korean_kids',
        nama: 'For Kids',
        durasi: 90,
        harga: 150000,
        deskripsi: 'Paket Korean Spa khusus anak-anak dengan treatment lembut dan aman.',
        rincianTreatment: [
          'Creambath lembut',
          'Washlap Korea anak',
          'Scrub ringan',
          'Mandi susu',
          'Cuci rambut',
        ],
        imagePath: 'assets/images/package_for_kids.png',
        isKoreanPackage: true,
      ),
      PaketSpa(
        id: 'korean_brides',
        nama: 'For Brides',
        durasi: 180,
        harga: 299000,
        deskripsi: 'Paket Korean Spa spesial untuk calon pengantin. Tampil cantik maksimal di hari istimewa.',
        rincianTreatment: [
          'Creambath premium',
          'Sauna',
          'Washlap Korea',
          'Scrub and message',
          'Mandi susu',
          'Face relax Bong Cha',
          'Cuci rambut',
        ],
        imagePath: 'assets/images/package_for_brides.png',
        isKoreanPackage: true,
      ),
    ];
  }

  static List<PaketSpa> getLayananLainnya() {
    return [
      PaketSpa(
        id: 'creambath',
        nama: 'Creambath',
        durasi: 60,
        harga: 50000,
        deskripsi: 'Perawatan rambut dengan cream khusus untuk menutrisi dan melembapkan rambut.',
        rincianTreatment: [
          'Aplikasi cream rambut',
          'Pemijatan kepala',
          'Steam rambut',
          'Bilas bersih',
        ],
        iconName: 'creambath',
        isKoreanPackage: false,
      ),
      PaketSpa(
        id: 'creambath_sauna',
        nama: 'Creambath + Sauna',
        durasi: 75,
        harga: 115000,
        deskripsi: 'Kombinasi perawatan rambut creambath dengan sesi sauna untuk relaksasi total.',
        rincianTreatment: [
          'Aplikasi cream rambut',
          'Pemijatan kepala',
          'Steam rambut',
          'Sesi sauna',
          'Bilas bersih',
        ],
        iconName: 'creambath_sauna',
        isKoreanPackage: false,
      ),
      PaketSpa(
        id: 'pijat',
        nama: 'Pijat',
        durasi: 60,
        harga: 125000,
        deskripsi: 'Pijat relaksasi seluruh tubuh dengan teknik tradisional untuk menghilangkan pegal dan stress.',
        rincianTreatment: [
          'Pijat punggung',
          'Pijat kaki',
          'Pijat bahu dan leher',
          'Pijat tangan',
        ],
        iconName: 'pijat',
        isKoreanPackage: false,
      ),
      PaketSpa(
        id: 'pijat_scrub',
        nama: 'Pijat + Scrub',
        durasi: 90,
        harga: 175000,
        deskripsi: 'Kombinasi pijat relaksasi dengan scrub untuk mengangkat sel kulit mati dan mencerahkan kulit.',
        rincianTreatment: [
          'Pijat seluruh tubuh',
          'Scrub badan',
          'Bilas bersih',
          'Pelembap tubuh',
        ],
        iconName: 'pijat',
        isKoreanPackage: false,
      ),
      PaketSpa(
        id: 'sauna',
        nama: 'Sauna',
        durasi: 20,
        harga: 65000,
        deskripsi: 'Sesi sauna untuk detoksifikasi, melancarkan sirkulasi darah, dan relaksasi.',
        rincianTreatment: [
          'Sesi sauna 20 menit',
          'Handuk bersih',
          'Air minum',
        ],
        iconName: 'sauna',
        isKoreanPackage: false,
      ),
    ];
  }

  static List<PaketSpa> getAllPaket() {
    return [...getPaketKorean(), ...getLayananLainnya()];
  }
}