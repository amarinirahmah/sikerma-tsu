import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/detail_card.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/models/pkl.dart';
import 'package:sikermatsu/services/pkl_service.dart';
import 'package:sikermatsu/services/auth_service.dart';

class DetailPKLPage extends StatefulWidget {
  const DetailPKLPage({super.key});

  @override
  _DetailPKLPageState createState() => _DetailPKLPageState();
}

class _DetailPKLPageState extends State<DetailPKLPage> {
  String currentStatus = 'Diproses'; // default status
  late String id;
  Pkl? pkl;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    getDetailPkl(); // panggil saat awal
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      id = args;
      getDetailPkl();
    } else {
      // Kalau argumen id tidak valid, kembali ke halaman sebelumnya
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }
  }

  Future<void> getDetailPkl() async {
    try {
      final result = await PklService.getPklById(id);

      setState(() {
        pkl = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  // Future<void> deletePkl() async {
  //   try {
  //     await PklService().deletePkl(id);

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Data siswa PKL berhasil dihapus!')),
  //       );
  //       Navigator.pop(context); // kembali ke halaman sebelumnya
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Gagal menghapus data siswa PKL: $e')),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final role = AppState.role.value; // ambil role

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
                        'NISN': pkl!.nisn,
                        'Nama Siswa': pkl!.nama,
                        'Nama Sekolah': pkl!.sekolah,
                        'Jenis Kelamin': pkl!.gender,
                        'Tanggal Mulai': pkl!.tanggalMulai,
                        'Tanggal Berakhir': pkl!.tanggalBerakhir,
                        'File PKL': pkl!.filePkl,
                        'Nomor Telepon / Email': pkl!.telpemail,
                        'Alamat': pkl!.alamat,
                      },
                      role: AppState.role.value,
                      onEdit: () {
                        Navigator.pushNamed(
                          context,
                          '/uploadpkl',
                          arguments: pkl,
                        );
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                  'Yakin hapus data siswa ini?',
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
                                      // deletePkl();
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
