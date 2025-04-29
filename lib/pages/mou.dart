import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/app_drawer.dart';
import 'package:file_picker/file_picker.dart';

class UploadMoUPage extends StatefulWidget {
  const UploadMoUPage({super.key});

  @override
  State<UploadMoUPage> createState() => _MoUPageState();
}

class _MoUPageState extends State<UploadMoUPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _mitraController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _tujuanController = TextEditingController();

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
      // Simpan atau proses data di sini
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data MoU berhasil diunggah!")),
      );

      // Reset form jika perlu
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
    return Scaffold(
      appBar: AppBar(title: const Text("Data Kerja Sama MoU")),
      drawer: const AppDrawer(), // Memanggil AppDrawer di sini
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600), // Lebar maksimum form
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomorController,
                    decoration: const InputDecoration(
                      labelText: "Nomor MoU",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty ? "Nomor MoU wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mitraController,
                    decoration: const InputDecoration(
                      labelText: "Nama Mitra",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty ? "Nama mitra wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _judulController,
                    decoration: const InputDecoration(
                      labelText: "Judul Kerja Sama",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? "Judul kerja sama wajib diisi"
                                : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _pickTanggalMulai,
                          child: Text(
                            _tanggalMulai == null
                                ? "Pilih Tanggal Mulai"
                                : "Mulai: ${_tanggalMulai!.toLocal()}".split(
                                  ' ',
                                )[0],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _pickTanggalBerakhir,
                          child: Text(
                            _tanggalBerakhir == null
                                ? "Pilih Tanggal Berakhir"
                                : "Berakhir: ${_tanggalBerakhir!.toLocal()}"
                                    .split(' ')[0],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _tujuanController,
                    decoration: const InputDecoration(
                      labelText: "Tujuan",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator:
                        (value) => value!.isEmpty ? "Tujuan wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: Text(_fileName ?? "Upload File MoU"),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Upload Data MoU"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
