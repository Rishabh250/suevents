// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:suevents/Controller/providers/theme_service.dart';

import 'menu.dart';
import 'navigation_bar.dart';

class FacultyMainScreen extends StatefulWidget {
  const FacultyMainScreen({Key? key}) : super(key: key);

  @override
  _FacultyMainScreenState createState() => _FacultyMainScreenState();
}

class _FacultyMainScreenState extends State<FacultyMainScreen> {
  final drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ZoomDrawer(
        controller: drawerController,
        mainScreenTapClose: true,
        menuScreen: const FacultyMenuScreen(),
        mainScreen: const FacultyNavigationBarPage(),
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
