import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/dashboard.dart';
import 'pages/mou.dart';
import 'pages/pks.dart';
import 'pages/daftar_progres.dart';
import 'pages/daftar_notifikasi.dart';
import 'pages/detail_progres.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sikerma TSU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const AdminDashboardPage(),
        '/mou': (context) => const MoUPage(),
        '/pks': (context) => const PKSPage(),
        '/progres': (context) => const ProgressPage(),
        '/notifikasi': (context) => const NotificationPage(),
        '/detailprogres': (context) => const DetailProgressPage(),
      },
    );
  }
}
