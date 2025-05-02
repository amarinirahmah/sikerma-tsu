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
      title: 'Daftar Mou',
      child: TableData(
        title: 'Daftar Mou',
        columns: const [
          'Nama Mitra',
          'Tanggal Mulai',
          'Tanggal Berakhir',
          'Status',
        ],
        data: daftarMou,
        actionLabel: 'Detail',
        onActionPressed: (BuildContext context, Map<String, dynamic> rowData) {
          Navigator.pushNamed(context, '/detailmou');
        },
      ),
    );
  }
}
