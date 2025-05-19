import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/main_layout.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/widgets/icon_card.dart';
import 'package:sikermatsu/widgets/bar_chart.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  bool isLoading = true;

  int jumlahMoU = 0;
  int jumlahPKS = 0;
  int jumlahPengajuanPKL = 0;
  int totalMitra = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      jumlahMoU = 12;
      jumlahPKS = 25;
      jumlahPengajuanPKL = 7;
      totalMitra = 5;
      isLoading = false;
    });
  }

  Map<String, Map<String, int>> dataChartPerTahun = {
    '2021': {'MoU': 3, 'PKS': 2},
    '2022': {'MoU': 5, 'PKS': 4},
    '2023': {'MoU': 6, 'PKS': 5},
    '2024': {'MoU': 8, 'PKS': 7},
  };

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        return MainLayout(
          title: 'Dashboard',
          isLoggedIn: isLoggedIn,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 3,
                                  children: [
                                    DashboardStatCard(
                                      title: 'Jumlah MoU',
                                      count: jumlahMoU,
                                      icon: Icons.description,
                                      color: Colors.blue,
                                    ),
                                    DashboardStatCard(
                                      title: 'Jumlah PKS',
                                      count: jumlahPKS,
                                      icon: Icons.work_outline,
                                      color: Colors.green,
                                    ),
                                    DashboardStatCard(
                                      title: 'Pengajuan Siswa PKL',
                                      count: jumlahPengajuanPKL,
                                      icon: Icons.assignment,
                                      color: Colors.orange,
                                    ),
                                    DashboardStatCard(
                                      title: 'Total Mitra',
                                      count: totalMitra,
                                      icon: Icons.people,
                                      color: Colors.purple,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),

                                const SizedBox(height: 16),
                                DashboardBarChart(
                                  dataPerYear: dataChartPerTahun,
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
