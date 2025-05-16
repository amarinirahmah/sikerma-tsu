import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/upload_card.dart';
import 'package:sikermatsu/models/app_state.dart';
import '../styles/style.dart';

class UploadMoUPage extends StatefulWidget {
  const UploadMoUPage({super.key});

  @override
  State<UploadMoUPage> createState() => _UploadMoUPageState();
}

class _UploadMoUPageState extends State<UploadMoUPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomorController = TextEditingController();
  final _mitraController = TextEditingController();
  final _judulController = TextEditingController();
  final _tujuanController = TextEditingController();

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
        const SnackBar(content: Text("Data MoU berhasil diunggah!")),
      );
      _formKey.currentState!.reset();
      setState(() {
        _tanggalMulai = null;
        _tanggalBerakhir = null;
        _fileName = null;
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
                    title: "Form Upload MoU",
                    onSubmit: _submitForm,
                    fields: [
                      buildField("Nomor MoU", _nomorController),
                      buildField("Nama Mitra", _mitraController),
                      buildField("Judul Kerja Sama", _judulController),
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
                      buildField("Tujuan", _tujuanController, maxLines: 3),
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
            label: Text(_fileName ?? "Pilih File MoU"),
            style: CustomStyle.getButtonStyleByLabel('Pilih File MoU'),
          ),
        ),
      ],
    );
  }
}
