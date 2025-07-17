import 'package:flutter/material.dart';
import 'package:sikermatsu/core/app_state.dart';
import 'package:sikermatsu/helpers/responsive.dart';
import 'package:sikermatsu/main_layout.dart';
import 'package:sikermatsu/services/pkl_service.dart';
import 'package:sikermatsu/models/pkl.dart';
import 'package:sikermatsu/styles/style.dart';

class PKLDashboardPage extends StatelessWidget {
  const PKLDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobileOrTablet =
        Responsive.isMobile(context) || Responsive.isTablet(context);

    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        return MainLayout(
          title: 'Dashboard Siswa PKL',
          isLoggedIn: isLoggedIn,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.white,
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
                            'Selamat Datang di Dashboard PKL!',
                            style: CustomStyle.headline1,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Halaman ini memberikan informasi pengajuan Praktek Kerja Lapangan (PKL). '
                            'Silakan gunakan menu di sebelah kiri untuk mengakses fitur yang tersedia.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
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
