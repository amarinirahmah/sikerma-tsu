// import 'package:flutter/material.dart';
// import 'package:sikermatsu/services/mou_service.dart';
// import 'package:sikermatsu/widgets/main_layout.dart';
// import 'package:sikermatsu/widgets/table.dart';
// import 'package:sikermatsu/widgets/table2.dart';
// import 'package:sikermatsu/pages/upload_mou.dart';
// import 'package:sikermatsu/models/app_state.dart';
// import 'package:sikermatsu/styles/style.dart';
// import 'package:sikermatsu/models/mou.dart';
// import 'package:sikermatsu/services/mou_service.dart';

// class MoUPage extends StatefulWidget {
//   const MoUPage({super.key});

//   @override
//   State<MoUPage> createState() => _MoUPage();
// }

// class _MoUPage extends State<MoUPage> {
//   List<Map<String, dynamic>> allMou = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//      await Future.delayed(const Duration(seconds: 1));
//     setState(() => _isLoading = true);
//     try {
//       List<Mou> listMou = await MouService.getAllMou();
//       setState(() {
//         allMou =
//             listMou
//                 .map(
//                   (mou) => {
//                     'id': mou.id.toString(),
//                     'Nomor MoU': mou.nomorMou,
//                     'Nama Mitra': mou.nama,
//                     'Judul': mou.judul,
//                     'Tanggal Mulai': mou.tanggalMulai,
//                     'Tanggal Berakhir': mou.tanggalBerakhir,
//                     'Status': mou.status,
//                     'Keterangan': mou.keterangan.name,
//                   },
//                 )
//                 .toList();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Gagal memuat data MoU: $e')));
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   // Future<void> _loadData() async {
//   //   await Future.delayed(const Duration(seconds: 1));
//   //   setState(() {
//   //     allMou = [
//   //       {
//   //         'Nama Mitra': 'PT Maju Jaya',
//   //         'Tanggal Mulai': '2024-01-01',
//   //         'Tanggal Berakhir': '2025-01-01',
//   //         'Status': 'Aktif',
//   //       },
//   //       {
//   //         'Nama Mitra': 'CV Sukses Makmur',
//   //         'Tanggal Mulai': '2023-06-15',
//   //         'Tanggal Berakhir': '2024-06-14',
//   //         'Status': 'Nonaktif',
//   //       },
//   //       {
//   //         'Nama Mitra': 'CV Maju Wijaya',
//   //         'Tanggal Mulai': '2023-09-15',
//   //         'Tanggal Berakhir': '2024-09-15',
//   //         'Status': 'Nonaktif',
//   //       },
//   //     ];
//   //     _isLoading = false;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final List<String> statusOptions =
//         allMou
//             .map((e) => e['Status']?.toString() ?? '')
//             .toSet()
//             .where((e) => e.isNotEmpty)
//             .toList();
//     return ValueListenableBuilder<bool>(
//       valueListenable: AppState.isLoggedIn,
//       builder: (context, isLoggedIn, _) {
//         return MainLayout(
//           title: '',
//           isLoggedIn: isLoggedIn,
//           child:
//               _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : Stack(
//                     children: [
//                       Column(
//                         children: [
//                           // TABLE
//                           Expanded(
//                             child: Center(
//                               child: ConstrainedBox(
//                                 constraints: const BoxConstraints(
//                                   maxWidth: 1000,
//                                 ),
//                                 child: CustomPaginatedTable(
//                                   title: 'Daftar MoU',
//                                   columns: const [
//                                     'Nomor MoU',
//                                     'Nama Mitra',
//                                     'Judul',
//                                     'Tanggal Mulai',
//                                     'Tanggal Berakhir',
//                                     'Status',
//                                     'Keterangan',
//                                   ],
//                                   statusOptions: statusOptions,
//                                   initialStatus: null,

//                                   data: allMou,

//                                   onDetailPressed: (
//                                     BuildContext context,
//                                     Map<String, dynamic> rowData,
//                                   ) {
//                                     Navigator.pushNamed(
//                                       context,
//                                       '/detailmou',
//                                       arguments: rowData['id'].toString(),
//                                     );
//                                   },
// onEditPressed: (isLoggedIn && (AppState.role.value == 'admin' || AppState.role.value == 'user'))
//     ? (BuildContext context, Map<String, dynamic> rowData) {

