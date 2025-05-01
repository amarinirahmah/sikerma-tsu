import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'app_drawer.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;

  const MainLayout({
    super.key,
    required this.child,
    this.title = '',
    this.actions,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool isDrawerVisible = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          drawer: isDesktop ? null : const Drawer(child: AppDrawer()),
          appBar: CustomAppBar(
            isDesktop: isDesktop,
            onMenuPressed: () {
              if (isDesktop) {
                setState(() {
                  isDrawerVisible = !isDrawerVisible;
                });
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
            title: widget.title,
            actions: widget.actions,
          ),
          body: Row(
            children: [
              if (isDesktop && isDrawerVisible) const AppDrawer(),
              Expanded(child: widget.child),
            ],
          ),
        );
      },
    );
  }
}
