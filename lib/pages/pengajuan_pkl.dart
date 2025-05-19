import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'upload_pkl.dart';
import 'package:sikermatsu/models/app_state.dart';
import '../styles/style.dart';

class PKLPage extends StatefulWidget {
  const PKLPage({super.key});

  @override
  State<PKLPage> createState() => _PKLPageState();
}

class _PKLPageState extends State<PKLPage> {
  List<Map<String, dynamic>> _dataPKL = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _dataPKL = [
        {
          'NISN': '1234567890',
          'Nama Siswa': 'Andi',
          'Tanggal Mulai': '2025-07-01',
          'Tanggal Berakhir': '2025-09-30',
          'Status': 'Disetujui',
        },
        {
          'NISN': '9876543210',
          'Nama Siswa': 'Budi',
          'Tanggal Mulai': '2025-08-01',
          'Tanggal Berakhir': '2025-10-31',
          'Status': 'Diproses',
        },
        {
          'NISN': '1122334455',
          'Nama Siswa': 'Dina',
          'Tanggal Mulai': '2025-09-01',
          'Tanggal Berakhir': '2025-11-30',
          'Status': 'Ditolak',
        },
      ];
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredData {
    return _dataPKL.where((item) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          item['Nama Siswa'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
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
                          // SEARCH BAR
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1000,
                                ),
                                child: TextField(
                                  decoration: CustomStyle.inputDecoration(
                                    hintText: 'Cari Nama Siswa',
                                    prefixIcon: const Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),

                          // TABLE
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1000,
                                ),
                                child: TableData(
                                  title: 'Daftar Pengajuan PKL',
                                  columns: const [
                                    'NISN',
                                    'Nama Siswa',
                                    'Tanggal Mulai',
                                    'Tanggal Berakhir',
                                    'Status',
                                  ],
                                  data: _filteredData,
                                  actionLabel: 'Detail',
                                  onActionPressed: (
                                    BuildContext context,
                                    Map<String, dynamic> rowData,
                                  ) {
                                    Navigator.pushNamed(context, '/detailpkl');
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