//         final mou = Mou.fromJson(rowData);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => UploadMoUPage(mou: mou),
//           ),
//         ).then((value) {
//           if (value == true) {
//             _loadData();
//           }
//         });
//       }
//     : null,

//                                   // onEditPressed: (BuildContext context, Map<String, dynamic> rowData) {

//                                   //      Navigator.push(
//                                   //           context,
//                                   //           MaterialPageRoute(
//                                   //             builder: (context) => UploadMoUPage(mou: mou),
//                                   //           ),
//                                   //         ).then((value) {
//                                   //           if (value == true) {
//                                   //             _loadData();
//                                   //           }
//                                   //         });

//                                   // },

//                                    onDeletePressed: (isLoggedIn && (AppState.role.value == 'admin' || AppState.role.value == 'user'))
//     ? (BuildContext context, Map<String, dynamic> rowData) async {
//         final id = rowData['id'].toString();

//         final confirm = await showDialog<bool>(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Konfirmasi'),
//             content: Text('Hapus PKS dengan ID $id?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context, false),
//                 child: const Text('Batal'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context, true),
//                 child: const Text('Hapus'),
//               ),
//             ],
//           ),
//         );
//         if (confirm == true) {
//           try {
//             await MouService.deleteMou(id);
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Berhasil menghapus MoU')),
//             );
//             await _loadData();
//           } catch (e) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Gagal menghapus MoU: $e')),
//             );
//           }
//         }
//       }
//     : null,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       // FAB
//                       if (isLoggedIn && AppState.role.value != 'userpkl')
//                         Positioned(
//                           bottom: 16,
//                           right: 16,
//                           child: FloatingActionButton(
//                             onPressed: () {
//                               Navigator.pushNamed(
//                                 context,
//                                 '/uploadmou',
//                               ).then((_) => _loadData());
//                             },
//                             backgroundColor: Colors.teal,
//                             foregroundColor: Colors.white,
//                             child: const Icon(Icons.add),
//                           ),
//                         ),
//                     ],
//                   ),
//         );
//       },
//     );
//   }
// }

// MoUPage.dart
import 'package:flutter/material.dart';
import 'package:sikermatsu/services/mou_service.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/models/mou.dart';
import 'package:sikermatsu/pages/upload_mou.dart';
import '../styles/style.dart';

class MoUPage extends StatefulWidget {
  const MoUPage({super.key});

  @override
  State<MoUPage> createState() => _MoUPageState();
}

class _MoUPageState extends State<MoUPage> {
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
                selectedStatus == 'Semua' || mou.status == selectedStatus;
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
                                          // decoration:
                                          //     CustomStyle.inputDecoration(
                                          //       prefixIcon: const Icon(
                                          //         Icons.search,
                                          //       ),
                                          //       hintText: 'Cari...',
                                          //     ),
                                          decoration: const InputDecoration(
                                            labelText: 'Cari Nama Mitra',
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
                                            ['Semua', 'Aktif', 'Nonaktif']
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
                                        DataColumn(label: Text('Nomor MoU')),
                                        DataColumn(label: Text('Nama Mitra')),
                                        DataColumn(label: Text('Judul')),
                                        DataColumn(
                                          label: Text('Tanggal Mulai'),
                                        ),
                                        DataColumn(
                                          label: Text('Tanggal Berakhir'),
                                        ),
                                        DataColumn(label: Text('Status')),
                                        DataColumn(label: Text('Keterangan')),
                                        DataColumn(label: Text('Aksi')),
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
                                                    mou.tanggalMulai!
                                                        .toIso8601String()
                                                        .split('T')
                                                        .first,
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    mou.tanggalBerakhir
                                                        .toIso8601String()
                                                        .split('T')
                                                        .first,
                                                  ),
                                                ),
                                                DataCell(Text(mou.statusText)),
                                                DataCell(
                                                  Text(mou.keteranganText),
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
                                                            '/detailmou',
                                                            arguments:
                                                                mou.id
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
