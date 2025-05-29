import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/upload_card.dart';
import 'package:sikermatsu/models/app_state.dart';

import '../styles/style.dart';
import 'package:sikermatsu/services/pkl_service.dart';
import 'package:sikermatsu/models/pkl.dart';

class UpdatePKLPage extends StatefulWidget {
    final String id;
  final Pkl existingPkl;

  const UpdatePKLPage({super.key, required this.id, required this.existingPkl});

  @override
  State<UpdatePKLPage> createState() => _UpdatePKLPageState();
}

class _UpdatePKLPageState extends State<UpdatePKLPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nisn;
  late TextEditingController sekolah;
  late TextEditingController nama;
  late TextEditingController telpEmail;
    late TextEditingController alamat;
JenisKelamin gender = JenisKelamin.lakilaki;
  DateTime? tanggalMulai;
  DateTime? tanggalBerakhir;
  String? fileName;
  PlatformFile? _pickedPlatformFile;

  @override
void initState() {
  super.initState();

  final pkl = widget.existingPkl;
    nisn = TextEditingController(text: pkl.nisn);
    nama = TextEditingController(text: pkl.nama);
    sekolah = TextEditingController(text: pkl.sekolah);
    telpEmail = TextEditingController(text: pkl.telpemail);
    alamat = TextEditingController(text: pkl.alamat);
    gender = pkl.gender;
    tanggalMulai = pkl.tanggalMulai;
    tanggalBerakhir = pkl.tanggalBerakhir;
}



  // @override
  // void dispose() {
  //   nomorMou.dispose();
  //   nomorPks.dispose();
  //   judul.dispose();
  //   ruangLingkup.dispose();
  //   super.dispose();
  // }

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
    if (_formKey.currentState!.validate() &&
        tanggalMulai != null &&
        tanggalBerakhir != null) {
      final updatedPkl = Pkl(
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
        await PklService().updatePkl(widget.id, updatedPkl, file: _pickedPlatformFile);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data PKL berhasil diperbarui!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui: $e")),
        );
      }
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
                      buildField("NISN", nisn),
                      buildField("Nama", nama),
                      buildField("Sekolah", sekolah),
                        buildDropdownField("Jenis Kelamin"),
                      buildDateRow("Tanggal Mulai", tanggalMulai, _pickTanggalMulai),
                      buildDateRow("Tanggal Berakhir", tanggalBerakhir, _pickTanggalBerakhir),
                        buildField("No. Telp/Email", telpEmail),
                      buildField("Alamat", alamat, maxLines: 3),
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