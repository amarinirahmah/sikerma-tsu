import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/models/app_state.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        // Data dummy notifikasi
        List<Map<String, dynamic>> notifikasiData = [
          {
            'Nomor': '1',
            'Notifikasi':
                'Kerja sama dengan PT. ABC akan berakhir dalam 3 bulan.',
          },
          {
            'Nomor': '2',
            'Notifikasi':
                'Kerja sama dengan PT. XYZ akan berakhir dalam 1 bulan.',
          },
        ];

        return MainLayout(
          title: '',
          isLoggedIn: isLoggedIn,
          child:
              notifikasiData.isEmpty
                  ? const Center(
                    child: Text(
                      "Belum ada notifikasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : TableData(
                    title: 'Notifikasi',
                    columns: const ['Nomor', 'Notifikasi'],
                    data: notifikasiData,
                  ),
        );
      },
    );
  }
}
