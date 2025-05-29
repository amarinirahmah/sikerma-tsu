import 'package:flutter/material.dart';
import 'package:sikermatsu/services/mou_service.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/widgets/table2.dart';
import 'package:sikermatsu/pages/upload_mou.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/styles/style.dart';
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
     await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = true);
    try {
      List<Mou> listMou = await MouService.getAllMou();
      setState(() {
        allMou =
            listMou
                .map(
                  (mou) => {
                    'id': mou.id.toString(),
                    'Nomor MoU': mou.nomorMou,
                    'Nama Mitra': mou.nama,
                    'Judul': mou.judul,
                    'Tanggal Mulai': mou.tanggalMulai,
                    'Tanggal Berakhir': mou.tanggalBerakhir,
                    'Status': mou.status,
                    'Keterangan': mou.keterangan.name,
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
                          // TABLE
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
onEditPressed: (isLoggedIn && (AppState.role.value == 'admin' || AppState.role.value == 'user'))
    ? (BuildContext context, Map<String, dynamic> rowData) {
      
        final mou = Mou.fromJson(rowData);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadMoUPage(mou: mou),
          ),
        ).then((value) {
          if (value == true) {
            _loadData();
          }
        });
      }
    : null,

                                  // onEditPressed: (BuildContext context, Map<String, dynamic> rowData) {

                                  //      Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //             builder: (context) => UploadMoUPage(mou: mou),
                                  //           ),
                                  //         ).then((value) {
                                  //           if (value == true) {
                                  //             _loadData();
                                  //           }
                                  //         });
                                        

                                  // },

                                   onDeletePressed: (isLoggedIn && (AppState.role.value == 'admin' || AppState.role.value == 'user'))
    ? (BuildContext context, Map<String, dynamic> rowData) async {
        final id = rowData['id'].toString();

        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: Text('Hapus PKS dengan ID $id?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        );
        if (confirm == true) {
          try {
            await MouService.deleteMou(id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berhasil menghapus MoU')),
            );
            await _loadData();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal menghapus MoU: $e')),
            );
          }
        }
      }
    : null,
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
