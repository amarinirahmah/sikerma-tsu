import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Dashboard',
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
      child: Center(
        child: Text(
          'Isi Halaman Dashboard',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
