import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sikermatsu/models/user.dart';
import 'package:sikermatsu/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:sikermatsu/styles/style.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  // String role = 'user';
  // bool submit = false;

  User? userModel;

  Future registerUser(name, email, password) async {
    User userModel;
    final response = await http.post(
      Uri.parse("http://192.168.100.236:8000/api/register"),
      body: {
        "name": name.toString(),
        "email": email.toString(),
        "password": password.toString(),
        // "role": role.toString(),
      },
    );

    userModel = User.fromJson(jsonDecode(response.body)[0]);
    print(userModel);
    print(Exception);
  }

  // void _register() {
  //   if (_formKey.currentState!.validate()) {
  //     Navigator.pushReplacementNamed(context, '/dashboard');
  //   }
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 236, 236),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
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
                      const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                                value!.isEmpty ? 'Password wajib diisi' : null,
                      ),
                      // const SizedBox(height: 16),
                      // DropdownButtonFormField<String>(
                      //   value: role,
                      //   items:
                      //       ['admin', 'user', 'pimpinan', 'super admin']
                      //           .map(
                      //             (role) => DropdownMenuItem(
                      //               value: role,
                      //               child: Text(role),
                      //             ),
                      //           )
                      //           .toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       role = value!;
                      //     });
                      //   },
                      //   decoration: const InputDecoration(
                      //     labelText: 'Role',
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            registerUser(name.text, email.text, password.text);
                          }
                        },
                        style: CustomStyle.getButtonStyleByLabel('Register'),
                        child: const Text("Register"),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text("Sudah punya akun? Login"),
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
  }
}
