import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/super_admin.dart';
import 'pages/dashboard.dart';
import 'pages/mou.dart';
import 'pages/pks.dart';
import 'pages/daftar_progres.dart';
import 'pages/daftar_notifikasi.dart';
import 'pages/detail_progres.dart';
import 'pages/daftar_mou.dart';
import 'pages/detail_mou.dart';
import 'pages/daftar_pks.dart';
import 'pages/detail_pks.dart';
import 'pages/register.dart';

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
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/superadmin': (context) => const SuperAdminPage(),
        '/dashboard': (context) => const AdminDashboardPage(),
        '/uploadmou': (context) => const UploadMoUPage(),
        '/uploadpks': (context) => const UploadPKSPage(),
        '/progres': (context) => const ProgressPage(),
        '/notifikasi': (context) => const NotificationPage(),
        '/detailprogres': (context) => const DetailProgressPage(),
        '/mou': (context) => const MoUPage(),
        '/detailmou': (context) => const DetailMoUPage(),
        '/pks': (context) => const PKSPage(),
        '/detailpks': (context) => const DetailPKSPage(),
      },
    );
  }
}
