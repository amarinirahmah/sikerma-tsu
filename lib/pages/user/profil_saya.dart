import 'package:flutter/material.dart';
import 'package:sikermatsu/core/app_state.dart';
import 'package:sikermatsu/main_layout.dart';
import 'package:sikermatsu/styles/style.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        final name = AppState.name.value ?? 'Tidak tersedia';
        final role = AppState.role.value;
        final token = AppState.token.value ?? 'Tidak tersedia';
        final email = AppState.email.value ?? 'Tidak tersedia';

        return MainLayout(
          title: 'Profil Saya',
          isLoggedIn: isLoggedIn,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Pengguna',
                          style: CustomStyle.headline1,
                        ),
                        const SizedBox(height: 16),
                        InfoRow(title: 'Nama', value: name),
                        InfoRow(title: 'Email', value: email),
                        InfoRow(title: 'Role', value: role),
                        const SizedBox(height: 16),
                        const Text(
                          'Token',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          token.length > 40
                              ? '${token.substring(0, 40)}...'
                              : token,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text('$title:')),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
