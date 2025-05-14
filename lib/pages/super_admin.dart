import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'add_role.dart';
import 'package:sikermatsu/models/app_state.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  final List<Map<String, dynamic>> _adminData = [
    {'Name': 'Admin Satu', 'Email': 'admin1@example.com', 'Role': 'admin'},
    {'Name': 'PKL Dua', 'Email': 'pkl2@example.com', 'Role': 'user pkl'},
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        return MainLayout(
          title: '',
          isLoggedIn: isLoggedIn,
          child: Stack(
            children: [
              TableData(
                title: 'Daftar Admin',
                columns: const ['Name', 'Email', 'Role'],
                data: _adminData,
                actionLabel: 'Hapus',
                getActionBgColor: (label) {
                  if (label == 'Hapus') return Colors.red;
                  if (label == 'Detail' || label == 'Upload' || label == 'Send')
                    return Colors.teal;
                  return Colors.teal;
                },
                getActionFgColor: (_) => Colors.white,
                onActionPressed: (context, rowData) async {
                  // showDialog(
                  //   context: context,
                  //   builder:
                  //       (context) => AlertDialog(
                  //         title: const Text('Konfirmasi'),
                  //         content: const Text(
                  //           'Apakah Anda yakin ingin menghapus user ini?',
                  //         ),
                  //         actions: [
                  //           TextButton(
                  //             onPressed: () => Navigator.of(context).pop(),
                  //             child: const Text('Batal'),
                  //           ),
                  //           TextButton(
                  //             onPressed: () {
                  //               Navigator.of(context).pop(); // Tutup dialog
                  //               ScaffoldMessenger.of(context).showSnackBar(
                  //                 const SnackBar(
                  //                   content: Text('MoU berhasil dihapus!'),
                  //                 ),
                  //               );
                  //             },
                  //             child: const Text('Hapus'),
                  //           ),
                  //         ],
                  //       ),
                  // );

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Konfirmasi'),
                          content: Text(
                            'Yakin ingin menghapus ${rowData['Name']}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                  );

                  if (confirm == true) {
                    setState(() {
                      _adminData.remove(rowData);
                    });
                  }
                },
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddRolePage()),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
