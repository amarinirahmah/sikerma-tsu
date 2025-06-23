import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikermatsu/core/app_state.dart';

class SplashScreen extends StatefulWidget {
  final String? initialPath;
  const SplashScreen({super.key, this.initialPath});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role') ?? 'guest';
    final name = prefs.getString('name') ?? '';
    final email = prefs.getString('email') ?? '';

    print('SplashScreen: token = $token, role = $role, name = $name');
    // if (token != null && token.isNotEmpty) {
    //   AppState.loginAs(role, token, name, email);

    //   final initial = widget.initialPath;
    //   final isSafe =
    //       initial != null &&
    //       initial != '/' &&
    //       initial != '/login' &&
    //       initial != '/register' &&
    //       initial != '/splash';

    //   if (isSafe) {
    //     Navigator.pushReplacementNamed(context, initial);
    //   } else if (role == 'admin' || role == 'user') {
    //     Navigator.pushReplacementNamed(context, '/dashboard');
    //   } else if (role == 'userpkl') {
    //     Navigator.pushReplacementNamed(context, '/dashboard2');
    //   } else {
    //     Navigator.pushReplacementNamed(context, '/');
    //   }
    // }

    if (token != null && token.isNotEmpty) {
      AppState.loginAs(role, token, name, email);
      print(
        'SplashScreen: loginAs dipanggil dengan role=$role dan token=$token, name=$name',
      );

      // Redirect sesuai role
      if (role == 'admin' || role == 'user') {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (role == 'userpkl') {
        Navigator.pushReplacementNamed(context, '/dashboard2');
      } else {
        Navigator.pushReplacementNamed(context, '/');
      }
    } else {
      AppState.logout();
      print(
        'SplashScreen: logout dipanggil, set role=guest dan token=null, name=null',
      );
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
