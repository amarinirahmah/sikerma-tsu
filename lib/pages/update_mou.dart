// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:sikermatsu/widgets/main_layout.dart';
// import 'package:sikermatsu/widgets/upload_card.dart';
// import 'package:sikermatsu/models/app_state.dart';

// import '../styles/style.dart';
// import 'package:sikermatsu/services/mou_service.dart';
// import 'package:sikermatsu/models/mou.dart';

// class UpdateMoUPage extends StatefulWidget {
//   const UpdateMoUPage({super.key});

//   @override
//   State<UpdateMoUPage> createState() => _UpdateMoUPageState();
// }

// class _UpdateMoUPageState extends State<UpdateMoUPage> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController nomorMou;
//   late TextEditingController nomorMou2;
//   late TextEditingController nama;
//   late TextEditingController judul;
//   late TextEditingController ruangLingkup;
//   late TextEditingController nama1;
//   late TextEditingController jabatan1;
//   late TextEditingController alamat1;
//   late TextEditingController nama2;
//   late TextEditingController jabatan2;
//   late TextEditingController alamat2;

//   DateTime? tanggalMulai;
//   DateTime? tanggalBerakhir;
//   String? fileName;
//   PlatformFile? _pickedPlatformFile;

//   Mou? mou;
//   bool _initialized = false;

//   @override
// void didChangeDependencies() {
//   super.didChangeDependencies();

//   if (!_initialized) {
//     final args = ModalRoute.of(context)!.settings.arguments;

//     if (args != null && args is Map<String, dynamic>) {
//     // final Map<String, dynamic> rowData = args;
//     //   final Mou mou = Mou.fromMap(rowData);
//       mou = Mou.fromMap(args);

//       nomorMou = TextEditingController(text: mou!.nomorMou);
//       nomorMou2 = TextEditingController(text: mou!.nomorMou2);
//       nama = TextEditingController(text: mou!.nama);
//       judul = TextEditingController(text: mou!.judul);
//       ruangLingkup = TextEditingController(text: mou!.ruangLingkup);

//       nama1 = TextEditingController(text: mou!.pihak1.nama);
//       jabatan1 = TextEditingController(text: mou!.pihak1.jabatan);
//       alamat1 = TextEditingController(text: mou!.pihak1.alamat);

//       nama2 = TextEditingController(text: mou!.pihak2.nama);
//       jabatan2 = TextEditingController(text: mou!.pihak2.jabatan);
//       alamat2 = TextEditingController(text: mou!.pihak2.alamat);

//       tanggalMulai = mou!.tanggalMulai;
//       tanggalBerakhir = mou!.tanggalBerakhir;
//     } else {
//         mou = null;
//       nomorMou = TextEditingController();
//       nomorMou2 = TextEditingController();
//       nama = TextEditingController();
//       judul = TextEditingController();
//       ruangLingkup = TextEditingController();
//       nama1 = TextEditingController();
//       jabatan1 = TextEditingController();
//       alamat1 = TextEditingController();
//       nama2 = TextEditingController();
//       jabatan2 = TextEditingController();
//       alamat2 = TextEditingController();
//        tanggalMulai = DateTime.now();
//       tanggalBerakhir = DateTime.now();
//     }

//     _initialized = true;
//     setState(() {});
//   }
// }


//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();

//   //   if (!_initialized) {
//   //     final args = ModalRoute.of(context)!.settings.arguments;
//   //     if (args is Mou) {
//   //       mou = args;

//   //       nomorMou = TextEditingController(text: mou!.nomorMou);
//   //       nomorMou2 = TextEditingController(text: mou!.nomorMou2);
//   //       nama = TextEditingController(text: mou!.nama);
//   //       judul = TextEditingController(text: mou!.judul);
//   //       ruangLingkup = TextEditingController(text: mou!.ruangLingkup);

//   //       nama1 = TextEditingController(text: mou!.pihak1.nama);
//   //       jabatan1 = TextEditingController(text: mou!.pihak1.jabatan);
//   //       alamat1 = TextEditingController(text: mou!.pihak1.alamat);

//   //       nama2 = TextEditingController(text: mou!.pihak2.nama);
//   //       jabatan2 = TextEditingController(text: mou!.pihak2.jabatan);
//   //       alamat2 = TextEditingController(text: mou!.pihak2.alamat);

//   //       tanggalMulai = mou!.tanggalMulai;
//   //       tanggalBerakhir = mou!.tanggalBerakhir;

//   //       _initialized = true;
//   //       setState(() {});
//   //     } else {
//   //       // Jika args tidak Mou, inisialisasi controller kosong agar tidak error
//   //       nomorMou = TextEditingController();
//   //       nomorMou2 = TextEditingController();
//   //       nama = TextEditingController();
//   //       judul = TextEditingController();
//   //       ruangLingkup = TextEditingController();
//   //       nama1 = TextEditingController();
//   //       jabatan1 = TextEditingController();
//   //       alamat1 = TextEditingController();
//   //       nama2 = TextEditingController();
//   //       jabatan2 = TextEditingController();
//   //       alamat2 = TextEditingController();
//   //     }
//   //   }
//   // }

//   @override
//   void dispose() {
//     nomorMou.dispose();
//     nomorMou2.dispose();
//     nama.dispose();
//     judul.dispose();
//     ruangLingkup.dispose();
//     nama1.dispose();
//     jabatan1.dispose();
//     alamat1.dispose();
//     nama2.dispose();
//     jabatan2.dispose();
//     alamat2.dispose();
//     super.dispose();
//   }

