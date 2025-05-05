import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<Map<String, dynamic>> _allData = [];
  String _selectedJenis = 'Semua';
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
      _allData = [
        {
          'Jenis': 'MoU',
          'Nama Mitra': 'PT Maju Jaya',
          'Tanggal Mulai': '2024-01-01',
          'Tanggal Berakhir': '2025-01-01',
          'Status': 'Aktif',
        },
        {
          'Jenis': 'PKS',
          'Nama Mitra': 'CV Sukses Makmur',
          'Tanggal Mulai': '2023-06-15',
          'Tanggal Berakhir': '2024-06-14',
          'Status': 'Nonaktif',
        },
        {
          'Jenis': 'MoU',
          'Nama Mitra': 'Universitas A',
          'Tanggal Mulai': '2022-03-01',
          'Tanggal Berakhir': '2023-03-01',
          'Status': 'Nonaktif',
        },
        {
          'Jenis': 'PKS',
          'Nama Mitra': 'PT Teknologi Hebat',
          'Tanggal Mulai': '2024-02-01',
          'Tanggal Berakhir': '2026-02-01',
          'Status': 'Aktif',
        },
      ];
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredData {
    return _allData.where((item) {
      final matchesJenis =
          _selectedJenis == 'Semua' || item['Jenis'] == _selectedJenis;
      final matchesSearch =
          _searchQuery.isEmpty ||
          item['Nama Mitra'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          item['Status'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesJenis && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final columns = [
      'Jenis',
      'Nama Mitra',
      'Tanggal Mulai',
      'Tanggal Berakhir',
      'Status',
    ];

    return MainLayout(
      title: 'Daftar MoU & PKS',
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // FILTER UI
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        DropdownButton<String>(
                          value: _selectedJenis,
                          items:
                              ['Semua', 'MoU', 'PKS']
                                  .map(
                                    (jenis) => DropdownMenuItem(
                                      value: jenis,
                                      child: Text(jenis),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedJenis = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Cari Nama Mitra / Status',
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // TABLE DATA
                  Expanded(
                    child: TableData(
                      title: 'Daftar Kerja Sama',
                      columns: columns,
                      data: _filteredData,
                      actionLabel: 'Detail',
                      onActionPressed: (context, rowData) {
                        Navigator.pushNamed(context, '/detailprogres');
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
