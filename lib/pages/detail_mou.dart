import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/detail_card.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/models/mou.dart';
import 'package:sikermatsu/services/mou_service.dart';
import 'package:sikermatsu/services/auth_service.dart';
import 'package:sikermatsu/helpers/download_file.dart';
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

  @override
  void initState() {
    super.initState();
    // getDetailMou(); // panggil saat awal
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is String && args.isNotEmpty) {
  id = args;
  getDetailMou();
} else {
  setState(() {
    error = 'ID MoU tidak valid';
    isLoading = false;
  });
}

    // if (args != null && args is String) {
    //   id = args;
    //   getDetailMou();
    // } else {
    //   // Kalau argumen id tidak valid, kembali ke halaman sebelumnya
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.of(context).pop();
    //   });
    // }
  }
Future<void> getDetailMou() async {
  try {
    final allMou = await MouService.getAllMou();

        print('Jumlah MoU: ${allMou.length}');
    allMou.forEach((m) => print('MoU id: ${m.id}, title: ${m.judul}'));

    Mou? foundMou;
    try {
      foundMou = allMou.firstWhere((m) => m.id == id);
    } catch (e) {
      foundMou = null;
    }

    if (foundMou == null) {
      setState(() {
        error = 'MoU tidak ditemukan';
        isLoading = false;
      });
    } else {
      setState(() {
        mou = foundMou;
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      error = 'Terjadi kesalahan: $e';
      isLoading = false;
    });
  }
}
  // Future<void> getDetailMou() async {
  //   try {
  //     final result = await MouService.getMouById(id);

  //     setState(() {
  //       mou = result;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       error = 'Terjadi kesalahan: $e';
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> deleteMou() async {
  //   try {
  //     await MouService().deleteMou(id);

  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text('MoU berhasil dihapus!')));
  //       Navigator.pop(context); // kembali ke halaman sebelumnya
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('Gagal menghapus MoU: $e')));
  //     }
  //   }
  // }

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
                        'Nomor Mou': mou?.nomorMou ?? '-',
    'Nomor Mou 2': mou?.nomorMou2 ?? '-',
    'Nama Mitra': mou?.nama,
    'Judul Kerja Sama': mou?.judul ?? '-',
   'Tanggal Mulai': mou != null ? DateFormat('dd MMM yyyy').format(mou!.tanggalMulai) : '-',
'Tanggal Berakhir': mou != null ? DateFormat('dd MMM yyyy').format(mou!.tanggalBerakhir) : '-',
    'Ruang Lingkup': mou?.ruangLingkup ?? '-',
    'Pihak 1': 
      'Nama   : ${mou!.pihak1.nama}\n'
      'Jabatan: ${mou!.pihak1.jabatan}\n'
      'Alamat : ${mou!.pihak1.alamat}',
    'Pihak 2': 
      'Nama   : ${mou!.pihak2.nama}\n'
      'Jabatan: ${mou!.pihak2.jabatan}\n'
      'Alamat : ${mou!.pihak2.alamat}',
    'Keterangan': mou?.keterangan.name ?? '-',
    'Status': mou?.status?.name ?? '-',
                        
'File MoU': mou?.fileMou != null && mou!.fileMou!.isNotEmpty
    ? 'Tersedia'
    : 'Tidak ada file',

                      },
                      role: AppState.role.value,
                      onEdit: () {
                         if (mou != null) {
                            Navigator.pushNamed(
                              context,
                              '/uploadmou',
                              arguments: mou,
                            ).then((_) => getDetailMou());
                          }
                        // Navigator.pushNamed(
                        //   context,
                        //   '/uploadmou',
                        //   arguments: mou,
                        // );
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text('Yakin hapus MoU ini?'),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // deleteMou();
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
