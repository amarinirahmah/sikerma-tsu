import 'dart:convert';

enum StatusMou { aktif, nonaktif }

enum KeteranganMou { diajukan, disetujui, dibatalkan }

extension KeteranganMouExt on KeteranganMou {
  String get label {
    switch (this) {
      case KeteranganMou.diajukan:
        return 'Diajukan';
      case KeteranganMou.disetujui:
        return 'Disetujui';
      case KeteranganMou.dibatalkan:
        return 'Dibatalkan';
    }
  }
}

class Pihak {
  final String nama;
  final String jabatan;
  final String alamat;

  Pihak({required this.nama, required this.jabatan, required this.alamat});

  factory Pihak.fromJson(Map<String, dynamic> json) {
    return Pihak(
      nama: json['nama'],
      jabatan: json['jabatan'],
      alamat: json['alamat'],
    );
  }

  factory Pihak.fromMap(Map<String, dynamic> map) {
    return Pihak(
      nama: map['nama'] ?? '',
      jabatan: map['jabatan'] ?? '',
      alamat: map['alamat'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'nama': nama,
    'jabatan': jabatan,
    'alamat': alamat,
  };

  Map<String, dynamic> toJson() {
    return {'nama': nama, 'jabatan': jabatan, 'alamat': alamat};
  }
}

class Mou {
  final int? id;
  final String nomorMou;
  final String nomorMou2;
  final String nama;
  final String judul;
  final DateTime tanggalMulai;
  final DateTime tanggalBerakhir;
  final String? fileMou; // Nullable
  final String ruangLingkup;
  final Pihak pihak1;
  final Pihak pihak2;

  final StatusMou? status; // Nullable: "aktif", "nonaktif"
  final KeteranganMou keterangan; // "diajukan", "disetujui", "dibatalkan"

  Mou({
    this.id,
    required this.nomorMou,
    required this.nomorMou2,
    required this.nama,
    required this.judul,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    this.fileMou,
    required this.ruangLingkup,
    required this.pihak1,
    required this.pihak2,
    this.status,
    required this.keterangan,
  });

  factory Mou.fromJson(Map<String, dynamic> json) {
    // Parse pihak1, bisa langsung Map atau String JSON
    final pihak1Data = json['pihak1'];
    final pihak1Map =
        pihak1Data is String ? jsonDecode(pihak1Data) : pihak1Data;

    // Parse pihak2, bisa langsung Map atau String JSON
    final pihak2Data = json['pihak2'];
    final pihak2Map =
        pihak2Data is String ? jsonDecode(pihak2Data) : pihak2Data;
    return Mou(
      // id: json['id'],
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      nomorMou: json['nomormou'],
      nomorMou2: json['nomormou2'],
      nama: json['nama'],
      judul: json['judul'],
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      tanggalBerakhir: DateTime.parse(json['tanggal_berakhir']),
      fileMou: json['file_mou'] as String?,
      ruangLingkup: json['ruanglingkup'],
      pihak1: Pihak.fromJson(pihak1Map),
      pihak2: Pihak.fromJson(pihak2Map),
      status: _statusFromString(json['status']),
      keterangan: _keteranganFromString(json['keterangan']),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'nomormou': nomorMou,
    'nomormou2': nomorMou2,
    'nama': nama,
    'judul': judul,
    'tanggal_mulai': tanggalMulai.toIso8601String(),
    'tanggal_berakhir': tanggalBerakhir.toIso8601String(),
    'ruanglingkup': ruangLingkup,
    'nama1': pihak1.nama,
    'jabatan1': pihak1.jabatan,
    'alamat1': pihak1.alamat,
    'nama2': pihak2.nama,
    'jabatan2': pihak2.jabatan,
    'alamat2': pihak2.alamat,
    'status': status,
    'keterangan': keteranganToBackend(keterangan),
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomormou': nomorMou,
      'nomormou2': nomorMou2,
      'nama': nama,
      'judul': judul,
      'tanggal_mulai': tanggalMulai.toIso8601String(),
      'tanggal_berakhir': tanggalBerakhir.toIso8601String(),
      'file_mou': fileMou,
      'ruanglingkup': ruangLingkup,
      'pihak1': pihak1.toJson(),
      'pihak2': pihak2.toJson(),
      'status': status?.name,
      'keterangan': keterangan.name,
    };
  }

  // Helpers
  static StatusMou? _statusFromString(String? status) {
    // switch (status) {
    //   case 'aktif':
    //     return StatusMou.aktif;
    //   case 'nonaktif':
    //     return StatusMou.nonaktif;
    //   default:
    //     return null;
    // }
    if (status == null) return null;
    switch (status.toString().toLowerCase()) {
      case 'aktif':
        return StatusMou.aktif;
      case 'tidak aktif':
        return StatusMou.nonaktif;
      default:
        return null;
    }
  }

  static KeteranganMou _keteranganFromString(String keterangan) {
    // switch (keterangan) {
    switch (keterangan.toLowerCase()) {
      case 'diajukan':
        return KeteranganMou.diajukan;
      case 'disetujui':
        return KeteranganMou.disetujui;
      case 'dibatalkan':
        return KeteranganMou.dibatalkan;
      default:
        return KeteranganMou.diajukan;
    }
  }

  String keteranganToBackend(KeteranganMou keterangan) {
    switch (keterangan) {
      case KeteranganMou.diajukan:
        return 'Diajukan';
      case KeteranganMou.disetujui:
        return 'Disetujui';
      case KeteranganMou.dibatalkan:
        return 'Dibatalkan';
    }
  }

  String get statusText {
    switch (status) {
      case StatusMou.aktif:
        return 'Aktif';
      case StatusMou.nonaktif:
        return 'Tidak Aktif';
      default:
        return '-';
    }
  }

  String get keteranganText {
    switch (keterangan) {
      case KeteranganMou.diajukan:
        return 'Diajukan';
      case KeteranganMou.disetujui:
        return 'Disetujui';
      case KeteranganMou.dibatalkan:
        return 'Dibatalkan';
    }
  }
}
