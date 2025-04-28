import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/app_drawer.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Anggap data notifikasi kosong (ini bisa digantikan dengan data yang sesuai)
    List<Map<String, String>> notifikasiData = [];

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Notifikasi")),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child:
              notifikasiData.isEmpty
                  ? Center(
                    child: Text(
                      "Belum ada notifikasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : DataTable(
                    columns: const [
                      DataColumn(label: Text('Nomor')),
                      DataColumn(label: Text('Notifikasi')),
                    ],
                    rows:
                        notifikasiData.map((data) {
                          return DataRow(
                            cells: [
                              DataCell(Text(data['nomor'] ?? '')),
                              DataCell(Text(data['notifikasi'] ?? '')),
                            ],
                          );
                        }).toList(),
                  ),
        ),
      ),
    );
  }
}
