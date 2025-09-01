import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

/// Widget button yang generate PDF rapih dan buka di tab baru (Web).
class CetakLaporanMoUButton extends StatelessWidget {
  final List<dynamic> displayedRows;
  final String judulLaporan;
  final DateTime? startDate;
  final DateTime? endDate;

  const CetakLaporanMoUButton({
    Key? key,
    required this.displayedRows,
    this.judulLaporan = 'Laporan MoU',
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.print),
      label: const Text("Cetak PDF"),
      onPressed: () async {
        try {
          final bytes = await _generatePdfBytes(displayedRows, judulLaporan);
          final blob = html.Blob([bytes], 'application/pdf');
          final url = html.Url.createObjectUrlFromBlob(blob);
          html.window.open(url, '_blank');

          // revoke after a short delay so browser had time to load
          Future.delayed(const Duration(seconds: 3), () {
            try {
              html.Url.revokeObjectUrl(url);
            } catch (_) {}
          });
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal membuat PDF: $e')));
        }
      },
    );
  }

  // ----------------------
  // PDF generation
  // ----------------------
  Future<Uint8List> _generatePdfBytes(List<dynamic> rows, String title) async {
    final doc = pw.Document();
    final font = await _loadDefaultFont();

    final theme = pw.ThemeData.withFont(base: font);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.fromLTRB(32, 40, 32, 40),
        header: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Center(
                child: pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    // decoration: pw.TextDecoration.underline,
                  ),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Center(
                child: pw.Text(
                  // 'Tiga Serangkai University\n'
                  'Badan Pengembangan Usaha Kampus (BPUK)\n'
                  'Jl. K.H Samanhudi No.84-86, Purwosari, Laweyan, Surakarta\n'
                  'Email: bakpu@tsu.ac.id | Telp: +62 858-0362-0777 | Web: kerjasama.tsu.ac.id',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Divider(thickness: 1.2, color: PdfColors.grey600),
              pw.SizedBox(height: 8),
            ],
          );
        },
        // header: (context) {
        //   return pw.Container(
        //     margin: const pw.EdgeInsets.only(bottom: 8),
        //     child: pw.Row(
        //       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        //       crossAxisAlignment: pw.CrossAxisAlignment.start,
        //       children: [
        //         pw.Column(
        //           crossAxisAlignment: pw.CrossAxisAlignment.start,
        //           children: [
        //             pw.Text(
        //               'Tiga Serangkai University',
        //               style: pw.TextStyle(
        //                 fontSize: 12,
        //                 fontWeight: pw.FontWeight.bold,
        //               ),
        //             ),
        //             pw.Text(
        //               'Jl. K.H Samanhudi No.84-86, Purwosari,\nKec. Laweyan, Kota Surakarta,\nJawa Tengah 57149, Indonesia',
        //               style: pw.TextStyle(fontSize: 10),
        //             ),
        //           ],
        //         ),
        //         pw.Column(
        //           crossAxisAlignment: pw.CrossAxisAlignment.end,
        //           children: [
        //             pw.Text(
        //               title,
        //               style: pw.TextStyle(
        //                 fontSize: 12,
        //                 fontWeight: pw.FontWeight.bold,
        //               ),
        //             ),
        //             pw.Text(
        //               _formatDate(DateTime.now()),
        //               style: pw.TextStyle(fontSize: 10),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   );
        // },
        footer: (context) {
          return pw.Column(
            children: [
              pw.Divider(thickness: 0.8, color: PdfColors.grey600),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // pw.Text(
                  //   'Badan Pengembangan Usaha Kampus (BPUK)',
                  //   style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                  // ),
                  pw.Text(
                    'Diakses pada ${_formatDate(DateTime.now())}',
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                  ),

                  pw.Text(
                    'Halaman ${context.pageNumber} / ${context.pagesCount}',
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                  ),
                ],
              ),
            ],
          );
          // return pw.Container(
          //   alignment: pw.Alignment.centerRight,
          //   margin: const pw.EdgeInsets.only(top: 8),
          //   child: pw.Text(
          //     'Halaman ${context.pageNumber} / ${context.pagesCount}',
          //     style: pw.TextStyle(fontSize: 9),
          //   ),
          // );
        },
        build: (context) {
          final draftCount =
              rows.where((m) => m['statusText'] == 'Draft').length;
          final aktifCount =
              rows.where((m) => m['statusText'] == 'Aktif').length;
          final tidakAktifCount =
              rows.where((m) => m['statusText'] == 'Tidak Aktif').length;
          final kadaluarsaCount =
              rows.where((m) => m['statusText'] == 'Kadaluarsa').length;

          final tableData = <List<String>>[
            // header row
            [
              'No.',
              'Nomor\nMoU',
              'Nama Mitra',
              'Judul',
              'Tanggal\nMulai',
              'Tanggal\nBerakhir',
              'Status',
            ],
            // body rows
            ...rows.asMap().entries.map((entry) {
              final index = entry.key + 1; // nomor urut mulai dari 1
              final mou = entry.value;
              final nomor = _safeToString(mou['nomorMou']);
              final nama = _safeToString(mou['nama']);
              final judul = _safeToString(mou['judul']);
              final tMulai = _formatDateFrom(mou['tanggalMulai']);
              final tBerakhir = _formatDateFrom(mou['tanggalBerakhir']);
              final status = _safeToString(mou['statusText']);
              return [
                index.toString(),
                nomor,
                nama,
                judul,
                tMulai,
                tBerakhir,
                status,
              ];
            }).toList(),
            // ...rows.map((mou) {
            //   final nomor = _safeToString(mou['nomorMou']);
            //   final nama = _safeToString(mou['nama']);
            //   final judul = _safeToString(mou['judul']);
            //   final tMulai = _formatDateFrom(mou['tanggalMulai']);
            //   final tBerakhir = _formatDateFrom(mou['tanggalBerakhir']);
            //   final status = _safeToString(mou['statusText']);
            //   return [nomor, nama, judul, tMulai, tBerakhir, status];
            // }).toList(),
          ];

          // Create a table with flexible column widths to allow wrapping
          return [
            pw.SizedBox(height: 6),
            pw.Table.fromTextArray(
              headers: tableData.first,
              data: tableData.sublist(1),
              headerStyle: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: pw.TextStyle(fontSize: 9),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignment: pw.Alignment.topLeft,
              headerAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                3: pw.Alignment.center,
                4: pw.Alignment.center,
                5: pw.Alignment.center,
                6: pw.Alignment.center,
              },
              columnWidths: {
                0: const pw.FractionColumnWidth(0.06), // no
                1: const pw.FractionColumnWidth(0.12), // nisn
                2: const pw.FractionColumnWidth(0.20), // nama
                3: const pw.FractionColumnWidth(0.20), // sekolah
                4: const pw.FractionColumnWidth(0.12), // tanggal mulai
                5: const pw.FractionColumnWidth(0.12), // tanggal berakhir
                6: const pw.FractionColumnWidth(0.10),
              },
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.centerLeft,
                5: pw.Alignment.centerLeft,
              },
            ),
            pw.SizedBox(height: 12),

            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // pw.Text(
                //   startDate != null && endDate != null
                //       ? 'Periode: ${_formatDate(startDate!)} - ${_formatDate(endDate!)}'
                //       : 'Periode: Semua',
                //   style: pw.TextStyle(
                //     fontSize: 10,
                //     fontWeight: pw.FontWeight.bold,
                //   ),
                // ),
                // pw.SizedBox(height: 4),
                pw.Text(
                  'Total MoU: ${rows.length}',
                  style: pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'Status: Draft ($draftCount) | Aktif ($aktifCount) | Tidak Aktif ($tidakAktifCount) | Kadaluarsa ($kadaluarsaCount)',
                  style: pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 10),
              ],
            ),
            // pw.Container(
            //   alignment: pw.Alignment.centerLeft,
            //   child: pw.Text(
            //     'Total: ${rows.length} MoU',
            //     style: pw.TextStyle(fontSize: 10),
            //   ),
            // ),
          ];
        },
      ),
    );

    return doc.save();
  }

  // small helpers
  Future<pw.Font> _loadDefaultFont() async {
    try {
      // jika kamu punya file font di assets, bisa load seperti ini:
      final ttf = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
      return pw.Font.ttf(ttf);
      // return pw.Font.helvetica();
    } catch (_) {
      return pw.Font.helvetica();
    }
  }

  String _safeToString(dynamic v) {
    if (v == null) return '';
    return v.toString();
  }

  String _formatDateFrom(dynamic v) {
    if (v == null) return '';
    try {
      DateTime d;
      if (v is DateTime) {
        d = v;
      } else if (v is String) {
        d = DateTime.parse(v);
      } else {
        // kemungkinan timestamp, coba parse
        d = DateTime.tryParse(v.toString()) ?? DateTime.now();
      }
      return DateFormat('d MMMM yyyy', 'id_ID').format(d);
    } catch (_) {
      return v.toString();
    }
  }

  String _formatDate(DateTime d) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(d);
  }
}
