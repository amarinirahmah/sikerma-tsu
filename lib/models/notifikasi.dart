class Notifikasi {
  final int id;
  final String type;
  final String message;
  final DateTime tanggalNotif;

  Notifikasi({
    required this.id,
    required this.type,
    required this.message,
    required this.tanggalNotif,
  });

  factory Notifikasi.fromJson(Map<String, dynamic> json) {
    return Notifikasi(
      id: json['id'],
      type: json['type'],
      message: json['message'],
      tanggalNotif: DateTime.parse(json['tanggal_notif']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'message': message,
      'tanggal_notif': tanggalNotif.toIso8601String(),
    };
  }
}
