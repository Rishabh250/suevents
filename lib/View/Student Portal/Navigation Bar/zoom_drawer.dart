// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:suevents/Controller/providers/theme_service.dart';

import 'menu.dart';
import 'navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ZoomDrawer(
        controller: drawerController,
        mainScreenTapClose: true,
        menuScreen: const MenuScreen(),
        mainScreen: const NavigationBarPage(),
        style: DrawerStyle.defaultStyle,
        borderRadius: 30.0,
        showShadow: true,
        angle: 0.0,
        shadowLayer1Color: themeProvider.isDarkMode
            ? HexColor("#010A1C").withOpacity(0.3)
            : Colors.grey.withOpacity(0.3),
        shadowLayer2Color: themeProvider.isDarkMode
            ? HexColor("#010A1C").withOpacity(0.5)
            : Colors.grey.withOpacity(0.5),
        menuBackgroundColor: const Color.fromARGB(255, 13, 2, 60),
        slideWidth: MediaQuery.of(context).size.width * .50,
        androidCloseOnBackTap: true,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.fastOutSlowIn,
      ),
    );
  }
}
