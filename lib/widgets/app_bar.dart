import 'package:flutter/material.dart';
import '../helpers/responsive.dart'; // import class Responsive
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/styles/style.dart';
import '../services/auth_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String title;
  final List<Widget>? actions;
  final bool isLoggedIn;
  final bool isDesktop;

  const CustomAppBar({
    super.key,
    this.scaffoldKey,
    this.title = '',
    this.actions,
    this.isLoggedIn = false,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final bool isHome = currentRoute == '/home';
    final bool showMenuIcon = isLoggedIn && !isHome;
    final bool showNotificationIcon = isLoggedIn && !isHome;

    return AppBar(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading:
          showMenuIcon
              ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  scaffoldKey?.currentState?.openDrawer();
                },
              )
              : null,
      title: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 32),
          const SizedBox(width: 12),

          // Show menu items only on desktop and tablet (not mobile)
          if (!isMobile) ...[
            if (!isLoggedIn)
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
                child: const Text('Home'),
              ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/mou');
              },
              child: const Text('Daftar MoU'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/pks');
              },
              child: const Text('Daftar PKS'),
            ),
          ],
        ],
      ),
      actions:
          actions ??
          [
            // Notifications icon (only if logged in and role admin/user)
            ValueListenableBuilder<String>(
              valueListenable: AppState.role,
              builder: (context, role, _) {
                if (showNotificationIcon &&
                    (role == 'admin' || role == 'user')) {
                  return IconButton(
                    icon: const Icon(Icons.notifications),
                    tooltip: 'Notifikasi',
                    style: CustomStyle.iconButtonStyle,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/notifikasi');
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Login / Logout icon
            if (isMobile)
              // For mobile, show menu in popup menu button with login/logout & navigation links
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'home':
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                      break;
                    case 'mou':
                      Navigator.pushReplacementNamed(context, '/mou');
                      break;
                    case 'pks':
                      Navigator.pushReplacementNamed(context, '/pks');
                      break;
                    case 'login':
                      Navigator.pushReplacementNamed(context, '/login');
                      break;
                    case 'logout':
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Konfirmasi Logout'),
                              content: const Text(
                                'Apakah Anda yakin ingin logout?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await AuthService.logout();
                                    AppState.logout();
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/home',
                                      (route) => false,
                                    );
                                  },
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                      );
                      break;
                  }
                },
                itemBuilder: (context) {
                  return [
                    if (!isLoggedIn)
                      const PopupMenuItem(value: 'home', child: Text('Home')),
                    const PopupMenuItem(
                      value: 'mou',
                      child: Text('Daftar MoU'),
                    ),
                    const PopupMenuItem(
                      value: 'pks',
                      child: Text('Daftar PKS'),
                    ),
                    PopupMenuItem(
                      value: isLoggedIn ? 'logout' : 'login',
                      child: Text(isLoggedIn ? 'Logout' : 'Login'),
                    ),
                  ];
                },
              )
            else
              // For desktop/tablet, show person icon for login/logout
              IconButton(
                icon: const Icon(Icons.person),
                style: CustomStyle.iconButtonStyle,
                tooltip: isLoggedIn ? 'Logout' : 'Login',
                onPressed: () {
                  if (isLoggedIn) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Konfirmasi Logout'),
                            content: const Text(
                              'Apakah Anda yakin ingin logout?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  AppState.logout();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/home',
                                    (route) => false,
                                  );
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                    );
                  } else {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
