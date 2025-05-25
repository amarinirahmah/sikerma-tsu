enum JenisKelamin { lakilaki, perempuan }

extension JenisKelaminExtension on JenisKelamin {
  String toBackend() {
    switch (this) {
      case JenisKelamin.lakilaki:
        return 'laki-laki';
      case JenisKelamin.perempuan:
        return 'perempuan';
    }
  }

  static JenisKelamin? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'laki-laki':
        return JenisKelamin.lakilaki;
      case 'perempuan':
        return JenisKelamin.perempuan;
      default:
        return null;
    }
  }
}

class Pkl {
  final int? id;
  final String nisn;
  final String sekolah;
  final String nama;
  final JenisKelamin gender;
  final DateTime tanggalMulai;
  final DateTime tanggalBerakhir;
  final String? filePkl;
  final String telpemail;
  final String alamat;
  final String? createdAt;
  final String? updatedAt;

  Pkl({
    this.id,
    required this.nisn,
    required this.sekolah,
    required this.nama,
    required this.gender,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    this.filePkl,
    required this.telpemail,
    required this.alamat,
    this.createdAt,
    this.updatedAt,
  });

  factory Pkl.fromJson(Map<String, dynamic> json) {
    return Pkl(
      id: json['id'],
      nisn: json['nisn'],
      sekolah: json['sekolah'],
      nama: json['nama'],
      gender:
          JenisKelaminExtension.fromString(json['gender']) ??
          JenisKelamin.lakilaki,
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      tanggalBerakhir: DateTime.parse(json['tanggal_berakhir']),
      filePkl: json['file_pkl'] as String?,
      telpemail: json['telpemail'],
      alamat: json['alamat'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nisn': nisn,
      'sekolah': sekolah,
      'nama': nama,
      'gender': gender.toBackend(),
      'tanggal_mulai': tanggalMulai.toIso8601String(),
      'tanggal_berakhir': tanggalBerakhir.toIso8601String(),
      'file_pkl': filePkl,
      'telpemail': telpemail,
      'alamat': alamat,
    };
  }
}
