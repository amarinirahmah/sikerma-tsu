import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';

class MoUPage extends StatelessWidget {
  const MoUPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> daftarMou = [
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
      {
        'Nama Mitra': 'PT Maju Jaya',
        'Tanggal Mulai': '2024-01-01',
        'Tanggal Berakhir': '2025-01-01',
        'Status': 'Aktif',
      },
      {
        'Nama Mitra': 'CV Sukses Makmur Sukses Mantap',
        'Tanggal Mulai': '2023-06-15',
        'Tanggal Berakhir': '2024-06-14',
        'Status': 'Nonaktif',
      },
    ];

    return MainLayout(
      title: 'Daftar MoU',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: TableData(
                title: 'Daftar MoU',
                columns: [
                  'Nama Mitra',
                  'Tanggal Mulai',
                  'Tanggal Berakhir',
                  'Status',
                ],
                data: daftarMou,
                actionLabel: 'Detail',
                onActionPressed: (context, rowData) {
                  Navigator.pushNamed(context, '/detailmou');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
