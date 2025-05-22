import 'package:flutter/material.dart';
import 'package:sikermatsu/models/user.dart';
import 'package:sikermatsu/pages/login.dart';
import '../widgets/main_layout.dart';
import 'package:sikermatsu/models/app_state.dart';
import '../styles/style.dart';
import '../widgets/user_card.dart';
import '../services/auth_service.dart';

class AddRolePage extends StatefulWidget {
  const AddRolePage({super.key});

  @override
  State<AddRolePage> createState() => _AddRolePageState();
}

class _AddRolePageState extends State<AddRolePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  String role = 'admin';
  bool isLoading = false;
  Map<String, dynamic>? editUser;
  bool isEditMode = false;
  bool isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        editUser = args;
        isEditMode = true;
        name.text = editUser!['name'] ?? '';
        email.text = editUser!['email'] ?? '';
        role = editUser!['role'] ?? 'admin';
      }
      isInit = true;
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final args = ModalRoute.of(context)?.settings.arguments;
  //   if (args != null && args is Map<String, dynamic>) {
  //     editUser = args;
  //     isEditMode = true;
  //     name.text = editUser!['name'] ?? '';
  //     email.text = editUser!['email'] ?? '';
  //     role = editUser!['role'] ?? 'admin';
  //   }
  // }

  // Future<void> registerUserByAdmin() async {
  //   setState(() => isLoading = true);

  //   try {
  //     await AuthService.registerUserByAdmin(
  //       name.text,
  //       email.text,
  //       password.text,
  //       role,
  //     );

  //     setState(() => isLoading = false);
  //       await _showBerhasil();

  //     name.clear();
  //     email.clear();
  //     password.clear();
  //     setState(() {
  //       role = 'admin';
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text(e.toString())));
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      if (isEditMode) {
        final token = await AuthService.getToken();
        await AuthService.updateUser(
          // id: editUser!['id'],
          id: int.tryParse(editUser!['id'].toString()) ?? 0,
          name: name.text,
          email: email.text,
          role: role,
          token: token.toString(),
        );
        await _showBerhasil(message: 'User berhasil diupdate');
      } else {
        await AuthService.registerUserByAdmin(
          name.text,
          email.text,
          password.text,
          role,
        );
        await _showBerhasil(message: 'User berhasil ditambahkan');
        name.clear();
        email.clear();
        password.clear();
      }

      Navigator.pop(context, true); // kembali ke halaman sebelumnya
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Berhasil!'),
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
      setState(() => isLoading = false);
    }
  }
  // Future<void> registerUserByAdmin() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() => isLoading = true);

  //   try {
  //     await AuthService.registerUserByAdmin(
  //       name.text,
  //       email.text,
  //       password.text,
  //       role,
  //     );

  //     setState(() => isLoading = false);

  //     await _showBerhasil();

  //     // Clear fields setelah berhasil
  //     name.clear();
  //     email.clear();
  //     password.clear();
  //     setState(() {
  //       role = 'admin';
  //     });
  //   } catch (e) {
  //     setState(() => isLoading = false);

  //     showDialog(
  //       context: context,
  //       builder:
  //           (context) => AlertDialog(
  //             title: const Text('Error'),
  //             content: Text(e.toString().replaceAll('Exception: ', '')),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text('OK'),
  //               ),
  //             ],
  //           ),
  //     );
  //   }
  // }

  Future<void> _showBerhasil({required String message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil!'),
          content: Text(message),
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
          title: "",
          isLoggedIn: isLoggedIn,
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: UserCard(
                  title: isEditMode ? "Edit User" : "Tambah Role",
                  formKey: _formKey,
                  fields: [
                    TextFormField(
                      controller: name,
                      decoration: CustomStyle.inputDecorationWithLabel(
                        labelText: 'Nama',
                      ),
                      validator:
                          (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
                    ),
                    TextFormField(
                      controller: email,
                      decoration: CustomStyle.inputDecorationWithLabel(
                        labelText: 'Email',
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Email wajib diisi' : null,
                    ),
                    if (!isEditMode)
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: CustomStyle.inputDecorationWithLabel(
                          labelText: 'Password',
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Password wajib diisi' : null,
                      ),

                    DropdownButtonFormField<String>(
                      value: role,
                      decoration: CustomStyle.dropdownDecoration(
                        hintText: 'Pilih role',
                      ),
                      items:
                          ['admin', 'user', 'userpkl']
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          role = value!;
                        });
                      },
                    ),
                  ],
                  buttonLabel: isEditMode ? "Simpan Perubahan" : "Register",
                  isLoading: isLoading,
                  onSubmit: submitForm,
                  // onSubmit: () {
                  //   if (_formKey.currentState!.validate()) {
                  //     _showBerhasil();
                  //      registerUserByAdmin();
                  //   }
                  // },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: AppState.isLoggedIn,
//       builder: (context, isLoggedIn, _) {
//         return MainLayout(
//           title: "",
//           isLoggedIn: isLoggedIn,
//           child: Center(
//             child: SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(maxWidth: 800),
//                 child: Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 24),
//                   color: Colors.white,
//                   elevation: 1,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const SizedBox(height: 24),
//                           TextFormField(
//                             controller: name,
//                             decoration: const InputDecoration(
//                               labelText: 'Name',
//                               border: OutlineInputBorder(),
//                             ),
//                             validator:
//                                 (value) =>
//                                     value!.isEmpty ? 'Nama wajib diisi' : null,
//                           ),
//                           const SizedBox(height: 16),
//                           TextFormField(
//                             controller: email,
//                             decoration: const InputDecoration(
//                               labelText: 'Email',
//                               border: OutlineInputBorder(),
//                             ),
//                             validator:
//                                 (value) =>
//                                     value!.isEmpty ? 'Email wajib diisi' : null,
//                           ),
//                           const SizedBox(height: 16),
//                           TextFormField(
//                             controller: password,
//                             decoration: const InputDecoration(
//                               labelText: 'Password',
//                               border: OutlineInputBorder(),
//                             ),
//                             obscureText: true,
//                             validator:
//                                 (value) =>
//                                     value!.isEmpty
//                                         ? 'Password wajib diisi'
//                                         : null,
//                           ),
//                           const SizedBox(height: 16),
//                           DropdownButtonFormField<String>(
//                             value: role,
//                             items:
//                                 ['admin', 'user', 'userpkl']
//                                     .map(
//                                       (role) => DropdownMenuItem(
//                                         value: role,
//                                         child: Text(role),
//                                       ),
//                                     )
//                                     .toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 role = value!;
//                               });
//                             },
//                             decoration: const InputDecoration(
//                               labelText: 'Role',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           ElevatedButton(
//                             onPressed: () {
//                               // if (_formKey.currentState!.validate()) {
//                               //   registerAdmin(
//                               //     name.text,
//                               //     email.text,
//                               //     password.text,
//                               //     role,
//                               //   );
//                               // }
//                               _showBerhasil();
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.teal,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                             child: const Text("Register"),
//                           ),
//                           // TextButton(
//                           //   onPressed: () {
//                           //     Navigator.pushNamed(context, '/login');
//                           //   },
//                           //   child: const Text("Sudah punya akun? Login"),
//                           // ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
