class DetailProgress {
  final int id;
  final String tanggal;
  final String aktivitas;
  final String proses;
  final int dataMouId;

  DetailProgress({
    required this.id,
    required this.tanggal,
    required this.proses,
    required this.aktivitas,
    required this.dataMouId,
  });

  factory DetailProgress.fromJson(Map<String, dynamic> json) {
    return DetailProgress(
      id: json['id'],
      tanggal: json['tanggal'],
      proses: json['proses'],
      aktivitas: json['aktivitas'],
      dataMouId: json['data_mou_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal,
      'proses': proses,
      'aktivitas': aktivitas,
      'data_mou_id': dataMouId,
    };
  }
}
