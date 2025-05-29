import 'package:flutter/material.dart';
import 'package:sikermatsu/pages/update_pkl.dart';
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
                     'Status': pkl.status,
                  },
                )
                .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data siswa: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
      final List<String> statusOptions =
        dataPKL
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
                                  title: 'Daftar Pengajuan PKL',
                                  columns: const [
                                    'NISN',
                                    'Nama Siswa',
                                    'Nama Sekolah',
                                    'Tanggal Mulai',
                                    'Tanggal Berakhir',
                                    'Status',
                                  ],
                                  data: dataPKL,
                                   statusOptions: statusOptions,
                                  initialStatus: null,

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
                               onEditPressed: (context, rowData) {
  final pkl = Pkl(
    id: int.tryParse(rowData['id'].toString()),
    nisn: rowData['NISN'] ?? '',
    nama: rowData['Nama Siswa'] ?? '',
    gender: rowData['Jenis Kelamin']?? '', 
    sekolah: rowData['Nama Sekolah'] ?? '',
    tanggalMulai: rowData['Tanggal Mulai'],
    tanggalBerakhir: rowData['Tanggal Berakhir'],
    telpemail: rowData['No. Telepon / Email'] ?? '',
    alamat: rowData['Alamat'] ?? '',
    status: rowData['Status'] ?? '',
    // Tambahkan properti lain jika diperlukan
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => UpdatePKLPage(
        id: pkl.id.toString(),
        existingPkl: pkl,
      ),
    ),
  );
},




                                    onDeletePressed: (isLoggedIn && (AppState.role.value == 'admin' || AppState.role.value == 'user'))
    ? (BuildContext context, Map<String, dynamic> rowData) async {
        final id = rowData['id'].toString();

        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: Text('Hapus data siswa dengan ID $id?'),
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
            await PklService.deletePkl(id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berhasil menghapus data siswa')),
            );
            await _loadData();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal menghapus data siswa: $e')),
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
