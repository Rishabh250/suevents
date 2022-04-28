import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:suevents/Screens/Navigation%20Bar/navigation_bar.dart';

import 'menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
        controller: drawerController,
        menuScreen: const MenuScreen(),
        mainScreen: const NavigationBarPage(),
        style: DrawerStyle.defaultStyle,
        borderRadius: 30.0,
        showShadow: true,
        angle: 0.0,
        menuBackgroundColor: Colors.grey[300]!,
        slideWidth: MediaQuery.of(context).size.width * .50,
        androidCloseOnBackTap: true,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.fastOutSlowIn,
      ),
    );
  }
}
