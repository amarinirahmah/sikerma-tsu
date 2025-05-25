import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'upload_pkl.dart';
import 'package:sikermatsu/models/app_state.dart';
import '../styles/style.dart';
import 'package:sikermatsu/widgets/table2.dart';
import 'package:sikermatsu/models/pkl.dart';
import 'package:sikermatsu/services/pkl_service.dart';

class PKLPage extends StatefulWidget {
  const PKLPage({super.key});

  @override
  State<PKLPage> createState() => _PKLPageState();
}

class _PKLPageState extends State<PKLPage> {
  List<Map<String, dynamic>> dataPKL = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = true);

    try {
      List<Pkl> listPKL = await PklService.getAllPkl();
      setState(() {
        dataPKL =
            listPKL
                .map(
                  (pkl) => {
                    'id': pkl.id.toString(),
                    'NISN': pkl.nisn,
                    'Nama Siswa': pkl.nama,
                    'Nama Sekolah': pkl.sekolah,
                    'Tanggal Mulai': pkl.tanggalMulai,
                    'Tanggal Berakhir': pkl.tanggalBerakhir,
                  },
                )
                .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data PKL: $e')));
    } finally {
      setState(() => _isLoading = false);
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
                                  title: 'Daftar Pengajuan PKL',
                                  columns: const [
                                    'NISN',
                                    'Nama Siswa',
                                    'Nama Sekolah',
                                    'Tanggal Mulai',
                                    'Tanggal Berakhir',
                                  ],
                                  data: dataPKL,
                                  onDetailPressed: (
                                    BuildContext context,
                                    Map<String, dynamic> rowData,
                                  ) {
                                    Navigator.pushNamed(
                                      context,
                                      '/detailpkl',
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
                      if (isLoggedIn)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/uploadpkl',
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
