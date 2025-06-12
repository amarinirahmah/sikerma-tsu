import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:sikermatsu/models/pkl.dart';
import 'package:sikermatsu/services/pkl_service.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/models/app_state.dart';
import '../styles/style.dart';
import 'package:path/path.dart' as p;
import 'dart:io' show File;
import 'package:flutter/foundation.dart';

class UploadPKLPage extends StatefulWidget {
  final Pkl? pkl;
  const UploadPKLPage({super.key, this.pkl});

  @override
  State<UploadPKLPage> createState() => _UploadPKLPageState();
}

class _UploadPKLPageState extends State<UploadPKLPage> {
  final _formKey = GlobalKey<FormState>();
  final nisn = TextEditingController();
  final nama = TextEditingController();
  final sekolah = TextEditingController();
  final telpEmail = TextEditingController();
  final alamat = TextEditingController();

  PlatformFile? _pickedPlatformFile;
  DateTime? tanggalMulai;
  DateTime? tanggalBerakhir;
  String? fileName;
  File? selectedFile;
  JenisKelamin gender = JenisKelamin.lakilaki;
  StatusPkl _selectedStatus = StatusPkl.diproses;

  @override
  void initState() {
    if (widget.pkl != null) {
      final pkl = widget.pkl!;
      nisn.text = pkl.nisn;
      nama.text = pkl.nama;
      sekolah.text = pkl.sekolah;
      telpEmail.text = pkl.telpEmail;
      alamat.text = pkl.alamat;

      // Set tanggal
      tanggalMulai = pkl.tanggalMulai;
      tanggalBerakhir = pkl.tanggalBerakhir;

      fileName = pkl.filePkl;
      _selectedStatus = widget.pkl!.status!;
      // _selectedStatus = widget.pkl!.status;
    }
    super.initState();
  }

  @override
  void dispose() {
    nisn.dispose();
    nama.dispose();
    sekolah.dispose();
    telpEmail.dispose();
    alamat.dispose();
    super.dispose();
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
        selectedFile = null;
        _pickedPlatformFile = file;
      });
    }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Tidak ada file yang dipilih.")),
    //   );
    // }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    if (tanggalMulai == null || tanggalBerakhir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal mulai dan berakhir wajib dipilih.'),
        ),
      );
      return;
    }

    try {
      if (widget.pkl == null) {
        // Upload
        final pkl = Pkl(
          nisn: nisn.text,
          nama: nama.text,
          sekolah: sekolah.text,
          gender: gender,
          tanggalMulai: tanggalMulai!, // Ganti sesuai form
          tanggalBerakhir: tanggalBerakhir!, // Ganti sesuai form
          telpEmail: telpEmail.text,
          alamat: alamat.text,
          // status: StatusPkl.diproses,
          // status: widget.pkl?.status ?? StatusPkl.diproses,
          status: StatusPkl.diproses,
        );

        await PklService.uploadPkl(pkl, file: _pickedPlatformFile);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil mengunggah data siswa!')),
        );
      } else {
        // Update
        final pkl = Pkl(
          nisn: nisn.text,
          nama: nama.text,
          sekolah: sekolah.text,
          gender: gender,
          tanggalMulai: tanggalMulai!,
          tanggalBerakhir: tanggalBerakhir!,
          telpEmail: telpEmail.text,
          alamat: alamat.text,
          // status: widget.pkl!.status,
          status: _selectedStatus,
        );

        print('Data yang dikirim:');
        print(pkl.toJson());
        await PklService.updatePkl(
          widget.pkl!.id.toString(),
          pkl,
          file: _pickedPlatformFile,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah data siswa: $e')),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Form Upload PKS', style: CustomStyle.headline1),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: nisn,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'NISN',
                          ),

                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: nama,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Nama Siswa',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: sekolah,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Asal Sekolah',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<JenisKelamin>(
                          value: gender,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Jenis Kelamin',
                          ),
                          items:
                              JenisKelamin.values.map((jk) {
                                return DropdownMenuItem<JenisKelamin>(
                                  value: jk,
                                  child: Text(jk.toBackend()),
                                );
                              }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                gender = val;
                              });
                            }
                          },
                          validator:
                              (value) => value == null ? 'Wajib dipilih' : null,
                        ),
                        const SizedBox(height: 16),

                        // Tanggal Mulai
                        OutlinedButton.icon(
                          style: CustomStyle.outlinedButtonStyle,
                          icon: const Icon(Icons.date_range),
                          label: Text(
                            tanggalMulai == null
                                ? 'Pilih Tanggal Mulai'
                                : 'Mulai: ${tanggalMulai!.toLocal().toString().split(' ')[0]}',
                            style: CustomStyle.dateTextStyle,
                          ),

                          onPressed: _pickTanggalMulai,
                        ),
                        const SizedBox(height: 8),

                        // Tanggal Berakhir
                        OutlinedButton.icon(
                          style: CustomStyle.outlinedButtonStyle,
                          icon: const Icon(Icons.date_range),
                          label: Text(
                            tanggalBerakhir == null
                                ? 'Pilih Tanggal Berakhir'
                                : 'Berakhir: ${tanggalBerakhir!.toLocal().toString().split(' ')[0]}',
                            style: CustomStyle.dateTextStyle,
                          ),

                          onPressed:
                              tanggalMulai == null
                                  ? null
                                  : _pickTanggalBerakhir,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: telpEmail,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'No. Telepon / Email',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: alamat,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Alamat',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        if (widget.pkl != null) ...[
                          DropdownButtonFormField<StatusPkl>(
                            value: _selectedStatus,
                            decoration: CustomStyle.inputDecorationWithLabel(
                              labelText: 'Status',
                            ),
                            items:
                                StatusPkl.values.map((status) {
                                  return DropdownMenuItem(
                                    value: status,
                                    child: Text(status.toBackend()),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedStatus = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Tombol pilih file
                        OutlinedButton.icon(
                          icon: const Icon(Icons.attach_file),
                          style: CustomStyle.outlinedButtonStyle,
                          label: Text(fileName ?? 'Pilih File'),
                          onPressed: _pickFile,
                        ),
                        const SizedBox(height: 16),

                        // Tombol submit
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: _submitData,
                            style: CustomStyle.baseButtonStyle,
                            // icon: const Icon(Icons.save),
                            label: const Text("Simpan"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
