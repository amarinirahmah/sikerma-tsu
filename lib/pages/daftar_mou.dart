import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/pages/upload_mou.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/styles/style.dart';
import 'package:sikermatsu/widgets/table2.dart';

class MoUPage extends StatefulWidget {
  const MoUPage({super.key});

  @override
  State<MoUPage> createState() => _MoUPage();
}

class _MoUPage extends State<MoUPage> {
  List<Map<String, dynamic>> allMou = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      allMou = [
        {
          'Nama Mitra': 'PT Maju Jaya',
          'Tanggal Mulai': '2024-01-01',
          'Tanggal Berakhir': '2025-01-01',
          'Status': 'Aktif',
        },
        {
          'Nama Mitra': 'CV Sukses Makmur',
          'Tanggal Mulai': '2023-06-15',
          'Tanggal Berakhir': '2024-06-14',
          'Status': 'Nonaktif',
        },
        {
          'Nama Mitra': 'PT Maju Jaya',
          'Tanggal Mulai': '2024-01-01',
          'Tanggal Berakhir': '2025-01-01',
          'Status': 'Aktif',
        },
        {
          'Nama Mitra': 'CV Sukses Makmur',
          'Tanggal Mulai': '2023-06-15',
          'Tanggal Berakhir': '2024-06-14',
          'Status': 'Nonaktif',
        },
        {
          'Nama Mitra': 'PT Maju Jaya',
          'Tanggal Mulai': '2024-01-01',
          'Tanggal Berakhir': '2025-01-01',
          'Status': 'Aktif',
        },
        {
          'Nama Mitra': 'CV Sukses Makmur',
          'Tanggal Mulai': '2023-06-15',
          'Tanggal Berakhir': '2024-06-14',
          'Status': 'Nonaktif',
        },
        {
          'Nama Mitra': 'PT Maju Jaya',
          'Tanggal Mulai': '2024-01-01',
          'Tanggal Berakhir': '2025-01-01',
          'Status': 'Aktif',
        },
        {
          'Nama Mitra': 'CV Sukses Makmur',
          'Tanggal Mulai': '2023-06-15',
          'Tanggal Berakhir': '2024-06-14',
          'Status': 'Nonaktif',
        },
      ];
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredData {
    return allMou.where((item) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          item['Nama Mitra'].toLowerCase().contains(_searchQuery.toLowerCase());
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
                                    hintText: 'Cari Nama Mitra',
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon:
                                        _searchQuery.isNotEmpty
                                            ? IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                setState(() {
                                                  _searchQuery = '';
                                                });
                                              },
                                            )
                                            : null,
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
                                child: CustomPaginatedTable(
                                  title: 'Daftar MoU',
                                  columns: const [
                                    'Nama Mitra',
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
                                    Navigator.pushNamed(context, '/detailmou');
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
