import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/models/app_state.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        return MainLayout(
          title: 'Dashboard',
          isLoggedIn: isLoggedIn,
          child: Center(child: Text('Selamat datang di Dashboard!')),
        );
      },
    );
  }
}
