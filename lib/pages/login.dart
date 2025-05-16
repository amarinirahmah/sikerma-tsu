import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/models/mock_user.dart';
import 'package:sikermatsu/styles/style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isLoading = false;

  Future<void> loginUser(String email, String password) async {
    setState(() {
      isLoading = true;
    });

    final data = await dummyLogin(email, password);
    if (data != null) {
      final currentUser = data['user'] as Map<String, dynamic>;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token'] ?? '');
      await prefs.setString('userName', currentUser['name'] ?? '');
      await prefs.setString('userEmail', currentUser['email'] ?? '');
      await prefs.setString('role', currentUser['role'] ?? '');

      _setUserRole(currentUser['role'] ?? 'guest');

      setState(() {
        AppState.isLoggedIn.value = true;
      });

      _showBerhasil(currentUser);
    } else {
      _showGagal("Login gagal. Email atau password salah.");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _setUserRole(String role) {
    if (role == 'admin') {
      AppState.role.value = 'admin';
    } else if (role == 'user') {
      AppState.role.value = 'user';
    } else if (role == 'userpkl') {
      AppState.role.value = 'userpkl';
    } else {
      AppState.role.value = 'guest';
    }
  }

  Future<void> _showBerhasil(Map<String, dynamic> user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil!'),
          content: Text("Selamat datang, ${user['name']}"),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
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
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    loginUser(email.text, password.text);
                                  }
                                },
                        style: CustomStyle.getButtonStyleByLabel('Login'),

                        child:
                            isLoading
                                ? const CircularProgressIndicator()
                                : const Text("Login"),
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

// import 'package:flutter/material.dart';
// import 'package:sikermatsu/models/auth_service.dart';
// import 'package:sikermatsu/models/user.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController password = TextEditingController();

//   bool isLoading = false;

//   Future<void> login() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final user = await AuthService.login(email.text, password.text);

//       if (user.role == 'admin' || user.role == 'user') {
//         Navigator.pushReplacementNamed(context, '/dashboard');
//       } else if (user.role == 'userpkl') {
//         Navigator.pushReplacementNamed(context, '/pkl');
//       } else {
//         _showGagal("Role tidak valid");
//       }
//     } catch (e) {
//       _showGagal(e.toString());
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('access_token');
//     await prefs.remove('role');

//     Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//   }

//   // Menampilkan dialog jika login berhasil
//   Future<void> _showBerhasil(User user) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Berhasil!'),
//           content: Text("Selamat datang, ${user.name}"),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   '/dashboard',
//                   (route) => false,
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Menampilkan dialog jika login gagal
//   Future<void> _showGagal(String message) async {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Tutup'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 236, 236, 236),
//       body: Center(
//         child: SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 400),
//             child: Card(
//               color: Colors.white,
//               elevation: 1,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         "Tiga Serangkai University",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       TextFormField(
//                         controller: email,
//                         decoration: const InputDecoration(
//                           labelText: 'Email',
//                           border: OutlineInputBorder(),
//                         ),
//                         validator:
//                             (value) =>
//                                 value!.isEmpty ? 'Email wajib diisi' : null,
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: password,
//                         decoration: const InputDecoration(
//                           labelText: 'Password',
//                           border: OutlineInputBorder(),
//                         ),
//                         obscureText: true,
//                         validator:
//                             (value) =>
//                                 value!.isEmpty ? 'Password wajib diisi' : null,
//                       ),
//                       const SizedBox(height: 24),
//                       ElevatedButton(
//                         onPressed:
//                             isLoading
//                                 ? null
//                                 : () {
//                                   if (_formKey.currentState!.validate()) {
//                                     login();
//                                   }
//                                 },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.teal,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                         ),
//                         child:
//                             isLoading
//                                 ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                                 : const Text("Login"),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/register');
//                         },
//                         child: const Text("Belum punya akun? Register"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
