import 'package:flutter/material.dart';

class AccessDeniedPage extends StatelessWidget {
  const AccessDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Akses Ditolak')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.block, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Maaf, Anda tidak memiliki akses ke halaman ini.',
                // 'Halaman tidak ditemukan',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              // const SizedBox(height: 24),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pushReplacementNamed(context, '/dashboard');
              //   },
              //   child: const Text('Kembali ke Dashboard'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
