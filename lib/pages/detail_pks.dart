import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/detail_card.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/models/pks.dart';
import 'package:sikermatsu/services/pks_service.dart';

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

  @override
  void initState() {
    super.initState();
    getDetailPks();
    // getDetailPks dipanggil setelah id didapat dari arguments
  }

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
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  Future<void> deletePks() async {
    try {
      await PksService().deletePks(id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('PKS berhasil dihapus!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus PKS: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: '',
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
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: DetailCard(
                      data: {
                        'Nomor MoU': pks!.nomorMou,
                        'Nomor PKS': pks!.nomorPks,
                        'Judul Kerja Sama': pks!.judul,
                        'Tanggal Mulai': pks!.tanggalMulai.toString(),
                        'Tanggal Berakhir': pks!.tanggalBerakhir.toString(),
                        'Nama Unit': pks!.namaUnit,
                        'File': pks!.filePks ?? 'Tidak ada file',
                        'Tujuan': pks!.tujuan,
                        'Keterangan': pks!.keterangan ?? '-',
                        'Status': pks!.status ?? '-',
                      },
                      role: AppState.role.value,
                      onEdit: () {
                        Navigator.pushNamed(
                          context,
                          '/uploadpks',
                          arguments: pks,
                        );
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                  'Yakin ingin menghapus PKS ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      deletePks();
                                    },
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ),
                ),
              ),
    );
  }
}
