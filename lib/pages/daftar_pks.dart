import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/widgets/table2.dart';
import 'package:sikermatsu/pages/upload_pks.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/styles/style.dart';
import 'package:sikermatsu/models/pks.dart';
import 'package:sikermatsu/services/pks_service.dart';

class PKSPage extends StatefulWidget {
  const PKSPage({super.key});

  @override
  State<PKSPage> createState() => _PKSPage();
}

class _PKSPage extends State<PKSPage> {
  List<Map<String, dynamic>> allPKS = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      List<Pks> listPks = await PksService.getAllPks();
      setState(() {
        allPKS =
            listPks
                .map(
                  (pks) => {
                    'id': pks.id.toString(),
                    'Nomor MoU': pks.nomorMou,
                    'Nomor PKS': pks.nomorPks,
                    'Judul': pks.judul,
                    'Tanggal Mulai': pks.tanggalMulai,
                    'Tanggal Berakhir': pks.tanggalBerakhir,
                    'Nama Unit': pks.namaUnit,
                    'Tujuan': pks.tujuan,
                    'Status': pks.status,
                    'Keterangan': pks.keterangan,
                  },
                )
                .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data PKS: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Future<void> _loadData() async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   setState(() {
  //     allPKS = [
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
  //         'Nama Mitra': 'CV Maju Wijaya',
  //         'Tanggal Mulai': '2023-09-15',
  //         'Tanggal Berakhir': '2024-09-15',
  //         'Status': 'Nonaktif',
  //       },
  //     ];
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final List<String> statusOptions =
        allPKS
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
                          // TABLE
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1000,
                                ),
                                child: CustomPaginatedTable(
                                  title: 'Daftar PKS',
                                  columns: const [
                                    'Nomor MoU',
                                    'Nomor PKS',
                                    'Judul',
                                    'Tanggal Mulai',
                                    'Tanggal Berakhir',
                                    'Status',
                                    'Keterangan',
                                  ],
                                  statusOptions: statusOptions,
                                  initialStatus: null,

                                  data: allPKS,

                                  onDetailPressed: (
                                    BuildContext context,
                                    Map<String, dynamic> rowData,
                                  ) {
                                    Navigator.pushNamed(
                                      context,
                                      '/detailpks',
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
                                '/uploadpks',
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
