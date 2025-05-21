import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'add_role.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/styles/style.dart';
import '../models/user.dart';
import '../models/auth_service.dart';

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
    setState(() => _isLoading = true);
    try {
      List<User> users = await AuthService.getAllUser();
      setState(() {
        _adminData =
            users
                .map(
                  (user) => {
                    'id': user.id,
                    'Name': user.name,
                    'Email': user.email,
                    'Role': user.role,
                  },
                )
                .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> showBerhasil(
    BuildContext context, {
    String message = 'Berhasil!',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sukses'),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text(message)]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> _loadData() async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   setState(() {
  //     _adminData = [
  //       {'Name': 'Admin Satu', 'Email': 'admin1@example.com', 'Role': 'admin'},
  //       {'Name': 'PKL Dua', 'Email': 'pkl2@example.com', 'Role': 'user pkl'},
  //     ];
  //     _isLoading = false;
  //   });
  // }

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

                                  onActionPressed: (context, rowData) async {},
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
