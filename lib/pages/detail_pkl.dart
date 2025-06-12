import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/models/pkl.dart';
import 'package:sikermatsu/services/pkl_service.dart';
import 'package:sikermatsu/services/auth_service.dart';
import 'package:sikermatsu/helpers/download_file.dart';
import 'package:sikermatsu/styles/style.dart';

class DetailPKLPage extends StatefulWidget {
  const DetailPKLPage({super.key});

  @override
  State<DetailPKLPage> createState() => _DetailPKLPageState();
}

class _DetailPKLPageState extends State<DetailPKLPage> {
  late String id;
  Pkl? pkl;
  bool isLoading = true;
  String? error;
  StatusPkl? selectedStatus;
  bool isSaving = false;

  final isLoggedIn = AppState.isLoggedIn.value;
  final role = AppState.role.value;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      id = args;
      getDetailPkl();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }
  }

  Future<void> getDetailPkl() async {
    try {
      final result = await PklService().getPklById(id);
      setState(() {
        pkl = result;
        selectedStatus = result.status;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
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
      title: 'Detail PKL',
      isLoggedIn: isLoggedIn,
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
                          Text('Detail PKL', style: CustomStyle.headline1),
                          const SizedBox(height: 20),
                          buildRow('NISN', pkl!.nisn),
                          buildRow('Nama Siswa', pkl!.nama),
                          buildRow('Asal Sekolah', pkl!.sekolah),
                          buildRow('Jenis Kelamin', pkl!.gender.toBackend()),
                          buildRow(
                            'Tanggal Mulai',
                            pkl!.tanggalMulai.toLocal().toString().split(
                              ' ',
                            )[0],
                          ),
                          buildRow(
                            'Tanggal Berakhir',
                            pkl!.tanggalBerakhir.toLocal().toString().split(
                              ' ',
                            )[0],
                          ),
                          buildRow('Nomor Telepon / Email', pkl!.telpEmail),
                          buildRow('Alamat', pkl!.alamat),
                          buildRow('Status', pkl!.statusText),

                          // buildRow(
                          //   'Status',
                          //   pkl!.status?.toBackend() ?? 'Diproses',
                          // ),
                          buildRow(
                            'File PKL',
                            pkl!.filePkl ?? 'Tidak ada file',
                          ),
                          if (pkl!.filePkl != null)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.download),
                              style: CustomStyle.baseButtonStyle,
                              label: const Text('Download File'),
                              onPressed: () async {
                                await downloadFile(
                                  'pkl_files',
                                  '${pkl!.filePkl}',
                                );
                              },
                              // onPressed: () async {
                              //   try {
                              //     await downloadFile(
                              //       pkl!.filePkl!,
                              //       'pkl-${pkl!.nisn}',
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
