import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/widgets/upload_card.dart';

class DetailProgressPage extends StatefulWidget {
  const DetailProgressPage({super.key});

  @override
  State<DetailProgressPage> createState() => _DetailProgressPageState();
}

class _DetailProgressPageState extends State<DetailProgressPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final TextEditingController _aktivitasController = TextEditingController();
  final List<Map<String, dynamic>> _progresList = [];

  void _pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _simpanData() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      setState(() {
        _progresList.add({
          'No': (_progresList.length + 1).toString(),
          'Tanggal': "${_selectedDate!.toLocal()}".split(' ')[0],
          'Aktivitas': _aktivitasController.text,
        });
        _selectedDate = null;
        _aktivitasController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data progres berhasil disimpan!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap lengkapi semua data!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Detail Progres",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: UploadCard(
                    fields: [
                      OutlinedButton(
                        onPressed: _pickTanggal,
                        child: Text(
                          _selectedDate == null
                              ? "Pilih Tanggal"
                              : "${_selectedDate!.toLocal()}".split(' ')[0],
                        ),
                      ),
                      TextFormField(
                        controller: _aktivitasController,
                        decoration: const InputDecoration(
                          labelText: "Aktivitas",
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty ? "Aktivitas wajib diisi" : null,
                      ),
                    ],
                    onSubmit: _simpanData,
                  ),
                ),
                // const SizedBox(height: 24),
                // const Text(
                //   "Daftar Progres",
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                const SizedBox(height: 16),
                _progresList.isEmpty
                    ? const Text("Belum ada data progres.")
                    : TableData(
                      title: 'Daftar Progres',
                      columns: const ['No', 'Tanggal', 'Aktivitas'],
                      data: _progresList,
                      actionLabel: 'Send',
                      onActionPressed: (_, __) {},
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
