import 'package:flutter/material.dart';
import 'package:sikermatsu/pages/daftar_notifikasi.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDesktop;
  final VoidCallback onMenuPressed;
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.isDesktop,
    required this.onMenuPressed,
    this.title = '',
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: !isDesktop,
      leading:
          isDesktop
              ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: onMenuPressed,
              )
              : null,
      title: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 32),
          const SizedBox(width: 12),
          // Text(
          //   title.isNotEmpty ? title : 'SIKERMA TSU',
          //   style: const TextStyle(fontSize: 20),
          // ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/mou');
            },
            child: const Text('Daftar MoU'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/pks');
            },
            child: const Text('Daftar PKS'),
          ),
        ],
      ),
      actions:
          actions ??
          [
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
