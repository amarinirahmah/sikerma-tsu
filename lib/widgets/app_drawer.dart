import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.blue[800],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header logo/brand
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'SIKERMA TSU',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(color: Colors.white24),

          // Menu List
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(context, 'Dashboard', '/dashboard'),
                _buildMenuItem(context, 'Daftar MoU', '/mou'),
                _buildMenuItem(context, 'Upload MoU', '/uploadmou'),
                _buildMenuItem(context, 'Daftar PKS', '/pks'),
                _buildMenuItem(context, 'Upload PKS', '/uploadpks'),
                _buildMenuItem(context, 'Progres Kerja Sama', '/progres'),
                _buildMenuItem(context, 'Notifikasi', '/notifikasi'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      hoverColor: Colors.blue[700],
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
