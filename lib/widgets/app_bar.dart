import 'package:flutter/material.dart';
import 'package:sikermatsu/pages/daftar_notifikasi.dart';
import 'package:sikermatsu/models/app_state.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDesktop;
  // final VoidCallback onMenuPressed;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String title;
  final List<Widget>? actions;
  final bool isLoggedIn;

  const CustomAppBar({
    super.key,
    required this.isDesktop,
    // required this.onMenuPressed,
    this.scaffoldKey,
    this.title = '',
    this.actions,
    this.isLoggedIn = false, //false
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final bool isHome = currentRoute == '/home';
    final bool showMenuIcon = isLoggedIn && !isHome;
    final bool showNotificationIcon = isLoggedIn && !isHome;

    return AppBar(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading:
          showMenuIcon
              ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  scaffoldKey?.currentState?.openDrawer();
                },
              )
              : null,

      title: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 32),
          const SizedBox(width: 12),
          if (!isLoggedIn) ...[
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Home'),
            ),
          ],
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/mou');
            },
            child: const Text('Daftar MoU'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/pks');
            },
            child: const Text('Daftar PKS'),
          ),
        ],

        // Text(
        //   title.isNotEmpty ? title : 'SIKERMA TSU',
        //   style: const TextStyle(fontSize: 20),
        // ),
      ),
      actions:
          actions ??
          [
            if (showNotificationIcon)
              IconButton(
                icon: const Icon(Icons.notifications),
                tooltip: 'Notifikasi',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/notifikasi');
                },
              ),

            // IconButton(
            //   icon: const Icon(Icons.person),
            //   tooltip: 'Logout',
            //   // onPressed: () {
            //   //   Navigator.pushReplacementNamed(context, '/login');
            //   // },
            //   onPressed: () {
            //     AppState.isLoggedIn.value = false;
            //     Navigator.pushNamedAndRemoveUntil(
            //       context,
            //       '/login',
            //       (route) => false,
            //     );
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: isLoggedIn ? 'Logout' : 'Login',
              onPressed: () {
                if (isLoggedIn) {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Konfirmasi Logout'),
                          content: const Text(
                            'Apakah Anda yakin ingin logout?',
                          ),
                          actions: [
                            TextButton(
                              onPressed:
                                  () => Navigator.pop(context), // Tutup dialog
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                AppState.isLoggedIn.value = false;
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/login',
                                  (route) => false,
                                );
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                  );
                } else {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