//   void _pickTanggalMulai() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: tanggalMulai ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         tanggalMulai = picked;
//         if (tanggalBerakhir != null && tanggalBerakhir!.isBefore(picked)) {
//           tanggalBerakhir = null;
//         }
//       });
//     }
//   }

//   void _pickTanggalBerakhir() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: tanggalBerakhir ?? tanggalMulai ?? DateTime.now(),
//       firstDate: tanggalMulai ?? DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         tanggalBerakhir = picked;
//       });
//     }
//   }

//   void _pickFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
//       allowMultiple: false,
//       withData: true,
//     );

//     if (result != null && result.files.isNotEmpty) {
//       final file = result.files.first;
//       final fileSizeInKB = (file.bytes?.lengthInBytes ?? 0) ~/ 1024;

//       if (fileSizeInKB > 5120) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Ukuran file melebihi 5MB!")),
//         );
//         return;
//       }

//       setState(() {
//         fileName = file.name;
//         _pickedPlatformFile = file;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Tidak ada file yang dipilih.")),
//       );
//     }
//   }

//  Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Harap lengkapi semua data!")),
//       );
//       return;
//     }
 

//     if (mou == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Data MoU tidak ditemukan!")),
//       );
//       return;
//     }

//     final pihak1 = Pihak(
//       nama: nama1.text,
//       jabatan: jabatan1.text,
//       alamat: alamat1.text,
//     );

//     final pihak2 = Pihak(
//       nama: nama2.text,
//       jabatan: jabatan2.text,
//       alamat: alamat2.text,
//     );

//     final updatedMou = Mou(
//       id: mou!.id,
//       nomorMou: nomorMou.text,
//       nomorMou2: nomorMou2.text,
//       nama: nama.text,
//       judul: judul.text,
//       tanggalMulai: tanggalMulai!,
//       tanggalBerakhir: tanggalBerakhir!,
//       ruangLingkup: ruangLingkup.text,
//       pihak1: pihak1,
//       pihak2: pihak2,
//       keterangan: mou!.keterangan,
//     );

//     try {
//       await MouService().updateMou(
//         updatedMou.id.toString(),
//         updatedMou,
//         file: _pickedPlatformFile,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Data MoU berhasil diperbarui!")),
//       );

//       Navigator.pop(context, true);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Gagal memperbarui MoU: $e")),
//       );
//     }
//   }

  
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: AppState.isLoggedIn,
//       builder: (context, isLoggedIn, _) {
//         return MainLayout(
//           title: "",
//           isLoggedIn: isLoggedIn,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Center(
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 700),
//                 child: Form(
//                   key: _formKey,
//                   child: UploadCard(
//                     title: "Form Edit MoU",
//                     onSubmit: _submitForm,
//                     fields: [
//                       buildField("Nomor MoU", nomorMou),
//                       buildField("Nomor MoU 2", nomorMou2),
//                       buildField("Nama Mitra", nama),
//                       buildField("Judul Kerja Sama", judul),
//                       buildDateRow("Tanggal Mulai", tanggalMulai, _pickTanggalMulai),
//                       buildDateRow("Tanggal Berakhir", tanggalBerakhir, _pickTanggalBerakhir),
//                       buildField("Ruang Lingkup", ruangLingkup, maxLines: 3),
//                       buildField("Nama Pihak 1", nama1),
//                       buildField("Jabatan Pihak 1", jabatan1),
//                       buildField("Alamat Pihak 1", alamat1),
//                       buildField("Nama Pihak 2", nama2),
//                       buildField("Jabatan Pihak 2", jabatan2),
//                       buildField("Alamat Pihak 2", alamat2),
//                       buildFileRow(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget buildField(String label, TextEditingController controller,
//       {int maxLines = 1}) {
//     return Row(
//       crossAxisAlignment:
//           maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
//       children: [
//         SizedBox(width: 130, child: Text(label)),
//         const SizedBox(width: 16),
//         Expanded(
//           child: TextFormField(
//             controller: controller,
//             decoration: CustomStyle.inputDecoration(),
//             maxLines: maxLines,
//             validator: (value) => value!.isEmpty ? "$label wajib diisi" : null,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildDateRow(String label, DateTime? date, VoidCallback onTap) {
//     return Row(
//       children: [
//         SizedBox(width: 130, child: Text(label)),
//         const SizedBox(width: 16),
//         Expanded(
//           child: OutlinedButton(
//             onPressed: onTap,
//             style: CustomStyle.outlinedButtonStyle,
//             child: Text(
//               date == null ? "Pilih Tanggal" : "${date.toLocal()}".split(' ')[0],
//               style: CustomStyle.dateTextStyle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildFileRow() {
//     return Row(
//       children: [
//         const SizedBox(width: 130, child: Text("Upload File (opsional)")),
//         const SizedBox(width: 16),
//         Expanded(
//           child: OutlinedButton.icon(
//             onPressed: _pickFile,
//             icon: const Icon(Icons.attach_file),
//             label: Text(fileName ?? "Pilih File MoU"),
//             style: CustomStyle.outlinedButtonStyle,
//           ),
//         ),
//       ],
//     );
//   }
// }