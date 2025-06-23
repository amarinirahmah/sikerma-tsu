import 'package:flutter/material.dart';
import 'package:sikermatsu/pages/user/profil_saya.dart';
import 'pages/user/login.dart';
import 'pages/user/super_admin.dart';
import 'pages/dashboard/dashboard.dart';
import 'pages/mou/upload_mou.dart';
import 'pages/pks/upload_pks.dart';
import 'pages/progres/daftar_progres.dart';
import 'pages/notif/daftar_notifikasi.dart';
import 'pages/progres/detail_progres.dart';
import 'pages/mou/daftar_mou.dart';
import 'pages/mou/detail_mou.dart';
import 'pages/pks/daftar_pks.dart';
import 'pages/pks/detail_pks.dart';
import 'pages/user/register.dart';
import 'pages/user/add_role.dart';
import 'pages/pkl/pengajuan_pkl.dart';
import 'pages/pkl/upload_pkl.dart';
import 'pages/pkl/detail_pkl.dart';
import 'pages/home/home.dart';
import 'pages/pkl/daftar_pkl.dart';
import 'styles/style.dart';
import 'core/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/dashboard/dashboard2.dart';
import 'pages/guard/access_denied_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'pages/guard/splash_screen.dart';

void main() async {
  // Future<void> loadLoginStatus() async {
  usePathUrlStrategy();
  await initializeDateFormatting('id', null);
  WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();
  // final token = prefs.getString('token');
  // final role = prefs.getString('role') ?? 'guest';
  // final name = prefs.getString('name') ?? '';
  // final email = prefs.getString('email') ?? '';

  // print('Main: token = $token, role = $role, name= $name');

  // if (token != null && token.isNotEmpty) {
  //   AppState.loginAs(role, token, name, email);
  //   print(
  //     'Main: loginAs dipanggil dengan role=$role dan token=$token, name=$name',
  //   );
  // } else {
  //   AppState.logout();
  //   print('Main: logout dipanggil, set role=guest dan token=null, name=null');
  // }

  runApp(const MyApp());
}

class ProtectedRoute {
  final List<String> allowedRoles;
  final Widget page;

  ProtectedRoute(this.allowedRoles, this.page);
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
      // initialRoute: '/splash',
      onGenerateRoute: (settings) {
        // final role = AppState.role.value;
        final role =
            AppState.role.value.isEmpty ? 'guest' : AppState.role.value;
        if (role == 'guest') {
          return MaterialPageRoute(
            builder: (_) => const SplashScreen(),
            settings: settings,
          );
        }

        // Route guard
        Map<String, (List<String> allowedRoles, Widget page)>
        protectedRoutes = {
          '/superadmin': (['admin'], const SuperAdminPage()),
          '/addrole': (['admin'], const AddRolePage()),
          '/dashboard': (['admin', 'user'], const AdminDashboardPage()),
          '/dashboard2': (['userpkl'], const PKLDashboardPage()),
          '/uploadmou': (['admin', 'user'], const UploadMoUPage()),
          '/uploadpks': (['admin', 'user'], const UploadPKSPage()),
          '/progres': (['admin', 'user'], const ProgressPage()),
          '/notifikasi': (['admin', 'user'], const NotificationPage()),
          // '/mou': (['admin', 'user', 'userpkl'], const MoUPage()),
          '/detailmou': (['admin', 'user', 'userpkl'], const DetailMoUPage()),
          // '/pks': (['admin', 'user', 'userpkl'], const PKSPage()),
          '/detailpks': (['admin', 'user', 'userpkl'], const DetailPKSPage()),
          '/uploadpkl': (['admin', 'user', 'userpkl'], const UploadPKLPage()),
          '/pkl': (['admin', 'user', 'userpkl'], const PKLPage()),
          '/detailpkl': (['admin', 'user', 'userpkl'], const DetailPKLPage()),
          '/profilsaya': (['admin', 'user', 'userpkl'], const MyProfilePage()),
        };

        // Halaman publik
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => HomePage(),
              settings: settings,
            );
          case '/splash':
            return MaterialPageRoute(
              builder: (_) => SplashScreen(),
              settings: settings,
            );
          case '/login':
            return MaterialPageRoute(
              builder: (_) => const LoginPage(),
              settings: settings,
            );
          case '/register':
            return MaterialPageRoute(
              builder: (_) => const RegisterPage(),
              settings: settings,
            );
          case '/mou':
            return MaterialPageRoute(
              builder: (_) => const MoUPage(),
              settings: settings,
            );
          case '/pks':
            return MaterialPageRoute(
              builder: (_) => const PKSPage(),
              settings: settings,
            );
          case '/registerpkl':
            if (role == 'guest' || role == 'userpkl') {
              return MaterialPageRoute(
                builder: (_) => const RegisterPKLPage(),
                settings: settings,
              );
            } else {
              return MaterialPageRoute(
                builder: (_) => const AccessDeniedPage(),
                settings: settings,
              );
            }

          // case '/registerpkl':
          //   return MaterialPageRoute(
          //     builder: (_) => const RegisterPKLPage(),
          //     settings: settings,
          //   );
        }

        // Cek apakah route dilindungi
        if (protectedRoutes.containsKey(settings.name)) {
          final (allowedRoles, page) = protectedRoutes[settings.name]!;
          if (!allowedRoles.contains(role)) {
            return MaterialPageRoute(
              builder: (_) => const AccessDeniedPage(),
              settings: settings,
            );
          }
          return MaterialPageRoute(builder: (_) => page, settings: settings);
        }

        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('404 - Halaman tidak ditemukan')),
              ),
          settings: settings,
        );
      },

      onGenerateInitialRoutes: (String initialRoute) {
        // Tangkap path dari URL
        final currentPath = Uri.base.path;
        print('Initial path from browser: $currentPath');

        return [
          MaterialPageRoute(
            builder: (_) => SplashScreen(initialPath: currentPath),
            settings: RouteSettings(name: currentPath),
          ),
        ];
      },
      // routes: {
      //   '/': (context) => HomePage(),
      //   '/login': (context) => const LoginPage(),
      //   '/register': (context) => const RegisterPage(),
      // '/superadmin': (context) => const SuperAdminPage(),
      // '/addrole': (context) => const AddRolePage(),
      // '/dashboard': (context) => const AdminDashboardPage(),
      // '/dashboard2': (context) => const PKLDashboardPage(),
      // '/uploadmou': (context) => const UploadMoUPage(),
      // '/uploadpks': (context) => const UploadPKSPage(),
      // '/progres': (context) => const ProgressPage(),
      // '/notifikasi': (context) => const NotificationPage(),
      // // '/detailprogres': (context) => const DetailProgressPage(),
      // '/mou': (context) => const MoUPage(),
      // '/detailmou': (context) => const DetailMoUPage(),
      // '/pks': (context) => const PKSPage(),
      // '/detailpks': (context) => const DetailPKSPage(),
      // '/uploadpkl': (context) => const UploadPKLPage(),
      // '/pkl': (context) => const PKLPage(),
      // '/detailpkl': (context) => const DetailPKLPage(),
      // },
    );
  }
}
