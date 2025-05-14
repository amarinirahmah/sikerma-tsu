import 'package:flutter/material.dart';
import 'package:sikermatsu/models/user.dart';
import 'package:sikermatsu/pages/login.dart';
import '../widgets/main_layout.dart';
import 'package:sikermatsu/models/app_state.dart';

class AddRolePage extends StatefulWidget {
  const AddRolePage({super.key});

  @override
  State<AddRolePage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<AddRolePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  String role = 'admin';
  User? userModel;

  // Future registerAdmin(name, email, password, role) async {
  //   User userModel;
  //   final response = await http.post(
  //     Uri.parse("http://192.168.100.236:8000/api/register"),
  //     body: {
  //       "name": name.toString(),
  //       "email": email.toString(),
  //       "password": password.toString(),
  //       "role": role.toString(),
  //     },
  //   );

  //   userModel = User.fromJson(jsonDecode(response.body)[0]);
  //   print(userModel);
  // }

  Future<void> _showBerhasil() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil!'),
          content: const SingleChildScrollView(
            child: ListBody(children: <Widget>[Text("Register berhasil")]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginPage()))
                    .then((value) {
                      setState(() {});
                    });
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
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty ? 'Nama wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: email,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty ? 'Email wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: password,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Password wajib diisi'
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: role,
                            items:
                                ['admin', 'user', 'user pkl']
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
                            decoration: const InputDecoration(
                              labelText: 'Role',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              // if (_formKey.currentState!.validate()) {
                              //   registerAdmin(
                              //     name.text,
                              //     email.text,
                              //     password.text,
                              //     role,
                              //   );
                              // }
                              _showBerhasil();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text("Register"),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, '/login');
                          //   },
                          //   child: const Text("Sudah punya akun? Login"),
                          // ),
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
