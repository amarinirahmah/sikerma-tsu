import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/models/mou.dart';
import 'package:sikermatsu/services/mou_service.dart';
import 'package:sikermatsu/services/auth_service.dart';
import 'package:sikermatsu/helpers/download_file.dart';
import 'package:sikermatsu/styles/style.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailMoUPage extends StatefulWidget {
  const DetailMoUPage({super.key});

  @override
  State<DetailMoUPage> createState() => _DetailMoUPageState();
}

class _DetailMoUPageState extends State<DetailMoUPage> {
  late String id;
  Mou? mou;
  bool isLoading = true;
  String? error;

  late KeteranganMou selectedKeterangan;
  bool isSaving = false;
  final isLoggedIn = AppState.isLoggedIn.value;
  final userRole = AppState.role.value;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      id = args;
      getDetailPks();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }
  }

  Future<void> getDetailPks() async {
    try {
      final result = await MouService().getMouById(id);
      setState(() {
        mou = result;
        selectedKeterangan = result.keterangan;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  Future<void> updateKeterangan() async {
    if (mou == null) return;

    setState(() {
      isSaving = true;
    });

    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(
        'http://192.168.18.248:8000/api/getmouid/${mou!.id}',
      );

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'keterangan': selectedKeterangan.name}),
      );

      if (response.statusCode == 200) {
        setState(() {
          mou = Mou.fromJson(jsonDecode(response.body));
          selectedKeterangan = mou!.keterangan;
          isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Keterangan berhasil diperbarui')),
        );
      } else {
        setState(() {
          isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saat update: $e')));
    }
  }

  Widget buildKeteranganRow() {
    final canEdit = isLoggedIn && (userRole == 'admin' || userRole == 'user');

    if (!canEdit) {
      return buildRow('Keterangan', mou!.keteranganText);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Keterangan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          DropdownButton<KeteranganMou>(
            value: selectedKeterangan,
            items:
                KeteranganMou.values.map((k) {
                  final label = k.name[0].toUpperCase() + k.name.substring(1);
                  return DropdownMenuItem(value: k, child: Text(label));
                }).toList(),
            onChanged:
                isSaving
                    ? null
                    : (newVal) {
                      setState(() {
                        selectedKeterangan = newVal!;
                      });
                    },
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon:
                isSaving
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.save),
            label: const Text('Simpan'),
            onPressed: isSaving ? null : updateKeterangan,
          ),
        ],
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Detail MoU',
      isLoggedIn: AppState.isLoggedIn.value,
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text(error!))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 1.5,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Detail MoU', style: CustomStyle.headline1),
                          const SizedBox(height: 20),
                          buildRow('Nomor MoU', mou!.nomorMou),
                          buildRow('Nomor MoU Pihak 2', mou!.nomorMou2),
                          buildRow('Nama Mitra', mou!.nama),
                          buildRow('Judul Kerja Sama', mou!.judul),
                          buildRow('Nama Pihak 1', mou!.pihak1.nama),
                          buildRow('Jabatan Pihak 1', mou!.pihak1.jabatan),
                          buildRow('Alamat Pihak 1', mou!.pihak1.alamat),

                          buildRow('Nama Pihak 2', mou!.pihak2.nama),
                          buildRow('Jabatan Pihak 2', mou!.pihak2.jabatan),
                          buildRow('Alamat Pihak 2', mou!.pihak2.alamat),

                          buildRow(
                            'Tanggal Mulai',
                            mou!.tanggalMulai.toLocal().toString().split(
                              ' ',
                            )[0],
                          ),
                          buildRow(
                            'Tanggal Berakhir',
                            mou!.tanggalBerakhir.toLocal().toString().split(
                              ' ',
                            )[0],
                          ),
                          buildRow('Ruang Lingkup', mou!.ruangLingkup),
                          // buildRow('Keterangan', pks!.keteranganText),
                          buildKeteranganRow(),
                          buildRow('Status', mou!.statusText),

                          // buildRow(
                          //   'Keterangan',
                          //   pks!.keterangan.toString() ?? '-',
                          // ),
                          // buildRow('Status', pks!.status.toString() ?? '-'),
                          buildRow('File', mou!.fileMou ?? 'Tidak ada file'),
                          if (mou!.fileMou != null &&
                              isLoggedIn &&
                              (userRole == 'admin' || userRole == 'user'))
                            ElevatedButton.icon(
                              icon: const Icon(Icons.download),
                              style: CustomStyle.baseButtonStyle,
                              label: const Text('Download File'),
                              onPressed: () async {
                                final token = await AuthService.getToken();
                                final url =
                                    'http://192.168.18.248:8000/storage/${mou!.fileMou}';
                                await downloadFile(
                                  url,
                                  'mou-${mou!.nomorMou}',
                                  token.toString(),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:sikermatsu/widgets/main_layout.dart';
// import 'package:sikermatsu/widgets/detail_card.dart';
// import 'package:sikermatsu/models/app_state.dart';
// import 'package:sikermatsu/models/mou.dart';
// import 'package:sikermatsu/services/mou_service.dart';
// import 'package:sikermatsu/services/auth_service.dart';
// import 'package:sikermatsu/helpers/download_file.dart';
// import 'package:intl/intl.dart';

// class DetailMoUPage extends StatefulWidget {
//   const DetailMoUPage({super.key});

//   @override
//   State<DetailMoUPage> createState() => _DetailMoUPageState();
// }

// class _DetailMoUPageState extends State<DetailMoUPage> {
//   late String id;
//   Mou? mou;
//   bool isLoading = true;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     // getDetailMou(); // panggil saat awal
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     final args = ModalRoute.of(context)?.settings.arguments;

//     if (args is String && args.isNotEmpty) {
//   id = args;
//   getDetailMou();
// } else {
//   setState(() {
//     error = 'ID MoU tidak valid';
//     isLoading = false;
//   });
// }

//     // if (args != null && args is String) {
//     //   id = args;
//     //   getDetailMou();
//     // } else {
//     //   // Kalau argumen id tidak valid, kembali ke halaman sebelumnya
//     //   WidgetsBinding.instance.addPostFrameCallback((_) {
//     //     Navigator.of(context).pop();
//     //   });
//     // }
//   }
// Future<void> getDetailMou() async {
//   try {
//     final allMou = await MouService.getAllMou();

//         print('Jumlah MoU: ${allMou.length}');
//     allMou.forEach((m) => print('MoU id: ${m.id}, title: ${m.judul}'));

//     Mou? foundMou;
//     try {
//       foundMou = allMou.firstWhere((m) => m.id == id);
//     } catch (e) {
//       foundMou = null;
//     }

//     if (foundMou == null) {
//       setState(() {
//         error = 'MoU tidak ditemukan';
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         mou = foundMou;
//         isLoading = false;
//       });
//     }
//   } catch (e) {
//     setState(() {
//       error = 'Terjadi kesalahan: $e';
//       isLoading = false;
//     });
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return MainLayout(
//       title: '',
//       isLoggedIn: AppState.isLoggedIn.value,
//       child:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : error != null
//               ? Center(child: Text(error!))
//               : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Center(
//                   child: ConstrainedBox(
//                     constraints: const BoxConstraints(maxWidth: 1000),
//                     child: DetailCard(
//                       data: {
//                         'Nomor Mou': mou?.nomorMou ?? '-',
//     'Nomor Mou 2': mou?.nomorMou2 ?? '-',
//     'Nama Mitra': mou?.nama,
//     'Judul Kerja Sama': mou?.judul ?? '-',
//    'Tanggal Mulai': mou != null ? DateFormat('dd MMM yyyy').format(mou!.tanggalMulai) : '-',
// 'Tanggal Berakhir': mou != null ? DateFormat('dd MMM yyyy').format(mou!.tanggalBerakhir) : '-',
//     'Ruang Lingkup': mou?.ruangLingkup ?? '-',
//     'Pihak 1': 
//       'Nama   : ${mou!.pihak1.nama}\n'
//       'Jabatan: ${mou!.pihak1.jabatan}\n'
//       'Alamat : ${mou!.pihak1.alamat}',
//     'Pihak 2': 
//       'Nama   : ${mou!.pihak2.nama}\n'
//       'Jabatan: ${mou!.pihak2.jabatan}\n'
//       'Alamat : ${mou!.pihak2.alamat}',
//     'Keterangan': mou?.keterangan.name ?? '-',
//     'Status': mou?.status?.name ?? '-',
                        
// 'File MoU': mou?.fileMou != null && mou!.fileMou!.isNotEmpty
//     ? 'Tersedia'
//     : 'Tidak ada file',

//                       },
//                       role: AppState.role.value,
//                       onEdit: () {
//                          if (mou != null) {
//                             Navigator.pushNamed(
//                               context,
//                               '/uploadmou',
//                               arguments: mou,
//                             ).then((_) => getDetailMou());
//                           }
//                         // Navigator.pushNamed(
//                         //   context,
//                         //   '/uploadmou',
//                         //   arguments: mou,
//                         // );
//                       },
//                       onDelete: () {
//                         showDialog(
//                           context: context,
//                           builder:
//                               (context) => AlertDialog(
//                                 title: const Text('Konfirmasi'),
//                                 content: const Text('Yakin hapus MoU ini?'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed:
//                                         () => Navigator.of(context).pop(),
//                                     child: const Text('Batal'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                       // deleteMou();
//                                     },
//                                     child: const Text('Hapus'),
//                                   ),
//                                 ],
//                               ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//     );
//   }
// }
