import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy notifikasi
    List<Map<String, dynamic>> notifikasiData = [
      {'Nomor': '1', 'Notifikasi': 'Pengajuan kerja sama berhasil dikirim.'},
      {'Nomor': '2', 'Notifikasi': 'Laporan kemajuan telah diperbarui.'},
    ];

    return MainLayout(
      title: 'Daftar Notifikasi',
      child:
          notifikasiData.isEmpty
              ? const Center(
                child: Text(
                  "Belum ada notifikasi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
              : TableData(
                title: 'Notifikasi',
                columns: const ['Nomor', 'Notifikasi'],
                data: notifikasiData,
                actionLabel: 'Send',
                onActionPressed: (_, __) {},
              ),
    );
  }
}
