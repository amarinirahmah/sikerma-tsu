import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/app_drawer.dart';
import 'package:file_picker/file_picker.dart';

class PKSPage extends StatefulWidget {
  const PKSPage({super.key});

  @override
  State<PKSPage> createState() => _PKSPageState();
}

class _PKSPageState extends State<PKSPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomorPKSController = TextEditingController();
  final TextEditingController _nomorMoUController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _namaUnitController = TextEditingController();
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data PKS berhasil diunggah!")),
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
    return Scaffold(
      appBar: AppBar(title: const Text("Data Kerja Sama PKS")),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomorPKSController,
                    decoration: const InputDecoration(
                      labelText: "Nomor PKS",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty ? "Nomor PKS wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomorMoUController,
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
                    controller: _namaUnitController,
                    decoration: const InputDecoration(
                      labelText: "Nama Unit",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty ? "Nama unit wajib diisi" : null,
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
                    label: Text(_fileName ?? "Upload File PKS"),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Upload Data PKS"),
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
