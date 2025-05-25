import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/widgets/notif_card.dart';
import '../models/notifikasi.dart';
import '../services/notif_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = true;
  List<Notifikasi> notifikasiList = [];

  @override
  void initState() {
    super.initState();
    loadNotifikasi();
  }

  Future<void> loadNotifikasi() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final list = await NotifService().getAllNotif();
      setState(() {
        notifikasiList = list;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Tampilkan error kalau perlu
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat notifikasi')));
    }
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
                  : notifikasiList.isEmpty
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
                        notifikasiList.map((notif) {
                          return Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1000),
                              child: NotificationCard(
                                icon: Icons.notifications,
                                title: notif.judul,
                                description: notif.isi,
                                type: notif.type,
                                date: notif.tanggalNotif,
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
