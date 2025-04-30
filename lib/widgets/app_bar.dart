import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDesktop;
  final VoidCallback onMenuPressed;

  const CustomAppBar({
    super.key,
    required this.isDesktop,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue[800],
      automaticallyImplyLeading:
          !isDesktop, // Automatically hide leading in desktop mode
      leading:
          isDesktop
              ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: onMenuPressed, // OnPressed for desktop
              )
              : null, // On mobile, menu button will open the drawer
      title: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 32),
          const SizedBox(width: 12),
          const Text('SIKERMA TSU', style: TextStyle(fontSize: 20)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Preferred size for AppBar
}
