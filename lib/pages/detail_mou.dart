import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/detail_card.dart';
import 'package:sikermatsu/models/app_state.dart';

class DetailMoUPage extends StatelessWidget {
  const DetailMoUPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        final Map<String, dynamic> mouDetail = {
          'Nomor Mou': 'MOU-001',
          'Nama Mitra': 'PT Maju Jaya',
          'Judul Kerja Sama': 'Kerja Sama Teknologi',
          'Tanggal Mulai': '2024-01-01',
          'Tanggal Berakhir': '2025-01-01',
          'File MoU': 'dokumen_mou_001.pdf',
          'Tujuan': 'Meningkatkan inovasi teknologi bersama.',
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
                  data: mouDetail,
                  onEdit: () {
                    Navigator.pushNamed(context, '/editmou');
                  },
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text(
                              'Apakah Anda yakin ingin menghapus MoU ini?',
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
                                      content: Text('MoU berhasil dihapus!'),
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
