import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/upload_card.dart';
import 'package:sikermatsu/models/app_state.dart';
import '../styles/style.dart';

import 'dart:io';
import 'package:sikermatsu/services/pkl_service.dart';
import 'package:sikermatsu/models/pkl.dart';
import 'package:path/path.dart' as p;
import 'dart:io' show File;
import 'package:flutter/foundation.dart'; 

class UploadPKLPage extends StatefulWidget {
  const UploadPKLPage({super.key});

  @override
  State<UploadPKLPage> createState() => _UploadPKLPage();
}

class _UploadPKLPage extends State<UploadPKLPage> {
  final _formKey = GlobalKey<FormState>();
  final nisn = TextEditingController();
  final sekolah = TextEditingController();
  final nama = TextEditingController();
  final telpEmail = TextEditingController();
  final alamat = TextEditingController();
  // String gender = 'Laki-laki';
  JenisKelamin gender = JenisKelamin.lakilaki;
  DateTime? tanggalMulai;
  DateTime? tanggalBerakhir;
  String? fileName;
   PlatformFile? _pickedPlatformFile;
    File? selectedFile;


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
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    allowMultiple: false,
    withData: true, // wajib supaya dapat bytes di web
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
      selectedFile = null; // biar clear, kita simpan PlatformFile di variabel lain saja
      _pickedPlatformFile = file; 
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tidak ada file yang dipilih.")),
    );
  }
}

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        tanggalMulai != null &&
        tanggalBerakhir != null) {
      final pkl = Pkl(
        nisn: nisn.text,
        nama: nama.text,
        sekolah: sekolah.text,
        gender: gender,
        telpemail: telpEmail.text,
        alamat: alamat.text,
        tanggalMulai: tanggalMulai!,
        tanggalBerakhir: tanggalBerakhir!,
      );

    try {
        await PklService().uploadPkl(pkl, file: _pickedPlatformFile);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data siswa berhasil diunggah!")),
        );
        await Future.delayed(const Duration(milliseconds: 500));
Navigator.pop(context);
        // _formKey.currentState!.reset();
        // setState(() {
        //   tanggalMulai = null;
        //   tanggalBerakhir = null;
        //   fileName = null;
        //   _pickedPlatformFile = null;
        // });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengunggah: $e")),
        );
      }
    } else {
        print("DEBUG: Validasi gagal:");
  print("NISN: '${nisn.text}'");
  print("Nama: '${nama.text}'");
  print("Sekolah: '${sekolah.text}'");
  print("Gender: '$gender'");
  print("Telp/Email: '${telpEmail.text}'");
  print("Alamat: '${alamat.text}'");
  print("Tanggal Mulai: $tanggalMulai");
  print("Tanggal Berakhir: $tanggalBerakhir");
  print("File: $selectedFile");
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
  //       const SnackBar(content: Text("Data Siswa berhasil diunggah!")),
  //     );
  //     _formKey.currentState!.reset();
  //     setState(() {
  //       tanggalMulai = null;
  //       tanggalBerakhir = null;
  //       fileName = null;
  //       gender = 'Laki-laki';
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
                    title: "Form Pengajuan Siswa PKL",
                    onSubmit: _submitForm,
                    fields: [
                      buildField("NISN", nisn),
                      buildField("Nama Siswa", nama),
                      buildField("Nama Sekolah", sekolah),
                      buildDropdownField("Jenis Kelamin"),
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
                      buildFileRow(),
                      buildField("No Telepon / Email", telpEmail),
                      buildField("Alamat", alamat, maxLines: 3),
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
            label: Text(fileName ?? "Pilih File PKL"),
              //  label: Text(fileName != null ? fileName! : "Pilih File"),
            style: CustomStyle.outlinedButtonStyle,
          ),
        ),
      ],
    );
  }

  Widget buildDropdownField(String label) {
    return Row(
      children: [
        SizedBox(width: 130, child: Text(label)),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<JenisKelamin>(
            value: gender,
          items: JenisKelamin.values.map((jk) {
    return DropdownMenuItem(
      value: jk,
      child: Text(jk.toBackend()),
    );
  }).toList(),
  onChanged: (value) {
    if (value != null) {
      setState(() {
        gender = value;
      });
    }
  },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }
}
