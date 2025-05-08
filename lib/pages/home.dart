// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isDesktop: false, onMenuPressed: () {}),
    );
  }
}
