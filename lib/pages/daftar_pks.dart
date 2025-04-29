import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/app_drawer.dart';

class PKSPage extends StatelessWidget {
  const PKSPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data dummy untuk daftar MoU
    final List<Map<String, dynamic>> daftarPKS = [
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
      appBar: AppBar(title: const Text('Daftar PKS')),
      drawer: const AppDrawer(), // Tetap pakai AppDrawer
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000), // Maksimal lebar
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nama Mitra')),
                DataColumn(label: Text('Tanggal Mulai')),
                DataColumn(label: Text('Tanggal Berakhir')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Detail')),
              ],
              rows:
                  daftarPKS.map((mou) {
                    return DataRow(
                      cells: [
                        DataCell(Text(mou['namaMitra'])),
                        DataCell(Text(mou['tanggalMulai'])),
                        DataCell(Text(mou['tanggalBerakhir'])),
                        DataCell(
                          Text(
                            mou['status'],
                            style: TextStyle(
                              color:
                                  mou['status'] == 'Aktif'
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              // Aksi saat tombol Detail ditekan
                              Navigator.pushNamed(context, '/detailpks');
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
