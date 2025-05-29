import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/upload_card.dart';
import 'package:sikermatsu/models/app_state.dart';

import '../styles/style.dart';
import 'package:sikermatsu/services/pks_service.dart';
import 'package:sikermatsu/models/pks.dart';

class UpdatePKSPage extends StatefulWidget {
  const UpdatePKSPage({super.key});

  @override
  State<UpdatePKSPage> createState() => _UpdatePKSPageState();
}

class _UpdatePKSPageState extends State<UpdatePKSPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nomorMou;
  late TextEditingController nomorPks;
  late TextEditingController judul;
  late TextEditingController ruangLingkup;
    late TextEditingController namaUnit;

  DateTime? tanggalMulai;
  DateTime? tanggalBerakhir;
  String? fileName;
  PlatformFile? _pickedPlatformFile;

  Pks? pks;
  bool _initialized = false;

  @override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (!_initialized) {
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null && args is Map<String, dynamic>) {
    // final Map<String, dynamic> rowData = args;
    //   final Mou mou = Mou.fromMap(rowData);
      // pks = Pks.fromMap(args);
        pks = Pks.fromJson(args);

      nomorMou = TextEditingController(text: pks!.nomorMou);
      nomorPks = TextEditingController(text: pks!.nomorPks);
      judul = TextEditingController(text: pks!.judul);
      ruangLingkup = TextEditingController(text: pks!.ruangLingkup);
namaUnit = TextEditingController(text: pks!.namaUnit);
      tanggalMulai = pks!.tanggalMulai;
      tanggalBerakhir = pks!.tanggalBerakhir;
    } else {
        pks = null;
      nomorMou = TextEditingController();
      nomorPks = TextEditingController();
      judul = TextEditingController();
      ruangLingkup = TextEditingController();
       tanggalMulai = DateTime.now();
      tanggalBerakhir = DateTime.now();
    }

    _initialized = true;
    setState(() {});
  }
}


  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   if (!_initialized) {
  //     final args = ModalRoute.of(context)!.settings.arguments;
  //     if (args is Mou) {
  //       mou = args;

  //       nomorMou = TextEditingController(text: mou!.nomorMou);
  //       nomorMou2 = TextEditingController(text: mou!.nomorMou2);
  //       nama = TextEditingController(text: mou!.nama);
  //       judul = TextEditingController(text: mou!.judul);
  //       ruangLingkup = TextEditingController(text: mou!.ruangLingkup);

  //       nama1 = TextEditingController(text: mou!.pihak1.nama);
  //       jabatan1 = TextEditingController(text: mou!.pihak1.jabatan);
  //       alamat1 = TextEditingController(text: mou!.pihak1.alamat);

  //       nama2 = TextEditingController(text: mou!.pihak2.nama);
  //       jabatan2 = TextEditingController(text: mou!.pihak2.jabatan);
  //       alamat2 = TextEditingController(text: mou!.pihak2.alamat);

  //       tanggalMulai = mou!.tanggalMulai;
  //       tanggalBerakhir = mou!.tanggalBerakhir;

  //       _initialized = true;
  //       setState(() {});
  //     } else {
  //       // Jika args tidak Mou, inisialisasi controller kosong agar tidak error
  //       nomorMou = TextEditingController();
  //       nomorMou2 = TextEditingController();
  //       nama = TextEditingController();
  //       judul = TextEditingController();
  //       ruangLingkup = TextEditingController();
  //       nama1 = TextEditingController();
  //       jabatan1 = TextEditingController();
  //       alamat1 = TextEditingController();
  //       nama2 = TextEditingController();
  //       jabatan2 = TextEditingController();
  //       alamat2 = TextEditingController();
  //     }
  //   }
  // }

  @override
  void dispose() {
    nomorMou.dispose();
    nomorPks.dispose();
    judul.dispose();
    ruangLingkup.dispose();
    super.dispose();
  }

  void _pickTanggalMulai() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalMulai ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        tanggalMulai = picked;
        if (tanggalBerakhir != null && tanggalBerakhir!.isBefore(picked)) {
          tanggalBerakhir = null;
        }
      });
    }
  }

  void _pickTanggalBerakhir() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalBerakhir ?? tanggalMulai ?? DateTime.now(),
      firstDate: tanggalMulai ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        tanggalBerakhir = picked;
      });
    }
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final fileSizeInKB = (file.bytes?.lengthInBytes ?? 0) ~/ 1024;

      if (fileSizeInKB > 5120) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ukuran file melebihi 5MB!")),
        );
        return;
      }

      setState(() {
        fileName = file.name;
        _pickedPlatformFile = file;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada file yang dipilih.")),
      );
    }
  }

 Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap lengkapi semua data!")),
      );
      return;
    }
 

    if (pks == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data PKS tidak ditemukan!")),
      );
      return;
    }

  
    final updatedPks = Pks(
      id: pks!.id,
      nomorMou: nomorMou.text,
      nomorPks: nomorPks.text,
      judul: judul.text,
      tanggalMulai: tanggalMulai!,
      tanggalBerakhir: tanggalBerakhir!,
       namaUnit: namaUnit.text,
      ruangLingkup: ruangLingkup.text,
      keterangan: pks!.keterangan,
    );

    try {
      await PksService().updatePks(
        updatedPks.id.toString(),
        updatedPks,
        file: _pickedPlatformFile,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data PKS berhasil diperbarui!")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui MoU: $e")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        return MainLayout(
          title: "",
          isLoggedIn: isLoggedIn,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Form(
                  key: _formKey,
                  child: UploadCard(
                    title: "Form Edit MoU",
                    onSubmit: _submitForm,
                    fields: [
                      buildField("Nomor MoU", nomorMou),
                      buildField("Nomor MoU 2", nomorPks),
                      buildField("Judul Kerja Sama", judul),
                      buildDateRow("Tanggal Mulai", tanggalMulai, _pickTanggalMulai),
                      buildDateRow("Tanggal Berakhir", tanggalBerakhir, _pickTanggalBerakhir),
                      buildField("Ruang Lingkup", ruangLingkup, maxLines: 3),
                      buildFileRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Row(
      crossAxisAlignment:
          maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        SizedBox(width: 130, child: Text(label)),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: CustomStyle.inputDecoration(),
            maxLines: maxLines,
            validator: (value) => value!.isEmpty ? "$label wajib diisi" : null,
          ),
        ),
      ],
    );
  }

  Widget buildDateRow(String label, DateTime? date, VoidCallback onTap) {
    return Row(
      children: [
        SizedBox(width: 130, child: Text(label)),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: onTap,
            style: CustomStyle.outlinedButtonStyle,
            child: Text(
              date == null ? "Pilih Tanggal" : "${date.toLocal()}".split(' ')[0],
              style: CustomStyle.dateTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFileRow() {
    return Row(
      children: [
        const SizedBox(width: 130, child: Text("Upload File (opsional)")),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.attach_file),
            label: Text(fileName ?? "Pilih File MoU"),
            style: CustomStyle.outlinedButtonStyle,
          ),
        ),
      ],
    );
  }
}