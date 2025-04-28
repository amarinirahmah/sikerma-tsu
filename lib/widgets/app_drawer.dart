import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            title: const Text('Data MoU'),
            onTap: () {
              Navigator.pushNamed(context, '/mou');
            },
          ),
          ListTile(
            title: const Text('Data PKS'),
            onTap: () {
              Navigator.pushNamed(context, '/pks');
            },
          ),
          ListTile(
            title: const Text('Progres Kerja Sama'),
            onTap: () {
              Navigator.pushNamed(context, '/progres');
            },
          ),
          ListTile(
            title: const Text('Notifikasi'),
            onTap: () {
              Navigator.pushNamed(context, '/notifikasi');
            },
          ),
        ],
      ),
    );
  }
}
