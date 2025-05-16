import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/super_admin.dart';
import 'pages/dashboard.dart';
import 'pages/upload_mou.dart';
import 'pages/upload_pks.dart';
import 'pages/daftar_progres.dart';
import 'pages/daftar_notifikasi.dart';
import 'pages/detail_progres.dart';
import 'pages/daftar_mou.dart';
import 'pages/detail_mou.dart';
import 'pages/daftar_pks.dart';
import 'pages/detail_pks.dart';
import 'pages/register.dart';
import 'pages/add_role.dart';
import 'pages/pengajuan_pkl.dart';
import 'pages/upload_pkl.dart';
import 'pages/detail_pkl.dart';
import 'pages/home.dart';
import 'styles/style.dart';

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
      // theme: ThemeData(primarySwatch: Colors.teal),
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(secondary: CustomStyle.accentColor),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: CustomStyle.baseButtonStyle,
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/superadmin': (context) => const SuperAdminPage(),
        '/addrole': (context) => const AddRolePage(),
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
        '/uploadpkl': (context) => const UploadPKLPage(),
        '/pkl': (context) => const PKLPage(),
        '/detailpkl': (context) => const DetailPKLPage(),
      },
    );
  }
}
