import 'package:flutter/material.dart';
import 'package:sikermatsu/widgets/app_drawer.dart';
import 'package:sikermatsu/widgets/app_bar.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isDesktop;
  final bool isLoggedIn;

  const MainLayout({
    super.key,
    required this.title,
    required this.child,
    this.isDesktop = true, //true
    this.isLoggedIn = false, //false
  });

  // @override
  // Widget build(BuildContext context) {
  //   return Builder(
  //     builder: (scaffoldContext) {
  //       return Scaffold(
  //         backgroundColor: const Color.fromARGB(255, 236, 236, 236),
  //         appBar: CustomAppBar(
  //           isDesktop: isDesktop,
  //           onMenuPressed: () {
  //             Scaffold.of(scaffoldContext).openDrawer();
  //           },
  //           title: title,
  //           isLoggedIn: isLoggedIn,
  //         ),
  //         drawer: isLoggedIn ? const AppDrawer() : null,
  //         body: Row(
  //           children: [
  //             if (isDesktop && isLoggedIn) const AppDrawer(),
  //             Expanded(child: child),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 236, 236),
      appBar: CustomAppBar(
        isDesktop: isDesktop,
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
        title: title,
        isLoggedIn: isLoggedIn,
      ),
      drawer: isLoggedIn ? const AppDrawer() : null,
      // body: child,
      body: Row(
        children: [
          if (isDesktop && isLoggedIn) const AppDrawer(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
