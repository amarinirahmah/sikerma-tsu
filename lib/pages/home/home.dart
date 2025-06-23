import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sikermatsu/styles/style.dart';
import 'package:sikermatsu/widgets/app_bar.dart';
import 'package:sikermatsu/helpers/responsive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sikermatsu/helpers/animation.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  final List<String> _imageList = [
    'assets/images/image-placeholder.jpg',
    'assets/images/image-placeholder.jpg',
    'assets/images/image-placeholder.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        _currentPage = (_currentPage + 1) % _imageList.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
      _startAutoSlide();
    });
  }

  Widget _buildGalleryCarousel() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Galeri Kegiatan',
                style: CustomStyle.headline1,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _imageList.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(_imageList[index]),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _imageList.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.teal : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isDesktop: false),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildHeaderWithBackground(context),
            const SizedBox(height: 20),
            FadeInOnScroll(
              scrollController: _scrollController,
              triggerOffset: 150,
              child: _buildIntroSection(context),
            ),
            const SizedBox(height: 20),
            FadeInOnScroll(
              scrollController: _scrollController,
              triggerOffset: 250,
              child: _buildVisiMisiSection(),
            ),
            const SizedBox(height: 20),

            FadeInOnScroll(
              scrollController: _scrollController,
              triggerOffset: 200,
              child: _buildFeatureCards(),
            ),
            const SizedBox(height: 20),

            FadeInOnScroll(
              scrollController: _scrollController,
              triggerOffset: 250,
              child: _buildGalleryCarousel(),
            ),
            const SizedBox(height: 20),

            FadeInOnScroll(
              scrollController: _scrollController,
              triggerOffset: 250,
              child: _buildFAQSection(),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWithBackground(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 550,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        // color: Colors.black.withOpacity(0.65),
        color: Colors.grey.shade900.withOpacity(0.45),
        child: Center(child: _buildWelcomeSection(context)),
      ),
    );
  }

  // Widget _buildHeaderWithBackground(BuildContext context) {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: 550,
  //     child: Stack(
  //       fit: StackFit.expand,
  //       children: [
  //         // Background Image
  //         Image.asset('assets/images/background.jpg', fit: BoxFit.cover),

  //         // Gradient Overlay
  //         Container(
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               begin: Alignment.topCenter,
  //               end: Alignment.bottomCenter,
  //               colors: [
  //                 Colors.grey.shade900.withOpacity(0.45),
  //                 Colors.grey.shade800.withOpacity(0.25),
  //                 Colors.grey.shade700.withOpacity(0.15),
  //                 Colors.transparent,
  //               ],
  //             ),
  //           ),
  //         ),

  //         // Welcome Section
  //         Center(child: _buildWelcomeSection(context)),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildWelcomeSection(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    double titleFontSize = isMobile ? 24 : (isTablet ? 32 : 42);
    double subtitleFontSize = isMobile ? 14 : (isTablet ? 18 : 22);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Selamat Datang di Sistem Informasi Kerja Sama\nTiga Serangkai University!',
            style: CustomStyle.title.copyWith(fontSize: titleFontSize),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Text(
            '"Kolaborasi Nyata, Masa Depan Cerah!"',
            // '"Jembatan Kolaborasi untuk Mewujudkan Inovasi, Keunggulan, dan Pertumbuhan Bersama\nSecara Berkelanjutan dalam Dunia Pendidikan dan Kemitraan"',
            style: CustomStyle.subtitle.copyWith(fontSize: subtitleFontSize),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVisiMisiSection() {
    return Container(
      // color: Colors.teal[50],
      color: Colors.grey[100],
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text('Visi dan Misi', style: CustomStyle.headline1),
                ),
                SizedBox(height: 24),
                Text('Visi', style: CustomStyle.headline4),
                SizedBox(height: 8),
                Text(
                  'Menjadi pusat informasi kerja sama pendidikan yang profesional, modern, dan terpercaya.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                Text('Misi', style: CustomStyle.headline4),
                SizedBox(height: 8),
                Text(
                  '1. Memfasilitasi kerja sama institusional dengan sistem efisien.\n'
                  '2. Meningkatkan transparansi dan akuntabilitas.\n'
                  '3. Mendukung program PKL dan pengembangan SDM.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text('Pertanyaan Umum (FAQ)', style: CustomStyle.headline1),
          const SizedBox(height: 20),
          _faqItem(
            'Apa itu SiKERMA TSU?',
            'SiKERMA TSU adalah sistem informasi kerja sama institusi di Tiga Serangkai University, termasuk pengajuan PKL dan pencatatan MoU/PKS.',
          ),
          _faqItem(
            'Siapa saja yang bisa mengakses platform ini?',
            'Admin institusi, mitra kerja sama, serta siswa yang mengajukan PKL dapat menggunakan platform ini sesuai hak akses masing-masing.',
          ),
          _faqItem(
            'Bagaimana cara mengajukan PKL?',
            'Siswa dapat mengisi formulir pengajuan PKL secara online melalui menu yang telah disediakan setelah login.',
          ),
          _faqItem(
            'Apakah dokumen kerja sama dapat diunduh?',
            'Ya. Pengguna yang memiliki hak akses dapat mengunggah dan mengunduh dokumen MoU atau PKS.',
          ),
        ],
      ),
    );
  }

  Widget _faqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
            top: 16,
          ),
          child: Text(answer),
        ),
      ],
    );
  }

  // Widget _buildMottoSection() {
  //   return Container(
  //     color: Colors.teal.shade600,
  //     width: double.infinity,
  //     padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
  //     child: const Text(
  //       '"Kolaborasi Cerdas, Masa Depan Berkualitas"',
  //       style: TextStyle(
  //         fontSize: 20,
  //         fontStyle: FontStyle.italic,
  //         color: Colors.white,
  //       ),
  //       textAlign: TextAlign.center,
  //     ),
  //   );
  // }

  Widget _buildIntroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Apa itu SiKERMA TSU?',
            style: CustomStyle.headline1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const Text(
              'SiKERMA TSU (Sistem Informasi Kerja Sama) adalah sebuah platform digital terintegrasi yang dikembangkan oleh Unit Bursa Kerja Khusus (BKK) di Tiga Serangkai University (TSU). '
              'Platform ini dirancang khusus untuk memfasilitasi berbagai bentuk kerja sama antara lembaga pendidikan, khususnya sekolah-sekolah kejuruan, dengan mitra industri atau institusi terkait. '
              'Melalui SiKERMA TSU, proses administrasi dan komunikasi dalam pengajuan kerja sama, penempatan siswa PKL (Praktik Kerja Lapangan), hingga pelacakan progres dan pelaporan kegiatan dapat dilakukan secara cepat, transparan, dan terdokumentasi dengan baik.\n\n'
              'Inisiatif ini bertujuan untuk menjawab tantangan birokrasi dan kurangnya sistem pendataan dalam hubungan kerja sama pendidikan. Dengan fitur seperti pengajuan PKL online, daftar mitra terpercaya, sistem tracking kerja sama, dan dokumentasi MoU/PKS yang terorganisir, '
              'SiKERMA TSU menjadi solusi praktis yang menjembatani dunia pendidikan dan dunia industri. Kami percaya bahwa kolaborasi yang efisien akan menciptakan ekosistem pembelajaran yang lebih relevan, profesional, dan siap kerja.',
              style: TextStyle(fontSize: 16, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Text(
            'Fitur Unggulan',
            style: CustomStyle.headline1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _featureCard(
                Icons.file_open,
                'Manajemen Data Mitra Kerja Sama',
                'Pendataan mitra institusi secara terpusat, termasuk status MoU/PKS dan masa berlaku.',
              ),
              _featureCard(
                Icons.timeline,
                'Pemantauan Kerja Sama',
                'Pencatatan dan pemantauan progres kerja sama berdasarkan aktivitas atau tahapan yang dilakukan.',
              ),
              _featureCard(
                Icons.work,
                'Pengajuan PKL Terintegrasi',
                'Sistem pengajuan PKL secara online oleh siswa, dilengkapi dengan pelacakan status penerimaan.',
              ),
              _featureCard(
                Icons.notifications,
                'Notifikasi Masa Berlaku Dokumen',
                'Peringatan otomatis tentang masa berlaku dokumen kerja sama agar proses tetap berjalan lancar.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featureCard(IconData icon, String title, String subtitle) {
    return SizedBox(
      width: 220,
      height: 280,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 48, color: Colors.teal),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildGalleryCarousel() {
  //   final List<String> imageList = [
  //     'assets/images/image-placeholder.jpg',
  //     'assets/images/image-placeholder.jpg',
  //     'assets/images/image-placeholder.jpg',
  //   ];

  //   PageController _pageController = PageController(viewportFraction: 0.8);

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16.0),
  //         child: Text(
  //           'Galeri Kegiatan',
  //           style: CustomStyle.headline1,
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       SizedBox(
  //         height: 200,
  //         child: PageView.builder(
  //           controller: _pageController,
  //           itemCount: imageList.length,
  //           itemBuilder: (context, index) {
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(12),
  //                 child: Image.asset(imageList[index], fit: BoxFit.cover),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFooter(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          child:
              isMobile
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _footerSectionAbout(),
                      const SizedBox(height: 24),
                      _footerSectionHours(),
                      const SizedBox(height: 24),
                      _footerSectionContact(),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _footerSectionAbout(),
                        ),
                      ),

                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _footerSectionHours(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _footerSectionContact(),
                        ),
                      ),
                    ],
                  ),
        ),
        Container(
          color: Colors.teal.shade700,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: const Center(
            child: Text(
              '© 2025 SiKERMA TSU. All rights reserved.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _footerSectionAbout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/logo-white.png', height: 48),
        const SizedBox(height: 12),
        const Text(
          'Tentang Kami',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'SiKERMA TSU adalah sistem informasi yang mempermudah proses kerja sama dan pengajuan PKL antara sekolah dan instansi. Dengan tampilan yang modern dan fitur yang terintegrasi, SiKERMA membantu proses administrasi menjadi lebih cepat, praktis, dan transparan.',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Widget _footerSectionAbout() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: const [
  //       SizedBox(height: 8),
  //       Text(
  //         'Tentang Kami',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       SizedBox(height: 12),
  //       Text(
  //         'SiKERMA TSU adalah sistem informasi yang mempermudah proses kerja sama dan pengajuan PKL antara sekolah dan instansi. '
  //         'Dengan tampilan yang modern dan fitur yang terintegrasi, SiKERMA membantu proses administrasi menjadi lebih cepat, praktis, dan transparan.',
  //         style: TextStyle(color: Colors.white70),
  //       ),
  //     ],
  //   );
  // }

  Widget _footerSectionContact() {
    return Column(
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
        _footerContactRow(
          icon: FontAwesomeIcons.house,
          label:
              'Jl. K.H Samanhudi No.84-86, Purwosari, Kec. Laweyan, Kota Surakarta, Jawa Tengah 57149, Indonesia',
          url: 'https://maps.app.goo.gl/HDBASDWhmfo3K5ME9',
        ),
        const SizedBox(height: 8),
        _footerContactRow(
          icon: FontAwesomeIcons.whatsapp,
          label: '0895705354767',
          url: 'https://wa.me/62895705354767',
        ),
        const SizedBox(height: 8),
        _footerContactRow(
          icon: Icons.email,
          label: 'info@sikermatsu.id',
          url: 'mailto:info@sikermatsu.id',
        ),
        const SizedBox(height: 8),
        _footerContactRow(
          icon: Icons.phone,
          label: '+62 271 716500',
          url: 'tel:+62271716500',
        ),
      ],
    );
  }

  Widget _footerSectionHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jam Operasional',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Senin - Jumat: 08.00-19.00\nSabtu: 08.00-13.00',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 20),
        const Text(
          'Ikuti Kami',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed:
                  () => _launchURL(
                    'https://www.instagram.com/tsuniversity.official?igsh=ZWp3dmplazI5OGo4',
                  ),
              icon: const Icon(FontAwesomeIcons.instagram, color: Colors.white),
            ),
            IconButton(
              onPressed:
                  () => _launchURL(
                    'https://www.facebook.com/profile.php?id=61573409518530&mibextid=rS40aB7S9Ucbxw6v',
                  ),
              icon: const Icon(FontAwesomeIcons.facebook, color: Colors.white),
            ),
            IconButton(
              onPressed:
                  () => _launchURL(
                    'https://www.tiktok.com/@tsuniversity.official',
                  ),
              icon: const Icon(FontAwesomeIcons.tiktok, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _footerContactRow({
    required IconData icon,
    required String label,
    required String url,
  }) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
