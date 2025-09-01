import 'package:flutter/material.dart';
import 'package:sikermatsu/services/mou_service.dart';
import 'package:sikermatsu/main_layout.dart';
import 'package:sikermatsu/core/app_state.dart';
import 'package:sikermatsu/models/mou.dart';
import 'package:sikermatsu/pages/mou/upload_mou.dart';
import 'package:sikermatsu/pages/progres/detail_progres.dart';
import 'package:sikermatsu/helpers/print_report_mou.dart';
import '../../styles/style.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  final ScrollController _horizontalScrollController = ScrollController();
  DateTime? startDate;
  DateTime? endDate;

  //   final dummyData = List.generate(50, (index) => {
  //   'nomorMou': 'MOU-${index + 1}',
  //   'nama': 'Mitra $index',
  //   'judul': 'Judul MoU yang sangat panjang dan detail nomor $index',
  //   'tanggalMulai': DateTime.now().subtract(Duration(days: index * 10)).toIso8601String(),
  //   'tanggalBerakhir': DateTime.now().add(Duration(days: (index + 1) * 10)).toIso8601String(),
  //   'statusText': 'Aktif',
  // });

  @override
  void initState() {
    super.initState();
    _loadMou();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
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

            bool matchesDate = true;
            if (startDate != null) {
              matchesDate &=
                  mou.tanggalMulai.isAfter(startDate!) ||
                  mou.tanggalMulai.isAtSameMomentAs(startDate!);
            }
            if (endDate != null) {
              matchesDate &=
                  mou.tanggalMulai.isBefore(endDate!) ||
                  mou.tanggalMulai.isAtSameMomentAs(endDate!);
            }
            return matchesSearch && matchesStatus && matchesDate;
          }).toList();
      currentPage = 0;
    });
  }

  void _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        _applyFilter();
      });
    }
  }

  void _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
        _applyFilter();
      });
    }
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
                                  if (isLoggedIn &&
                                      (role == 'admin' || role == 'user')) ...[
                                    const SizedBox(height: 16),
                                    Text(
                                      'Filter berdasarkan periode waktu',
                                      style: CustomStyle.hintText,
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: _pickStartDate,
                                          style:
                                              CustomStyle.outlinedButtonStyle,
                                          icon: const Icon(
                                            Icons.calendar_today,
                                            size: 18,
                                          ),
                                          label: Text(
                                            startDate == null
                                                ? 'Mulai Periode'
                                                : DateFormat(
                                                  'd MMM yyyy',
                                                  'id_ID',
                                                ).format(startDate!),
                                            style: CustomStyle.dateTextStyle,
                                          ),
                                        ),

                                        OutlinedButton.icon(
                                          onPressed: _pickEndDate,
                                          style:
                                              CustomStyle.outlinedButtonStyle,
                                          icon: const Icon(
                                            Icons.calendar_today,
                                            size: 18,
                                          ),
                                          label: Text(
                                            endDate == null
                                                ? 'Akhir Periode'
                                                : DateFormat(
                                                  'd MMM yyyy',
                                                  'id_ID',
                                                ).format(endDate!),
                                            style: CustomStyle.dateTextStyle,
                                          ),
                                        ),

                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.refresh),
                                          label: const Text("Reset"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[200],
                                            foregroundColor: Colors.grey,
                                            elevation: 0,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              startDate = null;
                                              endDate = null;
                                              _applyFilter();
                                            });
                                          },
                                        ),
                                        CetakLaporanMoUButton(
                                          displayedRows:
                                              filteredMou
                                                  .map(
                                                    (mou) => {
                                                      'nomorMou': mou.nomorMou,
                                                      'nama': mou.nama,
                                                      'judul': mou.judul,
                                                      'tanggalMulai':
                                                          mou.tanggalMulai,
                                                      'tanggalBerakhir':
                                                          mou.tanggalBerakhir,
                                                      'statusText':
                                                          mou.statusText,
                                                    },
                                                  )
                                                  .toList(),
                                          judulLaporan:
                                              startDate != null &&
                                                      endDate != null
                                                  ? 'Laporan MoU Periode ${DateFormat('d MMM yyyy', 'id_ID').format(startDate!)} - ${DateFormat('d MMM yyyy', 'id_ID').format(endDate!)}'
                                                  : 'Laporan MoU',

                                          // judulLaporan:
                                          //     'Laporan MoU (${startDate != null && endDate != null ? "${DateFormat('d MMM yyyy', 'id_ID').format(startDate!)} - ${DateFormat('d MMM yyyy', 'id_ID').format(endDate!)}" : "Semua"})',
                                        ),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 16),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration:
                                              CustomStyle.searchInputDecoration(
                                                labelText: 'Cari nama mitra...',
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
                                              [
                                                    'Semua',
                                                    'Draft',
                                                    'Aktif',
                                                    'Tidak Aktif',
                                                    'Kadaluarsa',
                                                  ]
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
                                  Scrollbar(
                                    controller: _horizontalScrollController,
                                    thumbVisibility: true,
                                    trackVisibility: true,
                                    interactive: true,
                                    thickness: 4,
                                    scrollbarOrientation:
                                        ScrollbarOrientation.bottom,
                                    child: SingleChildScrollView(
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
                                        columnSpacing: 12,
                                        dataRowMinHeight: 40,
                                        dataRowMaxHeight: 60,
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
                                          if (isLoggedIn &&
                                              (role == 'admin' ||
                                                  role == 'user'))
                                            DataColumn(
                                              label: Text(
                                                'Keterangan',
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                              ),
                                            ),
                                          if (isLoggedIn &&
                                              (role == 'admin' ||
                                                  role == 'user'))
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
                                                  DataCell(
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                        mou.nomorMou,
                                                        maxLines: 3,
                                                        style:
                                                            CustomStyle
                                                                .bodyText2,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: 140,
                                                      child: Text(
                                                        mou.nama,
                                                        maxLines: 3,
                                                        style:
                                                            CustomStyle
                                                                .bodyText2,
                                                        // overflow:
                                                        //     TextOverflow
                                                        //         .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: 250,
                                                      child: Text(
                                                        mou.judul,
                                                        maxLines: 3,
                                                        style:
                                                            CustomStyle
                                                                .bodyText2,
                                                        // overflow:
                                                        //     TextOverflow
                                                        //         .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                        style:
                                                            CustomStyle
                                                                .bodyText2,
                                                        DateFormat(
                                                          'd MMMM yyyy',
                                                          'id_ID',
                                                        ).format(
                                                          mou.tanggalMulai,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                        style:
                                                            CustomStyle
                                                                .bodyText2,
                                                        DateFormat(
                                                          'd MMMM yyyy',
                                                          'id_ID',
                                                        ).format(
                                                          mou.tanggalBerakhir,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                        style:
                                                            CustomStyle
                                                                .bodyText2,
                                                        mou.statusText,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  if (isLoggedIn &&
                                                      (role == 'admin' ||
                                                          role == 'user'))
                                                    DataCell(
                                                      InkWell(
                                                        onTap: () {
                                                          if (mou.id != null) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      _,
                                                                    ) => DetailProgressPage(
                                                                      mouId:
                                                                          mou.id!,
                                                                    ),
                                                              ),
                                                            );
                                                          } else {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                  'ID MoU tidak tersedia',
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: Text(
                                                          mou.keteranganText,
                                                          style: const TextStyle(
                                                            color: Colors.blue,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                  // DataCell(
                                                  //   Text(mou.keteranganText),
                                                  // ),
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
                                                              color:
                                                                  Colors.teal,
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

                                                          // IconButton(
                                                          //   icon: const Icon(
                                                          //     Icons.track_changes,
                                                          //     color: Colors.blue,
                                                          //   ),
                                                          //   tooltip:
                                                          //       'Detail Progres',
                                                          //   onPressed: () {
                                                          //     Navigator.push(
                                                          //       context,
                                                          //       MaterialPageRoute(
                                                          //         builder:
                                                          //             (
                                                          //               _,
                                                          //             ) => DetailProgressPage(
                                                          //               mouId:
                                                          //                   mou.id!,
                                                          //             ),
                                                          //       ),
                                                          //     );
                                                          //   },
                                                          // ),
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
                                                                        mou:
                                                                            mou,
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
                                                                context:
                                                                    context,
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
