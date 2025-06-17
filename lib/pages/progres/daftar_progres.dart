import 'package:flutter/material.dart';
import 'package:sikermatsu/pages/progres/detail_progres.dart';
import 'package:sikermatsu/main_layout.dart';
import 'package:sikermatsu/core/app_state.dart';
import 'package:sikermatsu/services/mou_service.dart';
import 'package:sikermatsu/services/pks_service.dart';
import '../../styles/style.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> filteredData = [];
  bool isLoading = true;

  // Pagination
  int currentPage = 0;
  int rowsPerPage = 10;

  // Filter/search
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String selectedStatus = 'Semua';
  // String selectedJenis = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final mouList = await MouService.getAllMou();
      final pksList = await PksService.getAllPks();

      final List<Map<String, dynamic>> combinedData = [];

      for (final mou in mouList) {
        final relatedPks = pksList.where((pks) => pks.nomorMou == mou.nomorMou);

        if (relatedPks.isEmpty) {
          combinedData.add({
            'Nama Mitra': mou.nama,
            'Nomor MoU': mou.nomorMou,
            'Tanggal Mulai MoU':
                mou.tanggalMulai.toIso8601String().split('T').first,
            'Status MoU': mou.statusText,
            'Nomor PKS': '-',
            'Tanggal Mulai PKS': '-',
            'Status PKS': '-',
            'mouId': mou.id,
            'pksId': null,
          });
        } else {
          for (final pks in relatedPks) {
            combinedData.add({
              'Nama Mitra': mou.nama,
              'Nomor MoU': mou.nomorMou,
              'Tanggal Mulai MoU':
                  mou.tanggalMulai.toIso8601String().split('T').first,
              'Status MoU': mou.statusText,
              'Nomor PKS': pks.nomorPks,
              'Tanggal Mulai PKS':
                  pks.tanggalMulai.toIso8601String().split('T').first,
              'Status PKS': pks.statusText,
              'mouId': mou.id,
              'pksId': pks.id,
            });
          }
        }
      }
      setState(() {
        allData = combinedData;
        filteredData = combinedData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
  }

  void _applyFilter() {
    setState(() {
      filteredData =
          allData.where((data) {
            final statusMatch =
                selectedStatus == 'Semua' ||
                data['Status MoU'] == selectedStatus;
            final nameMatch = data['Nama Mitra']
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
            return statusMatch && nameMatch;
          }).toList();
      currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AppState.isLoggedIn.value;
    final role = AppState.role.value;
    final totalPages = (filteredData.length / rowsPerPage).ceil();

    final displayedRows =
        filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

    return MainLayout(
      title: '',
      isLoggedIn: isLoggedIn,
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),

                        child: SingleChildScrollView(
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Daftar Progres',
                                    style: CustomStyle.headline1,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          decoration:
                                              CustomStyle.searchInputDecoration(
                                                labelText: 'Cari Nama Mitra',
                                                prefixIcon: Icon(
                                                  Icons.search,
                                                  color: Colors.grey,
                                                ),
                                                suffixIcon:
                                                    searchQuery.isNotEmpty
                                                        ? IconButton(
                                                          icon: const Icon(
                                                            Icons.clear,
                                                            color: Colors.grey,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              searchQuery = '';
                                                              _searchController
                                                                  .clear();
                                                              _applyFilter();
                                                            });
                                                          },
                                                        )
                                                        : null,
                                              ),
                                          onChanged: (value) {
                                            setState(() {
                                              searchQuery = value;
                                              _applyFilter();
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        decoration:
                                            CustomStyle.dropdownBoxDecoration(),
                                        child: DropdownButton<String>(
                                          // decoration:
                                          //     CustomStyle.dropdownDecoration(),
                                          value: selectedStatus,
                                          // isDense: true,
                                          underline: const SizedBox(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              selectedStatus = value;
                                              _applyFilter();
                                            }
                                          },
                                          items:
                                              ['Semua', 'Aktif', 'Tidak Aktif']
                                                  .map(
                                                    (status) =>
                                                        DropdownMenuItem(
                                                          value: status,
                                                          child: Text(status),
                                                        ),
                                                  )
                                                  .toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,

                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.all<Color>(
                                            Colors.grey[300]!,
                                          ),
                                      headingTextStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      border: TableBorder.all(
                                        color: Colors.grey,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Text(
                                            'Nomor MoU',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Nomor PKS',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Nama Mitra',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Tanggal Mulai MoU',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Status MoU',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Tanggal Mulai PKS',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Status PKS',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Aksi',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                      ],
                                      rows:
                                          displayedRows.map((data) {
                                            return DataRow(
                                              cells: [
                                                DataCell(
                                                  Text(data['Nomor MoU'] ?? ''),
                                                ),
                                                DataCell(
                                                  Text(data['Nomor PKS'] ?? ''),
                                                ),
                                                DataCell(
                                                  Text(
                                                    data['Nama Mitra'] ?? '',
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    data['Tanggal Mulai MoU'] ??
                                                        '',
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    data['Status MoU'] ?? '',
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    data['Tanggal Mulai PKS'] ??
                                                        '',
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    data['Status PKS'] ?? '',
                                                  ),
                                                ),
                                                DataCell(
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.info,
                                                          color: Colors.teal,
                                                        ),
                                                        tooltip: 'Detail',
                                                        onPressed: () {
                                                          final int? mouId =
                                                              data['mouId'];

                                                          if (mouId != null) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => DetailProgressPage(
                                                                      mouId:
                                                                          mouId,
                                                                    ),
                                                              ),
                                                            ).then((value) {
                                                              if (value ==
                                                                  true) {
                                                                _loadData();
                                                              }
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text('Baris per halaman:'),
                                          const SizedBox(width: 8),
                                          DropdownButton<int>(
                                            value: rowsPerPage,
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(
                                                  () => rowsPerPage = value,
                                                );
                                                _applyFilter();
                                              }
                                            },
                                            items:
                                                [10, 15, 20]
                                                    .map(
                                                      (e) => DropdownMenuItem(
                                                        value: e,
                                                        child: Text('$e'),
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.chevron_left,
                                            ),
                                            onPressed:
                                                currentPage > 0
                                                    ? () => setState(
                                                      () => currentPage--,
                                                    )
                                                    : null,
                                          ),
                                          Text(
                                            '${currentPage + 1} / $totalPages',
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.chevron_right,
                                            ),
                                            onPressed:
                                                currentPage < totalPages - 1
                                                    ? () => setState(
                                                      () => currentPage++,
                                                    )
                                                    : null,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
