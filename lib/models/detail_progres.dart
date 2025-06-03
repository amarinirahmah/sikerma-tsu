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
      id: json['id'] ?? 0,
      tanggal: json['tanggal'] as String? ?? '',
      proses: json['proses'] as String? ?? '',
      aktivitas: json['aktivitas'] as String? ?? '',
      dataMouId: json['data_mou_id'] ?? 0,
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
