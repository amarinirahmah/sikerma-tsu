import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/pages/upload_mou.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/styles/style.dart';
import 'package:sikermatsu/widgets/table2.dart';
import 'package:sikermatsu/models/mou.dart';
import 'package:sikermatsu/services/mou_service.dart';

class MoUPage extends StatefulWidget {
  const MoUPage({super.key});

  @override
  State<MoUPage> createState() => _MoUPage();
}

class _MoUPage extends State<MoUPage> {
  List<Map<String, dynamic>> allMou = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      List<Mou> listMou = await MouService.getAllMou();
      setState(() {
        allMou =
            listMou
                .map(
                  (mou) => {
                    'id': mou.id.toString(),
                    'Nomor': mou.nomorMou,
                    'Nama Mitra': mou.nama,
                    'Judul': mou.judul,
                    'Tanggal Mulai': mou.tanggalMulai,
                    'Tanggal Berakhir': mou.tanggalBerakhir,
                    'Status': mou.status,
                    'Keterangan': mou.keterangan,
                  },
                )
                .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data MoU: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Future<void> _loadData() async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   setState(() {
  //     allMou = [
  //       {
  //         'Nama Mitra': 'PT Maju Jaya',
  //         'Tanggal Mulai': '2024-01-01',
  //         'Tanggal Berakhir': '2025-01-01',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'CV Sukses Makmur',
  //         'Tanggal Mulai': '2023-06-15',
  //         'Tanggal Berakhir': '2024-06-14',
  //         'Status': 'Nonaktif',
  //       },
  //       {
  //         'Nama Mitra': 'CV Sukses Makmur',
  //         'Tanggal Mulai': '2023-09-15',
  //         'Tanggal Berakhir': '2025-09-14',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'PT Sentosa Abadi',
  //         'Tanggal Mulai': '2023-03-10',
  //         'Tanggal Berakhir': '2024-03-09',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'PT Global Teknologi',
  //         'Tanggal Mulai': '2022-12-01',
  //         'Tanggal Berakhir': '2023-11-30',
  //         'Status': 'Nonaktif',
  //       },
  //       {
  //         'Nama Mitra': 'CV Cahaya Harapan',
  //         'Tanggal Mulai': '2024-04-05',
  //         'Tanggal Berakhir': '2025-04-04',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'PT Harmoni Sejahtera',
  //         'Tanggal Mulai': '2023-09-20',
  //         'Tanggal Berakhir': '2024-09-19',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'PT Lestari Mandiri',
  //         'Tanggal Mulai': '2023-05-11',
  //         'Tanggal Berakhir': '2024-05-10',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'CV Jaya Abadi',
  //         'Tanggal Mulai': '2022-08-17',
  //         'Tanggal Berakhir': '2023-08-16',
  //         'Status': 'Nonaktif',
  //       },
  //       {
  //         'Nama Mitra': 'PT Prima Utama',
  //         'Tanggal Mulai': '2024-02-28',
  //         'Tanggal Berakhir': '2025-02-27',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'CV Sinar Baru',
  //         'Tanggal Mulai': '2023-07-23',
  //         'Tanggal Berakhir': '2024-07-22',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'PT Mega Indah',
  //         'Tanggal Mulai': '2023-01-15',
  //         'Tanggal Berakhir': '2024-01-14',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'PT Cahaya Timur',
  //         'Tanggal Mulai': '2022-11-30',
  //         'Tanggal Berakhir': '2023-11-29',
  //         'Status': 'Nonaktif',
  //       },
  //       {
  //         'Nama Mitra': 'CV Mandiri Sentosa',
  //         'Tanggal Mulai': '2023-10-01',
  //         'Tanggal Berakhir': '2024-09-30',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'PT Berkah Abadi',
  //         'Tanggal Mulai': '2023-04-18',
  //         'Tanggal Berakhir': '2024-04-17',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'CV Sukses Bersama',
  //         'Tanggal Mulai': '2024-03-22',
  //         'Tanggal Berakhir': '2025-03-21',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'PT Sejahtera Makmur',
  //         'Tanggal Mulai': '2023-06-01',
  //         'Tanggal Berakhir': '2024-05-31',
  //         'Status': 'Nonaktif',
  //       },
  //       {
  //         'Nama Mitra': 'CV Prima Jaya',
  //         'Tanggal Mulai': '2024-05-10',
  //         'Tanggal Berakhir': '2025-05-09',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'PT Sentosa Gemilang',
  //         'Tanggal Mulai': '2023-08-25',
  //         'Tanggal Berakhir': '2024-08-24',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'CV Harapan Baru',
  //         'Tanggal Mulai': '2023-12-05',
  //         'Tanggal Berakhir': '2024-12-04',
  //         'Status': 'Aktif',
  //       },
  //       {
  //         'Nama Mitra': 'PT Mitra Mandiri',
  //         'Tanggal Mulai': '2024-01-20',
  //         'Tanggal Berakhir': '2025-01-19',
  //         'Status': 'Aktif',
  //       },
  //     ];
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final List<String> statusOptions =
        allMou
            .map((e) => e['Status']?.toString() ?? '')
            .toSet()
            .where((e) => e.isNotEmpty)
            .toList();
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        return MainLayout(
          title: '',
          isLoggedIn: isLoggedIn,
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                    children: [
                      Column(
                        children: [
                          // langsung tampilkan tabel tanpa search
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1000,
                                ),
                                child: CustomPaginatedTable(
                                  title: 'Daftar MoU',
                                  columns: const [
                                    'Nomor MoU',
                                    'Nama Mitra',
                                    'Judul',
                                    'Tanggal Mulai',
                                    'Tanggal Berakhir',
                                    'Status',
                                    'Keterangan',
                                  ],
                                  statusOptions: statusOptions,
                                  initialStatus: null,

                                  data: allMou,
                                  onDetailPressed: (
                                    BuildContext context,
                                    Map<String, dynamic> rowData,
                                  ) {
                                    Navigator.pushNamed(
                                      context,
                                      '/detailmou',
                                      arguments: rowData['id'].toString(),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // FAB
                      if (isLoggedIn && AppState.role.value != 'userpkl')
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/uploadmou',
                              ).then((_) => _loadData());
                            },
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.add),
                          ),
                        ),
                    ],
                  ),
        );
      },
    );
  }
}
