class Notifikasi {
  final int id;
  final String judul;
  final String isi;
  final String type;
  final DateTime tanggalNotif;

  Notifikasi({
    required this.id,
    required this.judul,
    required this.isi,
    required this.type,
    required this.tanggalNotif,
  });

  factory Notifikasi.fromJson(Map<String, dynamic> json) {
    return Notifikasi(
      id: json['id'],
      judul: json['judul'],
      isi: json['isi'],
      type: json['type'],
      tanggalNotif: DateTime.parse(json['tanggal_notif']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'type': type,
      'tanggal_notif': tanggalNotif.toIso8601String(),
    };
  }
}
