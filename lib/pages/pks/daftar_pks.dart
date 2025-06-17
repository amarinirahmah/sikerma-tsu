import 'package:flutter/material.dart';
import 'package:sikermatsu/services/mou_service.dart';
import 'package:sikermatsu/services/pks_service.dart';
import 'package:sikermatsu/main_layout.dart';
import 'package:sikermatsu/core/app_state.dart';
import 'package:sikermatsu/models/pks.dart';
import 'package:sikermatsu/pages/pks/upload_pks.dart';
import '../../styles/style.dart';

class PKSPage extends StatefulWidget {
  const PKSPage({super.key});

  @override
  State<PKSPage> createState() => _PKSPageState();
}

class _PKSPageState extends State<PKSPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Pks> allPks = [];
  List<Pks> filteredPks = [];
  bool isLoading = true;
  int rowsPerPage = 10;
  int currentPage = 0;
  String searchQuery = '';
  String selectedStatus = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadPks();
  }

  Future<void> _loadPks() async {
    setState(() => isLoading = true);
    try {
      final data = await PksService.getAllPks();
      setState(() {
        allPks = data;
        _applyFilter();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat PKS: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _applyFilter() {
    setState(() {
      filteredPks =
          allPks.where((pks) {
            final matchesSearch = pks.judul.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
            final matchesStatus =
                selectedStatus == 'Semua' || pks.statusText == selectedStatus;
            return matchesSearch && matchesStatus;
          }).toList();
      currentPage = 0;
    });
  }

  // Widget buildHeaderField(String text) {
  //   return Container(
  //     color: Colors.grey[300],
  //     padding: const EdgeInsets.all(8),
  //     child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AppState.isLoggedIn.value;
    final role = AppState.role.value;
    final totalPages = (filteredPks.length / rowsPerPage).ceil();

    final displayedRows =
        filteredPks.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

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
                                    'Daftar PKS',
                                    style: CustomStyle.headline1,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration:
                                              CustomStyle.searchInputDecoration(
                                                labelText: 'Cari Judul PKS',
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
                                            searchQuery = value;
                                            _applyFilter();
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
                                          value: selectedStatus,
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
                                                    (role) => DropdownMenuItem(
                                                      value: role,
                                                      child: Text(role),
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
                                            'Judul',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Nama Unit',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Tanggal Mulai',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Tanggal Berakhir',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),

                                        DataColumn(
                                          label: Text(
                                            'Status',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Keterangan',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        if (isLoggedIn &&
                                            (role == 'admin' || role == 'user'))
                                          DataColumn(
                                            label: Text(
                                              'Aksi',
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                            ),
                                          ),
                                      ],
                                      rows:
                                          displayedRows.map((pks) {
                                            return DataRow(
                                              cells: [
                                                DataCell(Text(pks.nomorMou)),
                                                DataCell(Text(pks.nomorPks)),
                                                DataCell(Text(pks.judul)),
                                                DataCell(Text(pks.namaUnit)),
                                                DataCell(
                                                  Text(
                                                    pks.tanggalMulai!
                                                        .toIso8601String()
                                                        .split('T')
                                                        .first,
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    pks.tanggalBerakhir
                                                        .toIso8601String()
                                                        .split('T')
                                                        .first,
                                                  ),
                                                ),
                                                DataCell(Text(pks.statusText)),
                                                DataCell(
                                                  Text(pks.keteranganText),
                                                ),
                                                if (isLoggedIn &&
                                                    (role == 'admin' ||
                                                        role == 'user'))
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
                                                            Navigator.pushNamed(
                                                              context,
                                                              '/detailpks',
                                                              arguments:
                                                                  pks.id
                                                                      .toString(),
                                                            );
                                                          },
                                                        ),

                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                          tooltip: 'Edit',
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => UploadPKSPage(
                                                                      pks: pks,
                                                                    ),
                                                              ),
                                                            ).then((value) {
                                                              if (value ==
                                                                  true) {
                                                                _loadPks();
                                                              }
                                                            });
                                                          },
                                                        ),

                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                          tooltip: 'Hapus',
                                                          onPressed: () async {
                                                            final confirm = await showDialog<
                                                              bool
                                                            >(
                                                              context: context,
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) => AlertDialog(
                                                                    title: const Text(
                                                                      'Konfirmasi',
                                                                    ),
                                                                    content: Text(
                                                                      'Hapus PKS dengan judul ${pks.judul}?',
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () => Navigator.pop(
                                                                              context,
                                                                              false,
                                                                            ),
                                                                        child: const Text(
                                                                          'Batal',
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () => Navigator.pop(
                                                                              context,
                                                                              true,
                                                                            ),
                                                                        child: const Text(
                                                                          'Hapus',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            );
                                                            if (confirm ==
                                                                true) {
                                                              try {
                                                                await PksService.deletePks(
                                                                  pks.id
                                                                      .toString(),
                                                                );
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                      'Berhasil menghapus PKS',
                                                                    ),
                                                                  ),
                                                                );
                                                                await _loadPks();
                                                              } catch (e) {
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                      'Gagal menghapus PKS: $e',
                                                                    ),
                                                                  ),
                                                                );
                                                              }
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
                  if (isLoggedIn && role != 'userpkl')
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/uploadpks',
                          ).then((_) => _loadPks());
                        },
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        child: const Icon(Icons.add),
                      ),
                    ),
                ],
              ),
    );
  }
}
