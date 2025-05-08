import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/pages/pks.dart';

class PKSPage extends StatefulWidget {
  const PKSPage({super.key});

  @override
  State<PKSPage> createState() => _PKSPage();
}

class _PKSPage extends State<PKSPage> {
  final List<Map<String, dynamic>> daftarPKS = [
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
      title: 'Daftar PKS',
      child: Stack(
        children: [
          TableData(
            title: 'Daftar PKS',
            columns: const [
              'Nama Mitra',
              'Tanggal Mulai',
              'Tanggal Berakhir',
              'Status',
            ],
            data: daftarPKS,
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
              Navigator.pushNamed(context, '/detailpks');
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UploadPKSPage()),
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
