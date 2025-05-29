import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/widgets/table.dart';
import 'add_role.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/styles/style.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import 'package:sikermatsu/widgets/table2.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  List<Map<String, dynamic>> _adminData = [];
  bool _isLoading = true;

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
                    'id': user.id.toString(),
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

  Future<void> _delete(
    BuildContext context,
    Map<String, dynamic> rowData,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Yakin ingin menghapus user ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Ya, Hapus'),
              ),
            ],
          ),
    );
    if (confirmed != true) return;
    setState(() => _isLoading = true);
    try {
      final id = rowData['id'];
      if (id == null) {
        throw Exception('ID user tidak valid');
      }
      await AuthService.deleteUser(id);
      await showBerhasil(context, message: 'User berhasil dihapus');
      await _loadData();
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Gagal'),
              content: Text(e.toString().replaceAll('Exception: ', '')),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
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
                          // TABLE
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1000,
                                ),
                                child: CustomPaginatedTable(
                                  title: 'Daftar Admin',
                                  columns: const ['Name', 'Email', 'Role'],
                                  data: _adminData,
                                  onDeletePressed: (context, rowData) async {
                                    await _delete(context, rowData);
                                       _loadData();
                                  },
                                  onEditPressed: (
                                    BuildContext context,
                                    Map<String, dynamic> rowData,
                                  ) async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      '/addrole',
                                      arguments: rowData,
                                    );
                                    if (result == true) {
                                      _loadData();
                                    }
                                  },

                                  // onEditPressed: (
                                  //   BuildContext context,
                                  //   Map<String, dynamic> rowData,
                                  // ) {
                                  //   Navigator.pushNamed(
                                  //     context,
                                  //     '/addrole',
                                  //     arguments: rowData,
                                  //   );
                                  // },
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
                            ).then((value) {
                              if (value == true) {
                                _loadData(); // refresh jika sukses
                              }
                            });
                            // ).then((_) {
                            //   _loadData();
                            // });
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
