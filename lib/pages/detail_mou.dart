import 'package:flutter/material.dart';

class DetailMoUPage extends StatelessWidget {
  const DetailMoUPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk detail MoU
    final Map<String, dynamic> mouDetail = {
      'nomorMou': 'MOU-001',
      'namaMitra': 'PT Maju Jaya',
      'judulKerjaSama': 'Kerja Sama Teknologi',
      'tanggalMulai': '2024-01-01',
      'tanggalBerakhir': '2025-01-01',
      'file': 'dokumen_mou_001.pdf',
      'tujuan': 'Meningkatkan inovasi teknologi bersama.',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail MoU'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Tombol kembali
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          // Membuat konten berada di tengah
          child: ConstrainedBox(
            // Membatasi lebar maksimum
            constraints: const BoxConstraints(maxWidth: 800), // Lebar maksimum
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nomor MoU: ${mouDetail['nomorMou']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nama Mitra: ${mouDetail['namaMitra']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Judul Kerja Sama: ${mouDetail['judulKerjaSama']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tanggal Mulai: ${mouDetail['tanggalMulai']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tanggal Berakhir: ${mouDetail['tanggalBerakhir']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'File: ${mouDetail['file']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tujuan: ${mouDetail['tujuan']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Aksi untuk edit data
                        Navigator.pushNamed(context, '/editmou');
                      },
                      child: const Text('Edit'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Aksi untuk menghapus data
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Konfirmasi'),
                              content: const Text(
                                'Apakah Anda yakin ingin menghapus MoU ini?',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Hapus MoU (tambah logika hapus di sini)
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("MoU berhasil dihapus!"),
                                      ),
                                    );
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Hapus'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors
                                .red, // Ganti 'primary' dengan 'backgroundColor'
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
