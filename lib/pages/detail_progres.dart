import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'package:sikermatsu/widgets/upload_card.dart';
import 'package:sikermatsu/models/app_state.dart';
import '../styles/style.dart';

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
  String judulAktivitas = 'Diajukan';

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
          'Proses': judulAktivitas,
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
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: UploadCard(
                        title: "Log Aktivitas Kerja Sama",
                        fields: [
                          buildDateRow("Tanggal", _selectedDate, _pickTanggal),
                          const SizedBox(height: 16),
                          buildDropdownRow(),
                          const SizedBox(height: 16),
                          buildAktivitasField(),
                        ],
                        onSubmit: _simpanData,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Daftar Progres",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 16),
                    _progresList.isEmpty
                        ? const Text("Belum ada data progres.")
                        : TableData(
                          title: 'Daftar Progres',
                          columns: const [
                            'No',
                            'Tanggal',
                            'Proses',
                            'Aktivitas',
                          ],
                          data: _progresList,
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildDateRow(String label, DateTime? date, VoidCallback onTap) {
    return Row(
      children: [
        SizedBox(width: 130, child: Text(label)),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            style: CustomStyle.outlinedButtonStyle,
            onPressed: onTap,
            child: Text(
              date == null
                  ? "Pilih Tanggal"
                  : "${date.toLocal()}".split(' ')[0],
              style: CustomStyle.dateTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDropdownRow() {
    return Row(
      children: [
        const SizedBox(width: 130, child: Text("Proses")),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: judulAktivitas,
            decoration: CustomStyle.dropdownDecoration(hintText: 'Diajukan'),
            items:
                ['Diajukan', 'Disetujui', 'Ditolak']
                    .map(
                      (status) =>
                          DropdownMenuItem(value: status, child: Text(status)),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                judulAktivitas = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildAktivitasField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 130, child: Text("Aktivitas")),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _aktivitasController,
            maxLines: 3,
            decoration: CustomStyle.inputDecoration(),
            validator:
                (value) => value!.isEmpty ? "Aktivitas wajib diisi" : null,
          ),
        ),
      ],
    );
  }
}
