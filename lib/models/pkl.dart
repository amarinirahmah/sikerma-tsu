enum JenisKelamin { lakilaki, perempuan }

enum StatusPkl { diproses, disetujui, ditolak }

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

extension StatusPklExtension on StatusPkl {
  String toBackend() {
    switch (this) {
      case StatusPkl.diproses:
        return 'Diproses';
      case StatusPkl.disetujui:
        return 'Disetujui';
      case StatusPkl.ditolak:
        return 'Ditolak';
    }
  }

  static StatusPkl? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'diproses':
        return StatusPkl.diproses;
      case 'disetujui':
        return StatusPkl.disetujui;
      case 'ditolak':
        return StatusPkl.ditolak;
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
  final String telpEmail;
  final StatusPkl? status;
  final String alamat;

  Pkl({
    this.id,
    required this.nisn,
    required this.sekolah,
    required this.nama,
    required this.gender,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    this.filePkl,
    required this.telpEmail,
    required this.alamat,
    this.status,
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
      telpEmail: json['telpemail'],
      alamat: json['alamat'],
      status: StatusPklExtension.fromString(json['status']),
      // status: _statusFromString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nisn': nisn,
      'sekolah': sekolah,
      'nama': nama,
      'gender': gender.toBackend(),
      'tanggal_mulai': tanggalMulai.toIso8601String(),
      'tanggal_berakhir': tanggalBerakhir.toIso8601String(),
      'file_pkl': filePkl,
      'telpemail': telpEmail,
      'alamat': alamat,
      'status': status?.toBackend(),
    };
  }

  // Helpers
  static StatusPkl? fromString(String? status) {
    if (status == null) return null;
    switch (status.toLowerCase()) {
      case 'diproses':
        return StatusPkl.diproses;
      case 'disetujui':
        return StatusPkl.disetujui;
      case 'ditolak':
        return StatusPkl.ditolak;
      default:
        return null;
    }
  }

  // Pkl copyWith({
  //   int? id,
  //   String? nisn,
  //   String? sekolah,
  //   String? nama,
  //   JenisKelamin? gender,
  //   DateTime? tanggalMulai,
  //   DateTime? tanggalBerakhir,
  //   String? filePkl,
  //   String? telpEmail,
  //   StatusPkl? status,
  //   String? alamat,
  // }) {
  //   return Pkl(
  //     id: id ?? this.id,
  //     nisn: nisn ?? this.nisn,
  //     sekolah: sekolah ?? this.sekolah,
  //     nama: nama ?? this.nama,
  //     gender: gender ?? this.gender,
  //     tanggalMulai: tanggalMulai ?? this.tanggalMulai,
  //     tanggalBerakhir: tanggalBerakhir ?? this.tanggalBerakhir,
  //     filePkl: filePkl ?? this.filePkl,
  //     telpEmail: telpEmail ?? this.telpEmail,
  //     status: status ?? this.status,
  //     alamat: alamat ?? this.alamat,
  //   );
  // }

  String get statusText {
    switch (status) {
      case StatusPkl.diproses:
        return 'Diproses';
      case StatusPkl.disetujui:
        return 'Disetujui';
      case StatusPkl.ditolak:
        return 'Ditolak';
      default:
        return '-';
    }
  }
}
