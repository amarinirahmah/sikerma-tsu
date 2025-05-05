import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'add_role.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  final List<Map<String, dynamic>> _adminData = [
    {'Name': 'Admin Satu', 'Email': 'admin1@example.com', 'Role': 'admin'},
    {
      'Name': 'Pimpinan Dua',
      'Email': 'pimpinan2@example.com',
      'Role': 'pimpinan',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Kelola Admin',
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
            onActionPressed: (context, rowData) {
              // Optional: Tambahkan konfirmasi jika perlu
              setState(() {
                _adminData.remove(rowData);
              });
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
  }
}
