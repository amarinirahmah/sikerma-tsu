import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:sikermatsu/models/pks.dart';
import 'package:sikermatsu/services/pks_service.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sikermatsu/main_layout.dart';
import 'package:sikermatsu/core/app_state.dart';
import '../../styles/style.dart';
import 'package:path/path.dart' as p;
import 'dart:io' show File;
import 'package:flutter/foundation.dart';

class UploadPKSPage extends StatefulWidget {
  final Pks? pks;
  const UploadPKSPage({super.key, this.pks});

  @override
  State<UploadPKSPage> createState() => _UploadPKSPageState();
}

class _UploadPKSPageState extends State<UploadPKSPage> {
  final _formKey = GlobalKey<FormState>();
  final nomorMou = TextEditingController();
  final nomorPks = TextEditingController();
  final judul = TextEditingController();
  final namaUnit = TextEditingController();
  final ruangLingkup = TextEditingController();

  PlatformFile? _pickedPlatformFile;
  DateTime? tanggalMulai;
  DateTime? tanggalBerakhir;
  String? fileName;
  File? selectedFile;
  KeteranganPks _selectedKeterangan = KeteranganPks.diajukan;

  @override
  void initState() {
    if (widget.pks != null) {
      final pks = widget.pks!;
      nomorMou.text = pks.nomorMou;
      nomorPks.text = pks.nomorPks;
      judul.text = pks.judul;
      namaUnit.text = pks.namaUnit;
      ruangLingkup.text = pks.ruangLingkup;

      // Set tanggal
      tanggalMulai = pks.tanggalMulai;
      tanggalBerakhir = pks.tanggalBerakhir;

      fileName = pks.filePks;
      _selectedKeterangan = widget.pks!.keterangan;
    }
    super.initState();
  }

  @override
  void dispose() {
    nomorMou.dispose();
    nomorPks.dispose();
    judul.dispose();
    namaUnit.dispose();
    ruangLingkup.dispose();
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
      if (widget.pks == null) {
        // Upload
        final pks = Pks(
          nomorMou: nomorMou.text,
          nomorPks: nomorPks.text,
          judul: judul.text,
          namaUnit: namaUnit.text,
          ruangLingkup: ruangLingkup.text,
          tanggalMulai: tanggalMulai!, // Ganti sesuai form
          tanggalBerakhir: tanggalBerakhir!, // Ganti sesuai form
          // keterangan: widget.pks?.keterangan ?? KeteranganPks.diajukan,
          keterangan: KeteranganPks.diajukan,
          status: widget.pks?.status,
        );

        await PksService.uploadPks(pks, file: _pickedPlatformFile);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil mengunggah data PKS!')),
        );
      } else {
        // Update
        final pks = Pks(
          nomorMou: nomorMou.text,
          nomorPks: nomorPks.text,
          judul: judul.text,
          namaUnit: namaUnit.text,
          ruangLingkup: ruangLingkup.text,
          tanggalMulai: tanggalMulai!,
          tanggalBerakhir: tanggalBerakhir!,
          keterangan: _selectedKeterangan,
          // keterangan: widget.pks!.keterangan,
          status: widget.pks!.status,
        );

        await PksService.updatePks(
          widget.pks!.id.toString(),
          pks,
          file: _pickedPlatformFile,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengunggah data PKS: $e')));
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
                          controller: nomorPks,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Nomor PKS',
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
                          controller: namaUnit,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Nama Unit',
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

                        if (widget.pks != null) ...[
                          DropdownButtonFormField<KeteranganPks>(
                            value: _selectedKeterangan,
                            decoration: CustomStyle.inputDecorationWithLabel(
                              labelText: 'Keterangan',
                            ),
                            items:
                                KeteranganPks.values.map((keterangan) {
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
