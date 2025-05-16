enum StatusMou { aktif, nonaktif }

enum KeteranganMou { diajukan, disetujui, dibatalkan }

class Mou {
  final String nomormou;
  final String nama;
  final String judul;
  final DateTime tanggalMulai;
  final DateTime tanggalBerakhir;
  final String? fileMou; // Nullable
  final String tujuan;
  final StatusMou? status; // Nullable: "aktif", "nonaktif"
  final KeteranganMou keterangan; // "diajukan", "disetujui", "dibatalkan"

  Mou({
    required this.nomormou,
    required this.nama,
    required this.judul,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    this.fileMou,
    required this.tujuan,
    this.status,
    required this.keterangan,
  });

  factory Mou.fromJson(Map<String, dynamic> json) {
    return Mou(
      nomormou: json['nomormou'],
      nama: json['nama'],
      judul: json['judul'],
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      tanggalBerakhir: DateTime.parse(json['tanggal_berakhir']),
      fileMou: json['file_mou'] as String?,
      tujuan: json['tujuan'],
      status: _statusFromString(json['status']),
      keterangan: _keteranganFromString(json['keterangan']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomormou': nomormou,
      'nama': nama,
      'judul': judul,
      'tanggal_mulai': tanggalMulai.toIso8601String(),
      'tanggal_berakhir': tanggalBerakhir.toIso8601String(),
      'file_mou': fileMou,
      'tujuan': tujuan,
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
      case 'nonaktif':
        return StatusMou.nonaktif;
      default:
        return null;
    }
  }

  static KeteranganMou _keteranganFromString(String keterangan) {
    switch (keterangan) {
      case 'diajukan':
        return KeteranganMou.diajukan;
      case 'disetujui':
        return KeteranganMou.disetujui;
      case 'dibatalkan':
        return KeteranganMou.dibatalkan;
      default:
        throw ArgumentError('Keterangan tidak valid: $keterangan');
    }
  }
}
