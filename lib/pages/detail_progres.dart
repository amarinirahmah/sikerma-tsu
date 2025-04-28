import 'package:flutter/material.dart';

class DetailProgressPage extends StatefulWidget {
  const DetailProgressPage({super.key});

  @override
  State<DetailProgressPage> createState() => _DaftarProgresPageState();
}

class _DaftarProgresPageState extends State<DetailProgressPage> {
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
          'tanggal': _selectedDate,
          'aktivitas': _aktivitasController.text,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Progres"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _pickTanggal,
                              child: Text(
                                _selectedDate == null
                                    ? "Pilih Tanggal"
                                    : "${_selectedDate!.toLocal()}".split(
                                      ' ',
                                    )[0],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _simpanData,
                        child: const Text("Simpan Data"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Daftar Progres",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _progresList.isEmpty
                    ? const Text("Belum ada data progres.")
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('No')),
                          DataColumn(label: Text('Tanggal')),
                          DataColumn(label: Text('Aktivitas')),
                        ],
                        rows: List<DataRow>.generate(
                          _progresList.length,
                          (index) => DataRow(
                            cells: [
                              DataCell(Text((index + 1).toString())),
                              DataCell(
                                Text(
                                  "${_progresList[index]['tanggal']}".split(
                                    ' ',
                                  )[0],
                                ),
                              ),
                              DataCell(Text(_progresList[index]['aktivitas'])),
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
