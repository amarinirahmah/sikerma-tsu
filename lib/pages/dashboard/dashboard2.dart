import 'package:flutter/material.dart';
import 'package:sikermatsu/main_layout.dart';
import 'package:sikermatsu/states/app_state.dart';
import 'package:sikermatsu/helpers/responsive.dart';
import 'package:sikermatsu/styles/style.dart';

class PKLDashboardPage extends StatefulWidget {
  const PKLDashboardPage({super.key});

  @override
  State<PKLDashboardPage> createState() => _PKLDashboardPageState();
}

class _PKLDashboardPageState extends State<PKLDashboardPage> {
  bool isLoading = true;

  final List<_StepData> steps = [
    _StepData(
      'Login / Register Akun',
      'Siswa login atau melakukan registrasi ke dalam sistem.',
      Icons.person,
      Colors.green,
    ),
    _StepData(
      'Registrasi oleh Admin',
      'Admin dapat membantu melakukan registrasi akun siswa.',
      Icons.admin_panel_settings,
      Colors.orange,
    ),
    _StepData(
      'Pengajuan PKL',
      'Siswa mengajukan permohonan PKL melalui sistem.',
      Icons.upload_file,
      Colors.teal,
    ),
    _StepData(
      'Proses Dokumen',
      'Dokumen kerjasama PKL diproses oleh admin atau user.',
      Icons.description,
      Colors.deepPurple,
    ),
    _StepData(
      'Pemantauan Status',
      'Siswa memantau status pengajuan PKL secara berkala.',
      Icons.school,
      Colors.indigo,
    ),
    _StepData(
      'Verifikasi Pengajuan',
      'Admin memverifikasi pengajuan PKL apakah disetujui atau ditolak',
      Icons.verified_user,
      Colors.blue,
    ),

    _StepData(
      'Penerimaan Siswa PKL',
      'Informasi penerimaan siswa PKL ditampilkan melalui sistem.',
      Icons.assignment_turned_in,
      Colors.grey,
    ),
  ];

  final ScrollController _scrollController = ScrollController();
  bool showScrollHint = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 10) {
      if (showScrollHint) setState(() => showScrollHint = false);
    } else {
      if (!showScrollHint) setState(() => showScrollHint = true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobileOrTablet =
        Responsive.isMobile(context) || Responsive.isTablet(context);

    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        return MainLayout(
          title: 'Dashboard PKL',
          isLoggedIn: isLoggedIn,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isMobileOrTablet ? double.infinity : 1000,
                  ),
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                24,
                                24,
                                24,
                                isMobileOrTablet ? 48 : 24,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Alur Pengajuan PKL',
                                    style: CustomStyle.headline1,
                                  ),
                                  const SizedBox(height: 48),
                                  if (isMobileOrTablet)
                                    SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children:
                                            steps
                                                .map(
                                                  (step) => Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                    child: _buildStepItem(
                                                      step,
                                                      true,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    )
                                  else
                                    Column(
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          controller: _scrollController,
                                          child: Row(
                                            children: List.generate(
                                              steps.length * 2 - 1,
                                              (index) {
                                                if (index.isEven) {
                                                  final step =
                                                      steps[index ~/ 2];
                                                  return _buildStepItem(
                                                    step,
                                                    false,
                                                  );
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
                                        const SizedBox(height: 24),
                                        AnimatedOpacity(
                                          opacity: showScrollHint ? 1.0 : 0.0,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child: Text(
                                            'Geser ke kanan untuk melihat semua langkah...',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
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

  Widget _buildStepItem(_StepData step, bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: step.color,
          radius: 28,
          child: Icon(step.icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: isMobile ? double.infinity : 160,
          child: Text(
            step.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: isMobile ? double.infinity : 180,
          child: Text(
            step.description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }
}

class _StepData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  _StepData(this.title, this.description, this.icon, this.color);
}
