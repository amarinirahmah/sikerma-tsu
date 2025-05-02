import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dataProgres = [
      {
        'Nama Mitra': 'PT Maju Jaya',
        'Tanggal Mulai': '2024-01-01',
        'Tanggal Berakhir': '2025-01-01',
        'Status': 'Aktif',
      },
      {
        'Nama Mitra': 'CV Sukses Makmur',
        'Tanggal Mulai': '2023-06-15',
        'Tanggal Berakhir': '2024-06-14',
        'Status': 'Nonaktif',
      },
    ];

    return MainLayout(
      title: 'Daftar Progres Kerja Sama',
      child: TableData(
        title: 'Progres Kerja Sama',
        columns: const [
          'Nama Mitra',
          'Tanggal Mulai',
          'Tanggal Berakhir',
          'Status',
        ],
        data: dataProgres,
        actionLabel: 'Detail',
        onActionPressed: (context, rowData) {
          Navigator.pushNamed(context, '/detailprogres');
        },
      ),
    );
  }
}
