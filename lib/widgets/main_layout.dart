import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/app_drawer.dart';
import 'package:sikermatsu/widgets/app_bar.dart';
import 'package:sikermatsu/models/app_state.dart';
import 'package:sikermatsu/styles/style.dart';

class MainLayout extends StatefulWidget {
  final String title;
  final Widget child;
  final bool isLoggedIn;

  const MainLayout({
    super.key,
    required this.title,
    required this.child,
    this.isLoggedIn = false,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color.fromARGB(255, 236, 236, 236),
          appBar: CustomAppBar(
            isDesktop: isDesktop,
            scaffoldKey: scaffoldKey,
            title: widget.title,
            isLoggedIn: widget.isLoggedIn,
          ),

          drawer:
              widget.isLoggedIn
                  ? ValueListenableBuilder<String>(
                    valueListenable: AppState.role,
                    builder: (context, role, _) {
                      print('Role aktif: $role');
                      return ValueListenableBuilder<String?>(
                        valueListenable: AppState.token,
                        builder: (context, token, _) {
                          print('Token aktif = $token');
                          return Drawer(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                DrawerHeader(
                                  decoration: BoxDecoration(color: Colors.teal),
                                  // child: Text(
                                  //   'SIKERMA TSU',
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: 24,
                                  //   ),
                                  // ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        child: Image.asset(
                                          'assets/images/logo-white.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'SiKERMA TSU',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                if (role != 'userpkl') ...[
                                  _buildDrawerItem(
                                    context,
                                    'Dashboard',
                                    '/dashboard',
                                    Icons.dashboard,
                                  ),
                                ],

                                if (role == 'userpkl') ...[
                                  _buildDrawerItem(
                                    context,
                                    'Dashboard',
                                    '/dashboard2',
                                    Icons.dashboard_customize,
                                  ),
                                ],

                                if (role == 'admin' || role == 'user') ...[
                                  // _buildDrawerItem(
                                  //   context,
                                  //   'Upload MoU',
                                  //   '/uploadmou',
                                  //   Icons.upload_file,
                                  // ),
                                  // _buildDrawerItem(
                                  //   context,
                                  //   'Upload PKS',
                                  //   '/uploadpks',
                                  //   Icons.drive_folder_upload,
                                  // ),
                                  _buildDrawerItem(
                                    context,
                                    'Progres Kerja Sama',
                                    '/progres',
                                    Icons.timeline,
                                  ),
                                  _buildDrawerItem(
                                    context,
                                    'Pengajuan PKL',
                                    '/pkl',
                                    Icons.work,
                                  ),
                                ],

                                if (role == 'userpkl') ...[
                                  _buildDrawerItem(
                                    context,
                                    'Pengajuan PKL',
                                    '/pkl',
                                    Icons.work,
                                  ),
                                ],

                                if (role == 'admin') ...[
                                  _buildDrawerItem(
                                    context,
                                    'Admin',
                                    '/superadmin',
                                    Icons.accessibility,
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      );
                    },
                  )
                  : null,

          body: widget.child,
        );
      },
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    String route,
    IconData icon,
  ) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == route;

    return Container(
      decoration:
          isSelected
              ? BoxDecoration(
                color: CustomStyle.borderColor,
                border: Border(
                  left: BorderSide(
                    color: CustomStyle.primaryColorDark,
                    width: 4,
                  ),
                ),
              )
              : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? CustomStyle.primaryColorDark : Colors.black54,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? CustomStyle.textColorSecondary : Colors.black87,
          ),
        ),

        selected: isSelected,
        onTap: () {
          if (!isSelected) {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }
}
