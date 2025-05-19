import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/widgets/notif_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> notifikasiData = [];

  @override
  void initState() {
    super.initState();
    loadNotifikasi();
  }

  Future<void> loadNotifikasi() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      notifikasiData = [
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
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        return MainLayout(
          title: '',
          isLoggedIn: isLoggedIn,
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notifikasiData.isEmpty
                  ? const Center(
                    child: Text(
                      "Belum ada notifikasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    children:
                        notifikasiData.map((notif) {
                          return Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1000),
                              child: NotificationCard(
                                icon: Icons.notifications,
                                description: notif['Notifikasi'],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
        );
      },
    );
  }
}
