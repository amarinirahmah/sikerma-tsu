// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/app_state.dart';

// class SplashScreenPage extends StatefulWidget {
//   const SplashScreenPage({super.key});

//   @override
//   State<SplashScreenPage> createState() => _SplashScreenPageState();
// }

// class _SplashScreenPageState extends State<SplashScreenPage> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLogin();
//   }

//   Future<void> _checkLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final role = prefs.getString('role') ?? 'guest';

//     if (token != null && token.isNotEmpty) {
//       await AppState.loginAs(token, role);
//     } else {
//       await AppState.logout();
//     }

//     // Delay supaya splash screen terlihat
//     await Future.delayed(const Duration(seconds: 1));

//     if (!mounted) return;
//     if (AppState.isLoggedIn.value) {
//       Navigator.pushReplacementNamed(context, '/dashboard');
//     } else {
//       Navigator.pushReplacementNamed(context, '/home');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: Center(child: CircularProgressIndicator()));
//   }
// }
