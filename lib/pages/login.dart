import 'package:flutter/material.dart';
import 'package:sikermatsu/models/constants.dart';
import 'package:sikermatsu/models/mock_user.dart';
import 'package:sikermatsu/pages/dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sikermatsu/models/app_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  String token = '';
  Map<String, dynamic>? user;

  Future loginUser(String email, String password) async {
    if (useMockLogin) {
      final data = await dummyLogin(email, password);
      if (data != null) {
        setState(() {
          token = data['token'];
          user = data['user'];
        });
        _showBerhasil();
      } else {
        _showGagal("Login gagal. Email atau password salah.");
      }
      return;
    }

    final response = await http.post(
      Uri.parse("http://192.168.100.236:8000/api/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        token = data['token'];
        user = data['user'];
      });

      await fetchUserData();

      if (user != null && user!['name'] != null) {
        _showBerhasil();
      } else {
        _showGagal("Login gagal. Periksa email atau password.");
      }
    } else {
      _showGagal("Gagal terhubung ke server.");
    }
  }

  Future<void> fetchUserData() async {
    final response = await http.get(
      Uri.parse("http://192.168.100.236:8000/api/user"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        user = jsonDecode(response.body);
      });
    } else {
      _showGagal("Gagal mengambil data user.");
    }
  }

  Future<void> _showBerhasil() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil!'),
          content: Text("Selamat datang, ${user?['name'] ?? 'Pengguna'}"),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              // onPressed: () {
              //   AppState.isLoggedIn.value = true;
              //   Navigator.of(context).pushReplacementNamed('/dashboard');
              // },
              onPressed: () {
                AppState.isLoggedIn.value = true;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/dashboard',
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showGagal(String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () => Navigator.of(context).pop(),
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
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
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
                        "Tiga Serangkai University",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
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
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            loginUser(email.text, password.text);
                          }
                        },
                        child: const Text("Login"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text("Belum punya akun? Register"),
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
