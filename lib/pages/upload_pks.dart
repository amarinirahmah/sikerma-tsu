import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/upload_card.dart';
import 'package:sikermatsu/models/app_state.dart';
import '../styles/style.dart';

import 'dart:io';
import 'package:path/path.dart' as p;
import '../models/pks.dart';
import '../services/auth_service.dart';
import '../services/pks_service.dart';

class UploadPKSPage extends StatefulWidget {
  const UploadPKSPage({super.key});

  @override
  State<UploadPKSPage> createState() => _UploadPKSPageState();
}

class _UploadPKSPageState extends State<UploadPKSPage> {
  final _formKey = GlobalKey<FormState>();
  final nomorMou = TextEditingController();
  final nomorPks = TextEditingController();
  final judul = TextEditingController();
  final namaUnit = TextEditingController();
  final tujuan = TextEditingController();

  DateTime? tanggalMulai;
  DateTime? tanggalBerakhir;
  String? fileName;
  File? selectedFile;
  Pks? pksArgument;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null && args is Pks) {
        setState(() {
          pksArgument = args;
          nomorMou.text = args.nomorMou;
          nomorPks.text = args.nomorPks;
          judul.text = args.judul;
          tujuan.text = args.tujuan;
          namaUnit.text = args.namaUnit;
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
        fileName = result.files.single.name;
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() &&
        tanggalMulai != null &&
        tanggalBerakhir != null &&
        selectedFile != null) {
      // atau boleh file null kalau mau

      final pks = Pks(
        nomorMou: nomorMou.text,
        nomorPks: nomorPks.text,
        judul: judul.text,
        tanggalMulai: tanggalMulai!,
        tanggalBerakhir: tanggalBerakhir!,
        namaUnit: namaUnit.text,
        tujuan: tujuan.text,
        keterangan: KeteranganPks.diajukan,
      );

      try {
        if (pksArgument != null) {
          await PksService().updatePks(
            pksArgument!.id!.toString(),
            pks,
            file: selectedFile,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data PKS berhasil diperbarui!")),
          );
        } else {
          await PksService().uploadPks(pks, file: selectedFile);
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
                    title: "Form Upload PKS",
                    onSubmit: _submitForm,
                    fields: [
                      buildField("Nomor MoU", nomorMou),
                      buildField("Nomor PKS", nomorPks),
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
                      buildField("Nama Mitra", namaUnit),
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
            style: CustomStyle.outlinedButtonStyle,
            onPressed: onTap,
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
            label: Text(fileName ?? "Pilih File PKS"),
            style: CustomStyle.outlinedButtonStyle,
          ),
        ),
      ],
    );
  }
}
