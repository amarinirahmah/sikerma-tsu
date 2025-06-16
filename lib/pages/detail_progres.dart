import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/models/app_state.dart';
import '../styles/style.dart';
import 'package:sikermatsu/services/detail_progres_service.dart';
import 'package:sikermatsu/models/detail_progres.dart';
import 'package:sikermatsu/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DetailProgressPage extends StatefulWidget {
  // final DetailProgress? detailprogres;
  final int mouId;

  const DetailProgressPage({super.key, required this.mouId});

  @override
  State<DetailProgressPage> createState() => _DetailProgressPageState();
}

class _DetailProgressPageState extends State<DetailProgressPage> {
  final _formKey = GlobalKey<FormState>();
  final aktivitas = TextEditingController();
  List<DetailProgress> progresList = [];
  DateTime? tanggal;
  String? selectedProses;
  bool isLoading = false;

  static const List<Map<String, String>> prosesOptions = [
    {'value': 'PembuatanDraft', 'label': 'Pembuatan Draft'},
    {'value': 'PengajuanDraft', 'label': 'Pengajuan Draft'},
    {'value': 'PenyerahanMOU', 'label': 'Penyerahan MOU'},
  ];

  @override
  void initState() {
    super.initState();
    fetchProgress();
  }

  void _pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggal ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        tanggal = picked;
      });
    }
  }

  Future<void> fetchProgress() async {
    setState(() => isLoading = true);

    try {
      final data = await DetailProgressService.getProgress(widget.mouId);
      setState(() {
        progresList = data;
      });
    } catch (e) {
      setState(() {
        progresList = [];
      });
      debugPrint('Gagal mengambil log aktivitas: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || tanggal == null) return;

    try {
      await DetailProgressService.addProgress(
        id: widget.mouId,
        tanggal: DateFormat('yyyy-MM-dd').format(tanggal!),
        aktivitas: aktivitas.text,
        proses: selectedProses!,
      );
      aktivitas.clear();
      tanggal = null;
      selectedProses = null;
      await fetchProgress();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menambah log aktivitas')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "",
      isLoggedIn: AppState.isLoggedIn.value,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 1.5,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Log Aktivitas Kerja Sama',
                          style: CustomStyle.headline1,
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.date_range),
                          style: CustomStyle.outlinedButtonStyle,
                          label: Text(
                            tanggal == null
                                ? "Pilih Tanggal"
                                : 'Tanggal: ${DateFormat('dd MMM yyyy').format(tanggal!)}',
                          ),
                          onPressed: _pickTanggal,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Proses',
                          ),
                          value: selectedProses,
                          items:
                              prosesOptions.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option['value'],
                                  child: Text(option['label']!),
                                );
                              }).toList(),
                          validator:
                              (value) => value == null ? 'Wajib diisi' : null,
                          onChanged:
                              (value) => setState(() => selectedProses = value),
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: aktivitas,
                          decoration: CustomStyle.inputDecorationWithLabel(
                            labelText: 'Deskripsi',
                          ),
                          validator:
                              (val) =>
                                  val == null || val.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                        ),

                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: CustomStyle.baseButtonStyle,
                            onPressed: _submit,
                            child: const Text("Simpan"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : progresList.isEmpty
                    ? const Text('Belum ada data progres.')
                    : Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Riwayat Progres',
                              style: CustomStyle.headline1,
                            ),
                            const SizedBox(height: 10),
                            DataTable(
                              headingRowColor: MaterialStateProperty.all<Color>(
                                Colors.grey[300]!,
                              ),
                              headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              border: TableBorder.all(color: Colors.grey),
                              columns: const [
                                DataColumn(label: Text('Tanggal')),
                                DataColumn(label: Text('Proses')),
                                DataColumn(label: Text('Aktivitas')),
                              ],
                              rows:
                                  progresList.map((e) {
                                    final formattedDate = DateFormat(
                                      'dd MMMM yyyy',
                                      'id',
                                    ).format(DateTime.parse(e.tanggal));
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(formattedDate)),
                                        DataCell(Text(e.prosesText)),
                                        DataCell(Text(e.aktivitas)),
                                      ],
                                    );
                                  }).toList(),
                            ),
                          ],
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
