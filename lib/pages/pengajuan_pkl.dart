import 'package:flutter/material.dart';
import 'package:sikermatsu/services/pkl_service.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/models/pkl.dart';
import 'package:sikermatsu/pages/upload_pkl.dart';
import '../styles/style.dart';

class PKLPage extends StatefulWidget {
  const PKLPage({super.key});

  @override
  State<PKLPage> createState() => _PKLPageState();
}

class _PKLPageState extends State<PKLPage> {
  List<Pkl> allPkl = [];
  List<Pkl> filteredPkl = [];
  bool isLoading = true;
  int rowsPerPage = 10;
  int currentPage = 0;
  String searchQuery = '';
  String selectedStatus = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadPkl();
  }

  Future<void> _loadPkl() async {
    setState(() => isLoading = true);
    try {
      final data = await PklService.getAllPkl();
      setState(() {
        allPkl = data;
        _applyFilter();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data siswa: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _applyFilter() {
    setState(() {
      filteredPkl =
          allPkl.where((pkl) {
            final matchesSearch = pkl.nama.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
            final matchesStatus =
                selectedStatus == 'Semua' || pkl.status == selectedStatus;
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
    final totalPages = (filteredPkl.length / rowsPerPage).ceil();

    final displayedRows =
        filteredPkl.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

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
                                    'Daftar Pengajuan Siswa PKL',
                                    style: CustomStyle.headline1,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          // decoration:
                                          //     CustomStyle.inputDecoration(
                                          //       prefixIcon: const Icon(
                                          //         Icons.search,
                                          //       ),
                                          //       hintText: 'Cari...',
                                          //     ),
                                          decoration: const InputDecoration(
                                            labelText: 'Cari Nama Siswa',
                                            border: OutlineInputBorder(),
                                            isDense: true,
                                          ),
                                          onChanged: (value) {
                                            searchQuery = value;
                                            _applyFilter();
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      DropdownButton<String>(
                                        // decoration:
                                        //     CustomStyle.dropdownDecoration(),
                                        value: selectedStatus,
                                        onChanged: (value) {
                                          if (value != null) {
                                            selectedStatus = value;
                                            _applyFilter();
                                          }
                                        },
                                        items:
                                            [
                                                  'Semua',
                                                  'Diproses',
                                                  'Disetujui',
                                                  'Ditolak',
                                                ]
                                                .map(
                                                  (status) => DropdownMenuItem(
                                                    value: status,
                                                    child: Text(status),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      // headingRowColor:
                                      //     MaterialStateProperty.all<Color>(
                                      //       Colors.grey[300]!,
                                      //     ),
                                      // headingTextStyle: const TextStyle(
                                      //   fontWeight: FontWeight.bold,
                                      // ),
                                      border: TableBorder.all(
                                        color: Colors.grey,
                                      ),
                                      columns: [
                                        DataColumn(label: Text('NISN')),
                                        DataColumn(label: Text('Nama Siswa')),
                                        DataColumn(label: Text('Sekolah')),
                                        DataColumn(
                                          label: Text('Tanggal Mulai'),
                                        ),
                                        DataColumn(
                                          label: Text('Tanggal Berakhir'),
                                        ),
                                        DataColumn(label: Text('Status')),
                                        DataColumn(label: Text('Aksi')),
                                      ],
                                      rows:
                                          displayedRows.map((pkl) {
                                            return DataRow(
                                              cells: [
                                                DataCell(Text(pkl.nisn)),
                                                DataCell(Text(pkl.nama)),
                                                DataCell(Text(pkl.sekolah)),
                                                DataCell(
                                                  Text(
                                                    pkl.tanggalMulai!
                                                        .toString(),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    pkl.tanggalBerakhir
                                                        .toString(),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(pkl.status.toString()),
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
                                                          Navigator.pushNamed(
                                                            context,
                                                            '/detailpkl',
                                                            arguments:
                                                                pkl.id
                                                                    .toString(),
                                                          );
                                                        },
                                                      ),
                                                      if (isLoggedIn &&
                                                          (role == 'admin' ||
                                                              role == 'user'))
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
                                                                    ) => UploadPKLPage(
                                                                      pkl: pkl,
                                                                    ),
                                                              ),
                                                            ).then((value) {
                                                              if (value ==
                                                                  true) {
                                                                _loadPkl();
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      if (isLoggedIn &&
                                                          (role == 'admin' ||
                                                              role == 'user'))
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
                                                                      'Hapus data siswa dengan nama ${pkl.nama}?',
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
                                                                await PklService.deletePkl(
                                                                  pkl.id
                                                                      .toString(),
                                                                );
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                      'Berhasil menghapus data siswa',
                                                                    ),
                                                                  ),
                                                                );
                                                                await _loadPkl();
                                                              } catch (e) {
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                      'Gagal menghapus data siswa: $e',
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
                            '/uploadpkl',
                          ).then((_) => _loadPkl());
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
