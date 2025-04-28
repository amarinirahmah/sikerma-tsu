import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/app_drawer.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data dummy
    final List<Map<String, dynamic>> dataProgres = [
      {
        'namaMitra': 'PT Maju Jaya',
        'tanggalMulai': '2024-01-01',
        'tanggalBerakhir': '2025-01-01',
        'status': 'Aktif',
      },
      {
        'namaMitra': 'CV Sukses Makmur',
        'tanggalMulai': '2023-06-15',
        'tanggalBerakhir': '2024-06-14',
        'status': 'Nonaktif',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Progres Kerja Sama')),
      drawer: const AppDrawer(), // Tetap pakai AppDrawer
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nama Mitra')),
                DataColumn(label: Text('Tanggal Mulai')),
                DataColumn(label: Text('Tanggal Berakhir')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Aksi')),
              ],
              rows:
                  dataProgres.map((progres) {
                    return DataRow(
                      cells: [
                        DataCell(Text(progres['namaMitra'])),
                        DataCell(Text(progres['tanggalMulai'])),
                        DataCell(Text(progres['tanggalBerakhir'])),
                        DataCell(
                          Text(
                            progres['status'],
                            style: TextStyle(
                              color:
                                  progres['status'] == 'Aktif'
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              // Aksi ketika tombol detail ditekan
                              Navigator.pushNamed(context, '/detailprogres');
                            },
                            child: const Text('Detail'),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
