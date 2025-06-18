import 'package:flutter/material.dart';
import 'package:sikermatsu/services/mou_service.dart';
import 'package:sikermatsu/main_layout.dart';
import 'package:sikermatsu/core/app_state.dart';
import 'package:sikermatsu/models/mou.dart';
import 'package:sikermatsu/pages/mou/upload_mou.dart';
import '../../styles/style.dart';
import 'package:intl/intl.dart';

class MoUPage extends StatefulWidget {
  const MoUPage({super.key});

  @override
  State<MoUPage> createState() => _MoUPageState();
}

class _MoUPageState extends State<MoUPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Mou> allMou = [];
  List<Mou> filteredMou = [];
  bool isLoading = true;
  int rowsPerPage = 10;
  int currentPage = 0;
  String searchQuery = '';
  String selectedStatus = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadMou();
  }

  Future<void> _loadMou() async {
    setState(() => isLoading = true);
    try {
      final data = await MouService.getAllMou();
      setState(() {
        allMou = data;
        _applyFilter();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat MoU: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _applyFilter() {
    setState(() {
      filteredMou =
          allMou.where((mou) {
            final matchesSearch = mou.nama.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
            final matchesStatus =
                selectedStatus == 'Semua' || mou.statusText == selectedStatus;
            return matchesSearch && matchesStatus;
          }).toList();
      currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AppState.isLoggedIn.value;
    final role = AppState.role.value;
    final totalPages = (filteredMou.length / rowsPerPage).ceil();

    final displayedRows =
        filteredMou.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

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
                                    'Daftar MoU',
                                    style: CustomStyle.headline1,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
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
                                    // child: ConstrainedBox(
                                    //   constraints: BoxConstraints(
                                    //     minWidth: 1000,
                                    //   ),
                                    //   child: SizedBox(
                                    //     width: double.infinity,
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
                                      //  columnSpacing: 24,
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
                                            'Nama Mitra',
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
                                          displayedRows.map((mou) {
                                            return DataRow(
                                              cells: [
                                                DataCell(Text(mou.nomorMou)),
                                                DataCell(Text(mou.nama)),
                                                DataCell(Text(mou.judul)),
                                                DataCell(
                                                  Text(
                                                    DateFormat(
                                                      'd MMMM yyyy',
                                                      'id_ID',
                                                    ).format(mou.tanggalMulai),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    DateFormat(
                                                      'd MMMM yyyy',
                                                      'id_ID',
                                                    ).format(
                                                      mou.tanggalBerakhir,
                                                    ),
                                                  ),
                                                ),
                                                DataCell(Text(mou.statusText)),
                                                DataCell(
                                                  Text(mou.keteranganText),
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
                                                              '/detailmou',
                                                              arguments:
                                                                  mou.id
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
                                                                    ) => UploadMoUPage(
                                                                      mou: mou,
                                                                    ),
                                                              ),
                                                            ).then((value) {
                                                              if (value ==
                                                                  true) {
                                                                _loadMou();
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
                                                                      'Hapus MoU dengan judul ${mou.judul}?',
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
                                                                await MouService.deleteMou(
                                                                  mou.id
                                                                      .toString(),
                                                                );
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                      'Berhasil menghapus MoU',
                                                                    ),
                                                                  ),
                                                                );
                                                                await _loadMou();
                                                              } catch (e) {
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                      'Gagal menghapus MoU: $e',
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
                                  //   ),
                                  // ),
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
                            '/uploadmou',
                          ).then((_) => _loadMou());
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
