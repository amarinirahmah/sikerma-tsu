import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'add_role.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/styles/style.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  List<Map<String, dynamic>> _adminData = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _adminData = [
        {'Name': 'Admin Satu', 'Email': 'admin1@example.com', 'Role': 'admin'},
        {'Name': 'PKL Dua', 'Email': 'pkl2@example.com', 'Role': 'user pkl'},
      ];
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredData {
    if (_searchQuery.isEmpty) return _adminData;
    return _adminData.where((item) {
      return item['Name'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          item['Email'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          item['Role'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        return MainLayout(
          title: '',
          isLoggedIn: isLoggedIn,
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                    children: [
                      Column(
                        children: [
                          // SEARCH BAR
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1000,
                                ),
                                child: TextField(
                                  decoration: CustomStyle.inputDecoration(
                                    hintText: 'Cari Name, Email, atau Role',
                                    prefixIcon: const Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),

                          // TABLE
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1000,
                                ),
                                child: TableData(
                                  title: 'Daftar Admin',
                                  columns: const ['Name', 'Email', 'Role'],
                                  data: _filteredData,
                                  actionLabel: 'Hapus',

                                  onActionPressed: (context, rowData) async {
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
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      false,
                                                    ),
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      true,
                                                    ),
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
                              ),
                            ),
                          ),
                        ],
                      ),

                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddRolePage(),
                              ),
                            ).then((_) {
                              _loadData();
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
