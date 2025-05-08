import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/pages/mou.dart';

class MoUPage extends StatefulWidget {
  const MoUPage({super.key});

  @override
  State<MoUPage> createState() => _MoUPage();
}

class _MoUPage extends State<MoUPage> {
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
      'Nama Mitra': 'CV Sukses Makmur',
      'Tanggal Mulai': '2023-06-15',
      'Tanggal Berakhir': '2024-06-14',
      'Status': 'Nonaktif',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Daftar MoU',
      child: Stack(
        children: [
          TableData(
            title: 'Daftar MoU',
            columns: const [
              'Nama Mitra',
              'Tanggal Mulai',
              'Tanggal Berakhir',
              'Status',
            ],
            data: daftarMou,
            actionLabel: 'Detail',
            getActionBgColor: (label) {
              if (label == 'Hapus') return Colors.red;
              if (label == 'Detail' || label == 'Upload' || label == 'Send')
                return Colors.teal;
              return Colors.teal;
            },
            getActionFgColor: (_) => Colors.white,
            onActionPressed: (
              BuildContext context,
              Map<String, dynamic> rowData,
            ) {
              Navigator.pushNamed(context, '/detailmou');
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UploadMoUPage()),
                ).then((_) {
                  setState(() {});
                });
              },
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
