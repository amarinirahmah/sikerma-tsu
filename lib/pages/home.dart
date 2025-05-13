import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isDesktop: false),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            color: Colors.black.withOpacity(0.4),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Selamat Datang di SiKERMA TSU!',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // Footer
                Container(
                  color: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Tentang Kami',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'SiKERMA TSU adalah sistem informasi yang membantu proses kerja sama dan pengajuan PKL antara sekolah dan instansi secara efisien dan modern.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 24),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kontak',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap:
                                  () => _launchURL(
                                    'https://maps.google.com/?q=Jl. Pendidikan No. 123, Bandung',
                                  ),
                              child: Row(
                                children: const [
                                  Icon(
                                    FontAwesomeIcons.locationDot,
                                    color: Colors.white70,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Jl. Pendidikan No. 123, Bandung',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap:
                                  () => _launchURL('mailto:info@sikermatsu.id'),
                              child: Row(
                                children: const [
                                  Icon(Icons.email, color: Colors.white70),
                                  SizedBox(width: 8),
                                  Text(
                                    'info@sikermatsu.id',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _launchURL('tel:+6281234567890'),
                              child: Row(
                                children: const [
                                  Icon(Icons.phone, color: Colors.white70),
                                  SizedBox(width: 8),
                                  Text(
                                    '+62 812-3456-7890',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                IconButton(
                                  onPressed:
                                      () => _launchURL(
                                        'https://instagram.com/sikermatsu',
                                      ),
                                  icon: const Icon(
                                    FontAwesomeIcons.instagram,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed:
                                      () => _launchURL(
                                        'https://youtube.com/@sikermatsu',
                                      ),
                                  icon: const Icon(
                                    FontAwesomeIcons.youtube,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed:
                                      () => _launchURL(
                                        'https://tiktok.com/@sikermatsu',
                                      ),
                                  icon: const Icon(
                                    FontAwesomeIcons.tiktok,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
