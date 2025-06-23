import 'package:flutter/material.dart';
import 'package:sikermatsu/core/app_state.dart';
import 'package:sikermatsu/helpers/responsive.dart';
import 'package:sikermatsu/main_layout.dart';
import 'package:sikermatsu/services/mou_service.dart';
import 'package:sikermatsu/services/pks_service.dart';
import 'package:sikermatsu/services/pkl_service.dart';
import 'package:sikermatsu/styles/style.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  Future<Map<String, int>> fetchCounts() async {
    final mouList = await MouService.getAllMou();
    final pksList = await PksService.getAllPks();
    final pklList = await PklService.getAllPkl();
    return {
      'mou': mouList.length,
      'pks': pksList.length,
      'pkl': pklList.length,
    };
  }

  final List<_StepData> steps = const [
    _StepData(
      'Login ke Sistem',
      'User login untuk mengakses fitur dan data dalam sistem.',
      Icons.person,
      Colors.green,
    ),
    _StepData(
      'Registrasi oleh Admin',
      'Admin mendaftarkan user agar dapat mengakses dokumen.',
      Icons.admin_panel_settings,
      Colors.orange,
    ),
    _StepData(
      'Input Data Dokumen',
      'User atau admin menginput data yang dibutuhkan untuk dokumen.',
      Icons.edit_document,
      Colors.teal,
    ),
    _StepData(
      'Review Draft Dokumen',
      'User atau admin melakukan pengecekan dan koreksi terhadap draft dokumen.',
      Icons.rate_review,
      Colors.deepPurple,
    ),
    _StepData(
      'Finalisasi Draft',
      'Dokumen telah final dan siap untuk ditandatangani.',
      Icons.check_circle_outline,
      Colors.indigo,
    ),
    _StepData(
      'Penandatanganan dokumen',
      'Dokumen ditandatangani oleh pihak-pihak yang terkait.',
      Icons.edit_note,
      Colors.redAccent,
    ),
    _StepData(
      'Dokumen Selesai',
      'Dokumen selesai diproses dan dapat diunduh oleh admin atau user.',
      Icons.archive,
      Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobileOrTablet =
        Responsive.isMobile(context) || Responsive.isTablet(context);

    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        return MainLayout(
          title: 'Dashboard Admin',
          isLoggedIn: isLoggedIn,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: FutureBuilder<Map<String, int>>(
                  future: fetchCounts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Gagal memuat data: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    final counts = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Statistik Kerja Sama',
                            style: CustomStyle.headline1,
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              _StatCard(
                                title: 'Jumlah MoU',
                                count: counts['mou']!,
                                icon: Icons.assignment,
                                color: Colors.teal,
                              ),
                              _StatCard(
                                title: 'Jumlah PKS',
                                count: counts['pks']!,
                                icon: Icons.description,
                                color: Colors.orange,
                              ),
                              _StatCard(
                                title: 'Jumlah PKL',
                                count: counts['pkl']!,
                                icon: Icons.school,
                                color: Colors.indigo,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Card(
                            color: Colors.grey.shade100,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Alur Kerja Sama',
                                    style: CustomStyle.headline1,
                                  ),
                                  const SizedBox(height: 24),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                        steps.length * 2 - 1,
                                        (index) {
                                          if (index.isEven) {
                                            final step = steps[index ~/ 2];
                                            return _buildStepItem(step);
                                          } else {
                                            return Container(
                                              width: 40,
                                              height: 4,
                                              color: Colors.grey.shade300,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 40,
                                                  ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 800;

    return SizedBox(
      width: isNarrow ? screenWidth / 2 - 32 : 220,
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 12),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _StepData(this.title, this.description, this.icon, this.color);
}

Widget _buildStepItem(_StepData step) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Column(
      children: [
        CircleAvatar(
          backgroundColor: step.color,
          radius: 28,
          child: Icon(step.icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 160,
          child: Text(
            step.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 180,
          child: Text(
            step.description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
      ],
    ),
  );
}
