import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/detail_card.dart';
import 'package:sikermatsu/models/app_state.dart';

class DetailPKLPage extends StatefulWidget {
  const DetailPKLPage({super.key});

  @override
  _DetailPKLPageState createState() => _DetailPKLPageState();
}

class _DetailPKLPageState extends State<DetailPKLPage> {
  String currentStatus = 'Diproses'; // default status

  @override
  Widget build(BuildContext context) {
    final role = AppState.role.value; // ambil role

    final Map<String, dynamic> dataPKL = {
      'NISN': '1234567890',
      'Nama Siswa': 'Andi',
      'Nama Sekolah': 'SMK Negeri 1',
      'Tanggal Mulai': '2025-07-01',
      'Tanggal Berakhir': '2025-09-30',
      'File': 'surat_pkl.pdf',
      'Kontak': '08123456789 / andi@email.com',
      'Alamat': 'Jl. Merdeka No. 1',
    };

    return MainLayout(
      title: '',
      isLoggedIn: AppState.isLoggedIn.value,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: DetailCard(
              data: dataPKL,
              role: role,
              currentStatus: currentStatus,
              onStatusChange: (newStatus) async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Konfirmasi'),
                        content: Text(
                          'Yakin ingin mengubah status menjadi "$newStatus"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Ya, Ubah'),
                          ),
                        ],
                      ),
                );

                if (confirmed == true) {
                  setState(() {
                    currentStatus = newStatus;
                  });
                  print('Status changed to: $newStatus');
                }
                // setState(() {
                //   currentStatus = newStatus;
                // });
                // print('Status changed to: $newStatus');
              },
              onEdit:
                  (role == 'admin' || role == 'user')
                      ? () {
                        Navigator.pushNamed(context, '/editpkl');
                      }
                      : null,
              onDelete:
                  (role == 'admin' || role == 'user')
                      ? () {
                        // your delete logic
                      }
                      : null,
            ),
          ),
        ),
      ),
    );
  }
}
