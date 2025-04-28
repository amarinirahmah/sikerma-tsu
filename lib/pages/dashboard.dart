import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text(
          'Selamat datang di Sikerma TSU!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
