import 'package:flutter/material.dart';
import 'package:sikermatsu/pages/daftar_notifikasi.dart';

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
                  final isOpen =
                      scaffoldKey?.currentState?.isDrawerOpen ?? false;
                  if (isOpen) {
                    Navigator.of(scaffoldKey!.currentContext!).pop();
                  } else {
                    scaffoldKey?.currentState?.openDrawer();
                  }
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
                Navigator.pop(context, '/home');
              },
              child: const Text('Home'),
            ),
          ],
          TextButton(
            onPressed: () {
              Navigator.pop(context, '/mou');
            },
            child: const Text('Daftar MoU'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, '/pks');
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

            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Logout',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
