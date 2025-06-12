import 'package:flutter/material.dart';
import 'package:sikermatsu/services/auth_service.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/models/user.dart';
import 'package:sikermatsu/pages/add_role.dart';
import '../styles/style.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  final TextEditingController _searchController = TextEditingController();

  List<User> allUser = [];
  List<User> filteredUser = [];
  bool isLoading = true;
  int rowsPerPage = 10;
  int currentPage = 0;
  String searchQuery = '';
  String selectedRole = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    setState(() => isLoading = true);
    try {
      final data = await AuthService.getAllUser();
      setState(() {
        allUser = data;
        _applyFilter();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat user: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _applyFilter() {
    setState(() {
      filteredUser =
          allUser.where((user) {
            final matchesSearch = user.name.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
            final matchesRole =
                selectedRole == 'Semua' || user.role == selectedRole;
            return matchesSearch && matchesRole;
          }).toList();
      currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AppState.isLoggedIn.value;
    final role = AppState.role.value;
    final totalPages = (filteredUser.length / rowsPerPage).ceil();

    final displayedRows =
        filteredUser.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

    return MainLayout(
      title: '',
      isLoggedIn: isLoggedIn,
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),

                        child: SingleChildScrollView(
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Daftar User',
                                    style: CustomStyle.headline1,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          decoration:
                                              CustomStyle.searchInputDecoration(
                                                labelText: 'Cari Nama User',
                                                prefixIcon: Icon(
                                                  Icons.search,
                                                  color: Colors.grey,
                                                ),
                                                suffixIcon:
                                                    searchQuery.isNotEmpty
                                                        ? IconButton(
                                                          icon: const Icon(
                                                            Icons.clear,
                                                            color: Colors.grey,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              searchQuery = '';
                                                              _searchController
                                                                  .clear();
                                                              _applyFilter();
                                                            });
                                                          },
                                                        )
                                                        : null,
                                              ),
                                          onChanged: (value) {
                                            setState(() {
                                              searchQuery = value;
                                              _applyFilter();
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        decoration:
                                            CustomStyle.dropdownBoxDecoration(),
                                        child: DropdownButton<String>(
                                          // decoration:
                                          //     CustomStyle.dropdownDecoration(),
                                          value: selectedRole,
                                          // isDense: true,
                                          underline: const SizedBox(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              selectedRole = value;
                                              _applyFilter();
                                            }
                                          },
                                          items:
                                              [
                                                    'Semua',
                                                    'admin',
                                                    'user',
                                                    'userpkl',
                                                  ]
                                                  .map(
                                                    (role) => DropdownMenuItem(
                                                      value: role,
                                                      child: Text(role),
                                                    ),
                                                  )
                                                  .toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        // minWidth:
                                        //     MediaQuery.of(context).size.width *
                                        //     0.8, // minimal 80% layar
                                        maxWidth: 1000,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: DataTable(
                                          headingRowColor:
                                              MaterialStateProperty.all<Color>(
                                                Colors.grey[300]!,
                                              ),
                                          headingTextStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          border: TableBorder.all(
                                            color: Colors.grey,
                                          ),
                                          columns: [
                                            DataColumn(label: Text('Nama')),
                                            DataColumn(label: Text('Email')),
                                            DataColumn(label: Text('Role')),
                                            DataColumn(label: Text('Aksi')),
                                          ],
                                          rows:
                                              displayedRows.map((user) {
                                                return DataRow(
                                                  cells: [
                                                    DataCell(Text(user.name)),
                                                    DataCell(Text(user.email)),
                                                    DataCell(Text(user.role)),

                                                    DataCell(
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          if (isLoggedIn &&
                                                              (role ==
                                                                      'admin' ||
                                                                  role ==
                                                                      'user'))
                                                            IconButton(
                                                              icon: const Icon(
                                                                Icons.edit,
                                                                color:
                                                                    Colors
                                                                        .orange,
                                                              ),
                                                              tooltip: 'Edit',
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (
                                                                          context,
                                                                        ) => AddRolePage(
                                                                          user:
                                                                              user,
                                                                        ),
                                                                  ),
                                                                ).then((value) {
                                                                  if (value ==
                                                                      true) {
                                                                    _loadUser();
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          if (isLoggedIn &&
                                                              (role ==
                                                                      'admin' ||
                                                                  role ==
                                                                      'user'))
                                                            IconButton(
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              tooltip: 'Hapus',
                                                              onPressed: () async {
                                                                final confirm = await showDialog<
                                                                  bool
                                                                >(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (
                                                                        context,
                                                                      ) => AlertDialog(
                                                                        title: const Text(
                                                                          'Konfirmasi',
                                                                        ),
                                                                        content:
                                                                            Text(
                                                                              'Hapus user dengan nama ${user.name}?',
                                                                            ),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () => Navigator.pop(
                                                                                  context,
                                                                                  false,
                                                                                ),
                                                                            child: const Text(
                                                                              'Batal',
                                                                            ),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed:
                                                                                () => Navigator.pop(
                                                                                  context,
                                                                                  true,
                                                                                ),
                                                                            child: const Text(
                                                                              'Hapus',
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                );
                                                                if (confirm ==
                                                                    true) {
                                                                  try {
                                                                    await AuthService.deleteUser(
                                                                      user.id
                                                                          .toString(),
                                                                    );
                                                                    ScaffoldMessenger.of(
                                                                      context,
                                                                    ).showSnackBar(
                                                                      const SnackBar(
                                                                        content:
                                                                            Text(
                                                                              'Berhasil menghapus user',
                                                                            ),
                                                                      ),
                                                                    );
                                                                    await _loadUser();
                                                                  } catch (e) {
                                                                    ScaffoldMessenger.of(
                                                                      context,
                                                                    ).showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text(
                                                                              'Gagal menghapus user: $e',
                                                                            ),
                                                                      ),
                                                                    );
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text('Baris per halaman:'),
                                          const SizedBox(width: 8),
                                          DropdownButton<int>(
                                            value: rowsPerPage,
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(
                                                  () => rowsPerPage = value,
                                                );
                                                _applyFilter();
                                              }
                                            },
                                            items:
                                                [10, 15, 20]
                                                    .map(
                                                      (e) => DropdownMenuItem(
                                                        value: e,
                                                        child: Text('$e'),
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.chevron_left,
                                            ),
                                            onPressed:
                                                currentPage > 0
                                                    ? () => setState(
                                                      () => currentPage--,
                                                    )
                                                    : null,
                                          ),
                                          Text(
                                            '${currentPage + 1} / $totalPages',
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.chevron_right,
                                            ),
                                            onPressed:
                                                currentPage < totalPages - 1
                                                    ? () => setState(
                                                      () => currentPage++,
                                                    )
                                                    : null,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isLoggedIn && role != 'userpkl')
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/addrole').then((
                            result,
                          ) {
                            // _loadUser();
                            if (result == true) {
                              _loadUser();
                            }
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
