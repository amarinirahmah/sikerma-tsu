import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikermatsu/core/app_state.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/guard/splash_screen.dart';
import 'pages/home/home.dart';
import 'pages/user/login.dart';
import 'pages/user/register.dart';
import 'pages/user/profil_saya.dart';
import 'pages/user/add_role.dart';
import 'pages/user/super_admin.dart';
import 'pages/mou/upload_mou.dart';
import 'pages/mou/daftar_mou.dart';
import 'pages/mou/detail_mou.dart';
import 'pages/pks/upload_pks.dart';
import 'pages/pks/daftar_pks.dart';
import 'pages/pks/detail_pks.dart';
import 'pages/pkl/upload_pkl.dart';
import 'pages/pkl/pengajuan_pkl.dart';
import 'pages/pkl/daftar_pkl.dart';
import 'pages/pkl/detail_pkl.dart';
import 'pages/progres/daftar_progres.dart';
import 'pages/progres/detail_progres.dart';
import 'pages/notif/daftar_notifikasi.dart';
import 'pages/dashboard/dashboard.dart';
import 'pages/dashboard/dashboard2.dart';
import 'pages/guard/access_denied_page.dart';
import 'styles/style.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Route publik yang bisa diakses siapa saja
    final publicRoutes = <String, Widget>{
      '/': HomePage(),
      '/login': const LoginPage(),
      '/register': const RegisterPage(),
      '/splash': const SplashScreen(),
      '/mou': const MoUPage(),
      '/pks': const PKSPage(),
      '/registerpkl': const RegisterPKLPage(),
    };

    // Route yang perlu proteksi role
    final protectedRoutes = <String, (List<String>, Widget)>{
      '/superadmin': (['admin'], const SuperAdminPage()),
      '/addrole': (['admin'], const AddRolePage()),
      '/dashboard': (['admin', 'user'], const AdminDashboardPage()),
      '/dashboard2': (['userpkl'], const PKLDashboardPage()),
      '/uploadmou': (['admin', 'user'], const UploadMoUPage()),
      '/uploadpks': (['admin', 'user'], const UploadPKSPage()),
      '/progres': (['admin', 'user'], const ProgressPage()),
      '/notifikasi': (['admin', 'user'], const NotificationPage()),
      '/detailmou': (['admin', 'user', 'userpkl'], const DetailMoUPage()),
      '/detailpks': (['admin', 'user', 'userpkl'], const DetailPKSPage()),
      '/uploadpkl': (['admin', 'user', 'userpkl'], const UploadPKLPage()),
      '/pkl': (['admin', 'user', 'userpkl'], const PKLPage()),
      '/detailpkl': (['admin', 'user', 'userpkl'], const DetailPKLPage()),
      '/profilsaya': (['admin', 'user', 'userpkl'], const MyProfilePage()),
    };

    return MaterialApp(
      title: 'Sikerma TSU',
      debugShowCheckedModeBanner: false,
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
      onGenerateInitialRoutes: (String initialRoute) {
        final currentPath = Uri.base.path;
        // print('Initial path from browser: $currentPath');

        return [
          MaterialPageRoute(
            builder: (_) => SplashScreen(initialPath: currentPath),
            settings: RouteSettings(name: currentPath),
          ),
        ];
      },
      onGenerateRoute: (settings) {
        final role =
            AppState.role.value.isEmpty ? 'guest' : AppState.role.value;
        final routeName = settings.name ?? '/';

        // 1. Route publik
        if (publicRoutes.containsKey(routeName)) {
          return MaterialPageRoute(
            builder: (_) => publicRoutes[routeName]!,
            settings: settings,
          );
        }

        // 2. Route proteksi role
        if (protectedRoutes.containsKey(routeName)) {
          final (allowedRoles, page) = protectedRoutes[routeName]!;
          if (allowedRoles.contains(role)) {
            return MaterialPageRoute(builder: (_) => page, settings: settings);
          } else {
            return MaterialPageRoute(
              builder: (_) => const AccessDeniedPage(),
              settings: settings,
            );
          }
        }

        // 3. Fallback jika route tidak ditemukan
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('404 - Halaman tidak ditemukan')),
              ),
          settings: settings,
        );
      },
    );
  }
}
