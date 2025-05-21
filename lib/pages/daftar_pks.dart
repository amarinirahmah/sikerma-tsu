import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/pages/upload_pks.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/styles/style.dart';

class PKSPage extends StatefulWidget {
  const PKSPage({super.key});

  @override
  State<PKSPage> createState() => _PKSPage();
}

class _PKSPage extends State<PKSPage> {
  List<Map<String, dynamic>> allPKS = [];
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
      allPKS = [
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
          'Nama Mitra': 'CV Maju Wijaya',
          'Tanggal Mulai': '2023-09-15',
          'Tanggal Berakhir': '2024-09-15',
          'Status': 'Nonaktif',
        },
      ];
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredData {
    if (_searchQuery.isEmpty) return allPKS;
    return allPKS.where((item) {
      return item['Nama Mitra'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
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
                                  title: 'Daftar PKS',
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
                                    Navigator.pushNamed(context, '/detailpks');
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
