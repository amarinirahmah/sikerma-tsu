import 'package:flutter/material.dart';
import 'package:sikermatsu/main_layout.dart';
import 'package:sikermatsu/core/app_state.dart';
import 'package:sikermatsu/models/mou.dart';
import 'package:sikermatsu/services/mou_service.dart';
import 'package:sikermatsu/helpers/download_file.dart';
import 'package:sikermatsu/styles/style.dart';
import 'package:intl/intl.dart';

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
                            DateFormat(
                              'd MMMM yyyy',
                              'id_ID',
                            ).format(mou!.tanggalMulai),
                          ),
                          buildRow(
                            'Tanggal Berakhir',
                            DateFormat(
                              'd MMMM yyyy',
                              'id_ID',
                            ).format(mou!.tanggalBerakhir),
                          ),
                          buildRow('Ruang Lingkup', mou!.ruangLingkup),

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
