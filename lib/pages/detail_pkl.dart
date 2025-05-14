import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/detail_card.dart';
import 'package:sikermatsu/models/app_state.dart';

class DetailPKLPage extends StatelessWidget {
  const DetailPKLPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
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
          isLoggedIn: isLoggedIn,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: DetailCard(
                  data: dataPKL,
                  onEdit: () {
                    Navigator.pushNamed(context, '/editpkl');
                  },
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text(
                              'Apakah Anda yakin ingin menghapus data siswa ini?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Data siswa berhasil dihapus!',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
