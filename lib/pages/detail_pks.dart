import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/models/pks.dart';
import 'package:sikermatsu/services/pks_service.dart';
import 'package:sikermatsu/services/auth_service.dart';
import 'package:sikermatsu/helpers/download_file.dart';
import 'package:sikermatsu/styles/style.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailPKSPage extends StatefulWidget {
  const DetailPKSPage({super.key});

  @override
  State<DetailPKSPage> createState() => _DetailPKSPageState();
}

class _DetailPKSPageState extends State<DetailPKSPage> {
  late String id;
  Pks? pks;
  bool isLoading = true;
  String? error;

  late KeteranganPks selectedKeterangan;
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
      final result = await PksService().getPksById(id);
      setState(() {
        pks = result;
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
    if (pks == null) return;

    setState(() {
      isSaving = true;
    });

    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(
        'http://192.168.18.248:8000/api/getpksid/${pks!.id}',
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
          pks = Pks.fromJson(jsonDecode(response.body));
          selectedKeterangan = pks!.keterangan;
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
      return buildRow('Keterangan', pks!.keteranganText);
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
          DropdownButton<KeteranganPks>(
            value: selectedKeterangan,
            items:
                KeteranganPks.values.map((k) {
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
      title: 'Detail PKS',
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
                          Text('Detail PKS', style: CustomStyle.headline1),
                          const SizedBox(height: 20),
                          buildRow('Nomor MoU', pks!.nomorMou),
                          buildRow('Nomor PKS', pks!.nomorPks),
                          buildRow('Judul Kerja Sama', pks!.judul),
                          buildRow(
                            'Tanggal Mulai',
                            pks!.tanggalMulai.toLocal().toString().split(
                              ' ',
                            )[0],
                          ),
                          buildRow(
                            'Tanggal Berakhir',
                            pks!.tanggalBerakhir.toLocal().toString().split(
                              ' ',
                            )[0],
                          ),
                          buildRow('Nama Unit', pks!.namaUnit),
                          buildRow('Ruang Lingkup', pks!.ruangLingkup),
                          // buildRow('Keterangan', pks!.keteranganText),
                          buildKeteranganRow(),
                          buildRow('Status', pks!.statusText),

                          // buildRow(
                          //   'Keterangan',
                          //   pks!.keterangan.toString() ?? '-',
                          // ),
                          // buildRow('Status', pks!.status.toString() ?? '-'),
                          buildRow('File', pks!.filePks ?? 'Tidak ada file'),
                          if (pks!.filePks != null &&
                              isLoggedIn &&
                              (userRole == 'admin' || userRole == 'user'))
                            ElevatedButton.icon(
                              icon: const Icon(Icons.download),
                              style: CustomStyle.baseButtonStyle,
                              label: const Text('Download File'),
                              onPressed: () async {
                                final token = await AuthService.getToken();
                                final url =
                                    'http://192.168.18.248:8000/storage/${pks!.filePks}';
                                await downloadFile(
                                  url,
                                  'pks-${pks!.nomorPks}',
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
