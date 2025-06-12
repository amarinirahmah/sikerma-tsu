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
      getDetailMou();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }
  }

  Future<void> getDetailMou() async {
    try {
      final result = await MouService().getMouById(id);
      if (!mounted) return;
      setState(() {
        mou = result;
        selectedKeterangan = result.keterangan;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  // Future<void> updateKeterangan(KeteranganMou newKeterangan) async {
  //   if (mou == null) return;

  //   setState(() => isSaving = true);

  //   try {
  //     final updatedMou = await MouService().updateKeterangan(
  //       mou!.id.toString(),
  //       newKeterangan,
  //     );
  //     setState(() {
  //       mou = updatedMou;
  //       selectedKeterangan = updatedMou.keterangan;
  //       isSaving = false;
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Keterangan berhasil diperbarui')),
  //     );
  //   } catch (e) {
  //     setState(() => isSaving = false);
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Error saat update: $e')));
  //   }
  // }

  // Future<void> _showKeteranganDialog() async {
  //   if (!isLoggedIn || !(userRole == 'admin' || userRole == 'user')) return;

  //   final selected = await showDialog<KeteranganMou>(
  //     context: context,
  //     builder: (context) {
  //       return SimpleDialog(
  //         title: const Text('Pilih Keterangan'),
  //         children:
  //             KeteranganMou.values.map((k) {
  //               return SimpleDialogOption(
  //                 onPressed: () => Navigator.pop(context, k),
  //                 child: Text(k.label),
  //               );
  //             }).toList(),
  //       );
  //     },
  //   );

  //   if (selected != null && selected != selectedKeterangan) {
  //     await updateKeterangan(selected);
  //   }
  // }

  Widget buildRow(String label, String value, {VoidCallback? onTap}) {
    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style:
                onTap != null
                    ? const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    )
                    : null,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: content,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: content,
    );
  }

  String _getExtension(String path) {
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex + 1 < path.length) {
      return path.substring(dotIndex + 1).toLowerCase();
    }
    return 'pdf';
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
                          // // buildRow('Keterangan', pks!.keteranganText),
                          // buildRow(
                          //   'Keterangan',
                          //   mou!.keteranganText,
                          //   onTap:
                          //       (isLoggedIn &&
                          //               (userRole == 'admin' ||
                          //                   userRole == 'user'))
                          //           ? _showKeteranganDialog
                          //           : null,
                          // ),
                          buildRow('Keterangan', mou!.keteranganText),
                          buildRow('Status', mou!.statusText),
                          // buildRow(
                          //   'Keterangan',
                          //   pks!.keterangan.toString() ?? '-',
                          // ),
                          // buildRow('Status', pks!.status.toString() ?? '-'),
                          buildRow('File', mou!.fileMou ?? 'Tidak ada file'),
                          // if (mou!.fileMou != null &&
                          //     isLoggedIn &&
                          //     (userRole == 'admin' || userRole == 'user'))
                          // if ((mou!.fileMou?.isNotEmpty ?? false) &&
                          //     isLoggedIn &&
                          //     (userRole == 'admin' || userRole == 'user'))
                          if (mou!.fileMou != null)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.download),
                              style: CustomStyle.baseButtonStyle,
                              label: const Text('Download File'),
                              onPressed: () async {
                                await downloadFile(
                                  'mou_files',
                                  '${mou!.fileMou}',
                                );
                                // final token = await AuthService.getToken();
                                // final url =
                                //     'http://192.168.100.104:8000/api/download/${mou!.fileMou}';
                                // await downloadFile(
                                //   url,
                                //   'mou-${mou!.nomorMou}',
                                //   // token.toString(),
                                // );
                              },
                              // onPressed: () async {
                              //   try {
                              //     final filename =
                              //         mou!.fileMou!.split('/').last;
                              //     final folder = getFolderFromType('mou');

                              //     final fileUrl =
                              //         'http://192.168.100.104:8000/api/download/$folder/$filename';

                              //     await downloadFile(fileUrl, filename);
                              //   } catch (e) {
                              //     print("Gagal mengunduh file: $e");
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(
                              //         content: Text('Gagal mengunduh file'),
                              //       ),
                              //     );
                              //   }
                              // },
                              // onPressed: () async {
                              //   try {
                              //     await downloadFile(
                              //       mou!.fileMou!,
                              //       'mou-${mou!.nomorMou}',
                              //     );
                              //   } catch (e) {
                              //     debugPrint('Download error: $e');
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(
                              //         content: Text('Gagal mengunduh file'),
                              //       ),
                              //     );
                              //   }
                              // },
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
