import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sikermatsu/models/user.dart';
import 'package:sikermatsu/pages/user/login.dart';
import 'package:http/http.dart' as http;
import 'package:sikermatsu/styles/style.dart';
import 'package:sikermatsu/widgets/user_card.dart';
import 'package:sikermatsu/services/auth_service.dart';

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
  bool isLoading = false;

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

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        await AuthService.registerUser(
          name: name.text,
          email: email.text,
          password: password.text,
        );
        setState(() => isLoading = false);
        await _showBerhasil();
      } catch (e) {
        setState(() => isLoading = false);
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(e.toString().replaceAll('Exception: ', '')),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 236, 236),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: UserCard(
              title: "Register",
              formKey: _formKey,
              fields: [
                TextFormField(
                  controller: name,
                  decoration: CustomStyle.inputDecorationWithLabel(
                    labelText: 'Name',
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
                      (value) => value!.isEmpty ? 'Email wajib diisi' : null,
                ),
                TextFormField(
                  controller: password,
                  decoration: CustomStyle.inputDecorationWithLabel(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator:
                      (value) => value!.isEmpty ? 'Password wajib diisi' : null,
                ),
              ],
              buttonLabel: 'Register',
              isLoading: isLoading,
              // onSubmit: () {
              //   if (_formKey.currentState!.validate()) {
              //     registerUser(name.text, email.text, password.text);
              //   }
              // },
              onSubmit: _handleRegister,
              footer: TextButton(
                onPressed:
                    () => Navigator.pushReplacementNamed(context, '/login'),
                style: CustomStyle.textButtonStyle2,
                child: const Text("Sudah punya akun? Login"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
