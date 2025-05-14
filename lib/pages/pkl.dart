import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/upload_card.dart';
import 'package:sikermatsu/models/app_state.dart';

class UploadPKLPage extends StatefulWidget {
  const UploadPKLPage({super.key});

  @override
  State<UploadPKLPage> createState() => _UploadPKLPage();
}

class _UploadPKLPage extends State<UploadPKLPage> {
  final _formKey = GlobalKey<FormState>();
  final _nisn = TextEditingController();
  final _namaSekolah = TextEditingController();
  final _namaSiswa = TextEditingController();
  final _telpEmail = TextEditingController();
  final _alamat = TextEditingController();
  String _jenisKelamin = 'Laki-laki';
  DateTime? _tanggalMulai;
  DateTime? _tanggalBerakhir;
  String? _fileName;

  void _pickTanggalMulai() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggalMulai = picked;
        _tanggalBerakhir = null;
      });
    }
  }

  void _pickTanggalBerakhir() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalMulai ?? DateTime.now(),
      firstDate: _tanggalMulai ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggalBerakhir = picked;
      });
    }
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _tanggalMulai != null &&
        _tanggalBerakhir != null &&
        _fileName != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data Siswa berhasil diunggah!")),
      );
      _formKey.currentState!.reset();
      setState(() {
        _tanggalMulai = null;
        _tanggalBerakhir = null;
        _fileName = null;
        _jenisKelamin = 'Laki-laki';
      });
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
                    onSubmit: _submitForm,
                    fields: [
                      buildField("NISN", _nisn),
                      buildField("Nama Siswa", _namaSiswa),
                      buildField("Nama Sekolah", _namaSekolah),
                      buildDateRow(
                        "Tanggal Mulai",
                        _tanggalMulai,
                        _pickTanggalMulai,
                      ),
                      buildDateRow(
                        "Tanggal Berakhir",
                        _tanggalBerakhir,
                        _pickTanggalBerakhir,
                      ),
                      buildFileRow(),
                      buildField("No Telepon / Email", _telpEmail),
                      buildField("Alamat", _alamat, maxLines: 3),
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
            decoration: const InputDecoration(border: OutlineInputBorder()),
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
            child: Text(
              date == null
                  ? "Pilih Tanggal"
                  : "${date.toLocal()}".split(' ')[0],
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
          child: ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.attach_file),
            label: Text(_fileName ?? "Pilih File PKL"),
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
          child: DropdownButtonFormField<String>(
            value: _jenisKelamin,
            items:
                ['Laki-laki', 'Perempuan']
                    .map((jk) => DropdownMenuItem(value: jk, child: Text(jk)))
                    .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _jenisKelamin = value;
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
