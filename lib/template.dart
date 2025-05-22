// import 'package:flutter/material.dart';
// import 'pages/login.dart';
// import 'pages/super_admin.dart';
// import 'pages/dashboard.dart';
// import 'pages/mou.dart';
// import 'pages/pks.dart';
// import 'pages/daftar_progres.dart';
// import 'pages/daftar_notifikasi.dart';
// import 'pages/detail_progres.dart';
// import 'pages/daftar_mou.dart';
// import 'pages/detail_mou.dart';
// import 'pages/daftar_pks.dart';
// import 'pages/detail_pks.dart';
// import 'pages/register.dart';
// import 'pages/add_role.dart';
// import 'pages/pengajuan_pkl.dart';
// import 'pages/pkl.dart';
// import 'pages/detail_pkl.dart';
// import 'pages/home.dart';

// class Template extends StatefulWidget {
//   const Template({super.key});

//   @override
//   State<Template> createState() => _TemplateState();
// }

// class _TemplateState extends State<Template> {
//   int selectedPage = 0;
//   final _pageOption = [
//     AdminDashboardPage();
//     MoUPage();
//     UploadMoUPage();
//     PKSPage();
//     UploadPKSPage();
//     ProgresPage();
//     UploadPKLPage();
//     SuperAdminPage();
//   ];

//   void _onItemTap(int i) {
//     setState(() {
//       selectedPage = i;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,title: Text("Tes"),
//       ),
//       body: _pageOption[selectedPage],
//       drawer: Drawer(
//         backgroundColor: Colors.white,
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Menu'),
//                   IconButton(onPressed: () {Navigator.pop(context);}), icon:const Icon(Icons.close),
//                 ],
//               ),
//             ),
//             ListTile(
//               title: const Text('Dashboard'),
//               onTap: () {
//                 _onItemTap(0);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Daftar MoU'),
//               onTap: () {
//                 _onItemTap(1);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Upload MoU'),
//               onTap: () {
//                 _onItemTap(2);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Daftar PKS'),
//               onTap: () {
//                 _onItemTap(3);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Upload PKS'),
//               onTap: () {
//                 _onItemTap(4);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Progres Kerja Sama'),
//               onTap: () {
//                 _onItemTap(0);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Pengajuan PKL'),
//               onTap: () {
//                 _onItemTap(0);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Dashboard'),
//               onTap: () {
//                 _onItemTap(0);
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         )
//       ),
//     );
//   }
// }
