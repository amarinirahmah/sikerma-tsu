import 'package:flutter/material.dart';
import '../../main_layout.dart';
import 'package:sikermatsu/states/app_state.dart';
import '../../styles/style.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

class AddRolePage extends StatefulWidget {
  final User? user;
  const AddRolePage({super.key, this.user});

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

  @override
  void initState() {
    if (widget.user != null) {
      final user = widget.user!;
      name.text = user.name;
      email.text = user.email;
      role = user.role;
    }
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      if (widget.user == null) {
        await AuthService.registerUserByAdmin(
          name.text,
          email.text,
          password.text,
          role,
        );

        await _showBerhasil(message: 'User berhasil ditambahkan!');
        name.clear();
        email.clear();
        password.clear();
        // if (!mounted) return;
        // Navigator.pop(context, true);
      } else {
        final token = await AuthService.getToken();
        await AuthService.updateUser(
          id: widget.user!.id,
          name: name.text,
          email: email.text,
          role: role,
          token: token.toString(),
        );
        await _showBerhasil(message: 'User berhasil diperbarui!');
        name.clear();
        email.clear();
        password.clear();
      }
      // if (!mounted) return;
      // Navigator.pop(context, true);
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Gagal!'),
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
                Navigator.of(context).pop(true);
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
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: name,
                            decoration: CustomStyle.inputDecorationWithLabel(
                              labelText: 'Nama',
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty ? 'Nama wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: email,
                            decoration: CustomStyle.inputDecorationWithLabel(
                              labelText: 'Email',
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty ? 'Email wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),

                          if (widget.user == null)
                            TextFormField(
                              controller: password,
                              decoration: CustomStyle.inputDecorationWithLabel(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (widget.user == null &&
                                    (value == null || value.isEmpty)) {
                                  return 'Password wajib diisi';
                                }
                                return null;
                              },
                            ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: role,
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
                            decoration: CustomStyle.inputDecorationWithLabel(
                              labelText: 'Role',
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              submitForm();
                            },
                            style: CustomStyle.baseButtonStyle,
                            child: Text(
                              widget.user == null ? "Register" : "Update",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
  //                 child: UserCard(
  //                   title: isEditMode ? "Edit User" : "Tambah Role",
  //                   formKey: _formKey,
  //                   fields: [
  //                     TextFormField(
  //                       controller: name,
  //                       decoration: CustomStyle.inputDecorationWithLabel(
  //                         labelText: 'Nama',
  //                       ),
  //                       validator:
  //                           (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
  //                     ),
  //                     TextFormField(
  //                       controller: email,
  //                       decoration: CustomStyle.inputDecorationWithLabel(
  //                         labelText: 'Email',
  //                       ),
  //                       validator:
  //                           (value) =>
  //                               value!.isEmpty ? 'Email wajib diisi' : null,
  //                     ),
  //                     if (!isEditMode)
  //                       TextFormField(
  //                         controller: password,
  //                         obscureText: true,
  //                         decoration: CustomStyle.inputDecorationWithLabel(
  //                           labelText: 'Password',
  //                         ),
  //                         validator:
  //                             (value) =>
  //                                 value!.isEmpty ? 'Password wajib diisi' : null,
  //                       ),

  //                     DropdownButtonFormField<String>(
  //                       value: role,
  //                       decoration: CustomStyle.dropdownDecoration(
  //                         hintText: 'Pilih role',
  //                       ),
  //                       items:
  //                           ['admin', 'user', 'userpkl']
  //                               .map(
  //                                 (role) => DropdownMenuItem(
  //                                   value: role,
  //                                   child: Text(role),
  //                                 ),
  //                               )
  //                               .toList(),
  //                       onChanged: (value) {
  //                         setState(() {
  //                           role = value!;
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                   buttonLabel: isEditMode ? "Simpan Perubahan" : "Register",
  //                   isLoading: isLoading,
  //                   onSubmit: submitForm,
  //                   // onSubmit: () {
  //                   //   if (_formKey.currentState!.validate()) {
  //                   //     _showBerhasil();
  //                   //      registerUserByAdmin();
  //                   //   }
  //                   // },
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }
