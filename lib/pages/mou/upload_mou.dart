import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:sikermatsu/models/mou.dart';
import 'package:sikermatsu/services/mou_service.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sikermatsu/main_layout.dart';
import 'package:sikermatsu/core/app_state.dart';
import '../../styles/style.dart';
import 'package:path/path.dart' as p;
import 'dart:io' show File;
import 'package:flutter/foundation.dart';

class UploadMoUPage extends StatefulWidget {
  final Mou? mou;
  const UploadMoUPage({super.key, this.mou});

  @override
  State<UploadMoUPage> createState() => _UploadMoUPageState();
}

class _UploadMoUPageState extends State<UploadMoUPage> {
  final _formKey = GlobalKey<FormState>();
  final nomorMou = TextEditingController();
  final nomorMou2 = TextEditingController();
  final nama = TextEditingController();
  final judul = TextEditingController();
  final ruangLingkup = TextEditingController();
  final nama1 = TextEditingController();
  final jabatan1 = TextEditingController();
  final alamat1 = TextEditingController();
  final nama2 = TextEditingController();
  final jabatan2 = TextEditingController();
  final alamat2 = TextEditingController();

  PlatformFile? _pickedPlatformFile;
  DateTime? tanggalMulai;
  DateTime? tanggalBerakhir;
  String? fileName;
  File? selectedFile;
  KeteranganMou _selectedKeterangan = KeteranganMou.diajukan;

  @override
  void initState() {
    if (widget.mou != null) {
      final mou = widget.mou!;
      nomorMou.text = mou.nomorMou;
      nomorMou2.text = mou.nomorMou2;
      nama.text = mou.nama;
      judul.text = mou.judul;
      ruangLingkup.text = mou.ruangLingkup;

      // Set tanggal
      tanggalMulai = mou.tanggalMulai;
      tanggalBerakhir = mou.tanggalBerakhir;

      // Pihak 1 & 2
      nama1.text = mou.pihak1.nama;
      jabatan1.text = mou.pihak1.jabatan;
      alamat1.text = mou.pihak1.alamat;

      nama2.text = mou.pihak2.nama;
      jabatan2.text = mou.pihak2.jabatan;
      alamat2.text = mou.pihak2.alamat;
      fileName = mou.fileMou;
      _selectedKeterangan = widget.mou!.keterangan;
    }
    super.initState();
  }

  @override
  void dispose() {
    nomorMou.dispose();
    nomorMou2.dispose();
    nama.dispose();
    judul.dispose();
    ruangLingkup.dispose();
    nama1.dispose();
    jabatan1.dispose();
    alamat1.dispose();
    nama2.dispose();
    jabatan2.dispose();
    alamat2.dispose();
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
        selectedFile =
            null; // biar clear, kita simpan PlatformFile di variabel lain saja
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
      if (widget.mou == null) {
        // Upload
        final mou = Mou(
          nomorMou: nomorMou.text,
          nomorMou2: nomorMou2.text,
          nama: nama.text,
          judul: judul.text,
          ruangLingkup: ruangLingkup.text,
          tanggalMulai: tanggalMulai!, // Ganti sesuai form
          tanggalBerakhir: tanggalBerakhir!, // Ganti sesuai form
          pihak1: Pihak(
            nama: nama1.text,
            jabatan: jabatan1.text,
            alamat: alamat1.text,
          ),
          pihak2: Pihak(
            nama: nama2.text,
            jabatan: jabatan2.text,
            alamat: alamat2.text,
          ),
          keterangan: KeteranganMou.diajukan,

          // keterangan: widget.mou?.keterangan ?? KeteranganMou.diajukan,
          status: widget.mou?.status,
        );

        await MouService.uploadMou(mou, file: _pickedPlatformFile);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil mengunggah data MoU!')),
        );
      } else {
        // Update
        final mou = Mou(
          nomorMou: nomorMou.text,
          nomorMou2: nomorMou2.text,
          nama: nama.text,
          judul: judul.text,
          ruangLingkup: ruangLingkup.text,
          tanggalMulai: tanggalMulai!,
          tanggalBerakhir: tanggalBerakhir!,
          pihak1: Pihak(
            nama: nama1.text,
            jabatan: jabatan1.text,
            alamat: alamat1.text,
          ),
          pihak2: Pihak(
            nama: nama2.text,
            jabatan: jabatan2.text,
            alamat: alamat2.text,
          ),
          // keterangan: widget.mou!.keterangan,
          keterangan: _selectedKeterangan,

          status: widget.mou!.status,
        );

        await MouService.updateMou(
          widget.mou!.id.toString(),
          mou,
          file: _pickedPlatformFile,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengunggah data MoU: $e')));
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
                        Text('Form Upload MoU', style: CustomStyle.headline1),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: nomorMou,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Nomor MoU',
                          ),

                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: nomorMou2,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Nomor MoU 2',
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
                            labelText: 'Nama',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: judul,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Judul',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: ruangLingkup,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Ruang Lingkup',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
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
                          controller: nama1,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Nama Pihak 1',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: jabatan1,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Jabatan Pihak 1',
                          ),

                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: alamat1,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Alamat Pihak 1',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: nama2,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Nama Pihak 2',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: jabatan2,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Jabatan Pihak 2',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: alamat2,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Alamat Pihak 1',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        if (widget.mou != null) ...[
                          DropdownButtonFormField<KeteranganMou>(
                            value: _selectedKeterangan,
                            decoration: CustomStyle.inputDecorationWithLabel(
                              labelText: 'Keterangan',
                            ),
                            items:
                                KeteranganMou.values.map((keterangan) {
                                  return DropdownMenuItem(
                                    value: keterangan,
                                    child: Text(keterangan.label),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedKeterangan = value;
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
