import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 250,
        color: Colors.teal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(
                    context,
                    'Dashboard',
                    '/dashboard',
                    icon: Icons.dashboard,
                  ),
                  _buildMenuItem(
                    context,
                    'Daftar MoU',
                    '/mou',
                    icon: Icons.description,
                  ),
                  _buildMenuItem(
                    context,
                    'Upload MoU',
                    '/uploadmou',
                    icon: Icons.upload_file,
                  ),
                  _buildMenuItem(
                    context,
                    'Daftar PKS',
                    '/pks',
                    icon: Icons.library_books,
                  ),
                  _buildMenuItem(
                    context,
                    'Upload PKS',
                    '/uploadpks',
                    icon: Icons.drive_folder_upload,
                  ),
                  _buildMenuItem(
                    context,
                    'Progres Kerja Sama',
                    '/progres',
                    icon: Icons.timeline,
                  ),
                  // _buildMenuItem(
                  //   context,
                  //   'Notifikasi',
                  //   '/notifikasi',
                  //   icon: Icons.notifications,
                  // ),
                  _buildMenuItem(
                    context,
                    'Pengajuan PKL',
                    '/pkl',
                    icon: Icons.work,
                  ),
                  _buildMenuItem(
                    context,
                    'Admin',
                    '/superadmin',
                    icon: Icons.accessibility,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    String route, {
    IconData icon = Icons.circle,
  }) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == route;

    return Container(
      decoration:
          isSelected
              ? BoxDecoration(
                color: Colors.amber.shade700.withOpacity(0.3),
                border: const Border(
                  left: BorderSide(color: Colors.white, width: 4),
                ),
              )
              : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white70,
          size: 20,
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        selected: isSelected,
        selectedTileColor: Colors.transparent,
        hoverColor: Colors.amber.shade300.withOpacity(0.2),
        onTap: () {
          if (!isSelected) {
            Navigator.pop(context);
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}
