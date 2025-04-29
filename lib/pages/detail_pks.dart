import 'package:flutter/material.dart';

class DetailPKSPage extends StatelessWidget {
  const DetailPKSPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk detail PKS
    final Map<String, dynamic> pksDetail = {
      'nomorMou': 'MOU-001',
      'nomorPks': 'PKS-001',
      'judulKerjaSama': 'Kerja Sama Teknologi',
      'tanggalMulai': '2024-01-01',
      'tanggalBerakhir': '2025-01-01',
      'namaUnit': 'Unit Teknologi Informasi',
      'file': 'dokumen_pks_001.pdf',
      'tujuan': 'Meningkatkan kolaborasi dalam teknologi bersama.',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail PKS'),
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800), // Lebar maksimum
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nomor MoU: ${pksDetail['nomorMou']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nomor PKS: ${pksDetail['nomorPks']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Judul Kerja Sama: ${pksDetail['judulKerjaSama']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tanggal Mulai: ${pksDetail['tanggalMulai']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tanggal Berakhir: ${pksDetail['tanggalBerakhir']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nama Unit: ${pksDetail['namaUnit']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'File: ${pksDetail['file']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tujuan: ${pksDetail['tujuan']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Aksi untuk edit data
                        Navigator.pushNamed(context, '/editpks');
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
                                'Apakah Anda yakin ingin menghapus PKS ini?',
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
                                    // Hapus PKS (tambah logika hapus di sini)
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("PKS berhasil dihapus!"),
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
                        backgroundColor: Colors.red, // Warna tombol Hapus
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
