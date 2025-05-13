import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/app_drawer.dart';
import 'package:sikermatsu/widgets/app_bar.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isLoggedIn;

  MainLayout({
    super.key,
    required this.title,
    required this.child,
    this.isLoggedIn = false,
  });

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 236, 236, 236),
          appBar: CustomAppBar(
            isDesktop: isDesktop,
            scaffoldKey: scaffoldKey,
            // onMenuPressed: () {
            //   Scaffold.of(context).openDrawer(); // untuk mobile
            // },
            title: title,
            isLoggedIn: isLoggedIn,
          ),
          drawer: (!isDesktop && isLoggedIn) ? const AppDrawer() : null,
          body: Row(
            children: [
              if (isDesktop && isLoggedIn) const AppDrawer(),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}
