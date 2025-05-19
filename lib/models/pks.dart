enum StatusPks { aktif, nonaktif }

enum KeteranganPks { diajukan, disetujui, dibatalkan }

class Pks {
  final int? id;
  final String nomormou;
  final String nomorpks;
  final String judul;
  final DateTime tanggalMulai;
  final DateTime tanggalBerakhir;
  final String? filePks; // Nullable
  final String namaunit;
  final String tujuan;
  final StatusPks? status; // Nullable: "aktif", "nonaktif"
  final KeteranganPks keterangan; // "diajukan", "disetujui", "dibatalkan"

  Pks({
    this.id,
    required this.nomormou,
    required this.nomorpks,
    required this.judul,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    this.filePks,
    required this.namaunit,
    required this.tujuan,
    this.status,
    required this.keterangan,
  });

  factory Pks.fromJson(Map<String, dynamic> json) {
    return Pks(
      id: json['id'],
      nomormou: json['nomormou'],
      nomorpks: json['nomorpks'],
      judul: json['judul'],
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      tanggalBerakhir: DateTime.parse(json['tanggal_berakhir']),
      filePks: json['file_pks'] as String?,
      namaunit: json['namaunit'],
      tujuan: json['tujuan'],
      status: _statusFromString(json['status']),
      keterangan: _keteranganFromString(json['keterangan']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomormou': nomormou,
      'nomorpks': nomorpks,
      'judul': judul,
      'tanggal_mulai': tanggalMulai.toIso8601String(),
      'tanggal_berakhir': tanggalBerakhir.toIso8601String(),
      'file_pks': filePks,
      'namaunit': namaunit,
      'tujuan': tujuan,
      'status': status?.name,
      'keterangan': keterangan.name,
    };
  }

  // Helpers
  static StatusPks? _statusFromString(String? status) {
    if (status == null) return null;
    switch (status.toLowerCase()) {
      case 'aktif':
        return StatusPks.aktif;
      case 'nonaktif':
        return StatusPks.nonaktif;
      default:
        return null;
    }
  }

  static KeteranganPks _keteranganFromString(String keterangan) {
    switch (keterangan.toLowerCase()) {
      case 'diajukan':
        return KeteranganPks.diajukan;
      case 'disetujui':
        return KeteranganPks.disetujui;
      case 'dibatalkan':
        return KeteranganPks.dibatalkan;
      default:
        throw ArgumentError('Keterangan tidak valid: $keterangan');
    }
  }
}
