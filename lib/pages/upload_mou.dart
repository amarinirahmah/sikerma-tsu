import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/upload_card.dart';
import 'package:sikermatsu/models/app_state.dart';
import '../styles/style.dart';

import 'dart:io';
import 'package:sikermatsu/services/mou_service.dart';
import 'package:sikermatsu/models/mou.dart';
import 'package:path/path.dart' as p;

class UploadMoUPage extends StatefulWidget {
  const UploadMoUPage({super.key});

  @override
  State<UploadMoUPage> createState() => _UploadMoUPageState();
}

class _UploadMoUPageState extends State<UploadMoUPage> {
  final _formKey = GlobalKey<FormState>();
  final nomorMou = TextEditingController();
  final nama = TextEditingController();
  final judul = TextEditingController();
  final tujuan = TextEditingController();

  DateTime? tanggalMulai;
  DateTime? tanggalBerakhir;
  String? fileName;
  File? selectedFile;
  Mou? mouArgument;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null && args is Mou) {
        setState(() {
          mouArgument = args;
          nomorMou.text = args.nomorMou;
          nama.text = args.nama;
          judul.text = args.judul;
          tujuan.text = args.tujuan;
          tanggalMulai = args.tanggalMulai;
          tanggalBerakhir = args.tanggalBerakhir;
          fileName = "File lama digunakan";
        });
      }
    });
  }

  void _pickTanggalMulai() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        tanggalMulai = picked;
        tanggalBerakhir = null;
      });
    }
  }

  void _pickTanggalBerakhir() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalMulai ?? DateTime.now(),
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
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        fileName = result.files.single.name;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() &&
        tanggalMulai != null &&
        tanggalBerakhir != null) {
      final mou = Mou(
        nomorMou: nomorMou.text,
        nama: nama.text,
        judul: judul.text,
        tanggalMulai: tanggalMulai!,
        tanggalBerakhir: tanggalBerakhir!,
        tujuan: tujuan.text,
        keterangan: KeteranganMou.diajukan,
      );

      try {
        if (mouArgument != null) {
          await MouService().updateMou(
            mouArgument!.id!.toString(),
            mou,
            file: selectedFile,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data MoU berhasil diperbarui!")),
          );
        } else {
          await MouService().uploadMou(mou, file: selectedFile);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data MoU berhasil diunggah!")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal mengunggah: $e")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap lengkapi semua data!")),
      );
    }
  }

  // void _submitForm() {
  //   if (_formKey.currentState!.validate() &&
  //       tanggalMulai != null &&
  //       tanggalBerakhir != null &&
  //       fileName != null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Data MoU berhasil diunggah!")),
  //     );
  //     _formKey.currentState!.reset();
  //     setState(() {
  //       tanggalMulai = null;
  //       tanggalBerakhir = null;
  //       fileName = null;
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Harap lengkapi semua data!")),
  //     );
  //   }
  // }

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
                    title: "Form Upload MoU",
                    onSubmit: _submitForm,
                    fields: [
                      buildField("Nomor MoU", nomorMou),
                      buildField("Nama Mitra", nama),
                      buildField("Judul Kerja Sama", judul),
                      buildDateRow(
                        "Tanggal Mulai",
                        tanggalMulai,
                        _pickTanggalMulai,
                      ),
                      buildDateRow(
                        "Tanggal Berakhir",
                        tanggalBerakhir,
                        _pickTanggalBerakhir,
                      ),
                      buildField("Tujuan", tujuan, maxLines: 3),
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

  Widget buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
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
              date == null
                  ? "Pilih Tanggal"
                  : "${date.toLocal()}".split(' ')[0],
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
        const SizedBox(width: 130, child: Text("Upload File")),
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
