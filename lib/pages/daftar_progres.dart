import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/models/app_state.dart';
import '../styles/style.dart';
import '../widgets/table2.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<Map<String, dynamic>> allData = [];
  String _selectedJenis = 'Semua';
  // String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      allData = [
        {
          'Jenis': 'MoU',
          'Nama Mitra': 'PT Maju Jaya',
          'Tanggal Mulai': '2024-01-01',
          'Tanggal Berakhir': '2025-01-01',
          'Status': 'Aktif',
          'Keterangan': 'Diajukan',
        },
        {
          'Jenis': 'PKS',
          'Nama Mitra': 'CV Sukses Makmur',
          'Tanggal Mulai': '2023-06-15',
          'Tanggal Berakhir': '2024-06-14',
          'Status': 'Nonaktif',
          'Keterangan': 'Disetujui',
        },
        {
          'Jenis': 'MoU',
          'Nama Mitra': 'Universitas A',
          'Tanggal Mulai': '2022-03-01',
          'Tanggal Berakhir': '2023-03-01',
          'Status': 'Nonaktif',
          'Keterangan': 'Dibatalkan',
        },
        {
          'Jenis': 'PKS',
          'Nama Mitra': 'PT Teknologi Hebat',
          'Tanggal Mulai': '2024-02-01',
          'Tanggal Berakhir': '2026-02-01',
          'Status': 'Aktif',
          'Keterangan': 'Diajukan',
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> statusOptions =
        allData
            .map((e) => e['Status']?.toString() ?? '')
            .toSet()
            .where((e) => e.isNotEmpty)
            .toList();

    final List<String> jenisOptions =
        allData
            .map((e) => e['Jenis']?.toString() ?? '')
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
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1000,
                                ),
                                child: CustomPaginatedTable(
                                  title: 'Daftar Progres',
                                  columns: const [
                                    'Nama Mitra',
                                    'Tanggal Mulai'
                                        'Tanggal Berakhir'
                                        'Status'
                                        'Jenis',
                                  ],
                                  statusOptions: statusOptions,
                                  initialStatus: null,
                                  jenisOptions: jenisOptions,
                                  initialJenis: null,
                                  data: allData,
                                  onDetailPressed: (
                                    BuildContext context,
                                    Map<String, dynamic> rowData,
                                  ) {
                                    Navigator.pushNamed(
                                      context,
                                      '/detailprogres',
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
        );
      },
    );
  }
}
