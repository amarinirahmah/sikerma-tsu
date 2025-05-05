import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'pkl.dart';
// import 'detailpkl.dart';

class PKLPage extends StatefulWidget {
  const PKLPage({super.key});

  @override
  State<PKLPage> createState() => _PKLPageState();
}

class _PKLPageState extends State<PKLPage> {
  final List<Map<String, dynamic>> _dataPKL = [
    {
      'NISN': '1234567890',
      'Nama Siswa': 'Andi',
      'Tanggal Mulai': '2025-07-01',
      'Tanggal Berakhir': '2025-09-30',
      'Status': 'Disetujui',
    },
    {
      'NISN': '9876543210',
      'Nama Siswa': 'Budi',
      'Tanggal Mulai': '2025-08-01',
      'Tanggal Berakhir': '2025-10-31',
      'Status': 'Diproses',
    },
    {
      'NISN': '1122334455',
      'Nama Siswa': 'Dina',
      'Tanggal Mulai': '2025-09-01',
      'Tanggal Berakhir': '2025-11-30',
      'Status': 'Ditolak',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Pengajuan PKL',
      child: Stack(
        children: [
          TableData(
            title: 'Daftar Pengajuan PKL',
            columns: const [
              'NISN',
              'Nama Siswa',
              'Tanggal Mulai',
              'Tanggal Berakhir',
              'Status',
            ],
            data: _dataPKL,
            actionLabel: 'Detail',
            onActionPressed: (
              BuildContext context,
              Map<String, dynamic> rowData,
            ) {
              Navigator.pushNamed(context, '/detailpkl');
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UploadPKLPage()),
                ).then((_) => setState(() {}));
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
