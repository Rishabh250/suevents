// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  final context;

  MyThemes(this.context);

  static final darkTheme = ThemeData(
      useMaterial3: true,
      highlightColor: Colors.transparent,
      textTheme: TextTheme(
        headline1: GoogleFonts.poppins(
            fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
        headline2: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: HexColor("##A2A2A2")),
        headline3: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: HexColor('#000000')),
        headline4: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: HexColor("#00C798")),
      ),
      scaffoldBackgroundColor: HexColor("#010A1C"),
      splashColor: Colors.transparent,
      primaryColor: Colors.white,
      cardColor: const Color.fromARGB(255, 8, 92, 217),
      colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 92, 133, 228),
          secondary: Color(0xffFFFFFF)));

  static final lightTheme = ThemeData(
      useMaterial3: true,
      highlightColor: Colors.transparent,
      textTheme: TextTheme(
        headline1: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: HexColor("1A1B1D")),
        headline2: GoogleFonts.poppins(
            fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
        headline3: GoogleFonts.poppins(
          fontSize: 14.sp,
          color: const Color.fromRGBO(112, 116, 119, 1),
          fontWeight: FontWeight.w400,
        ),
        headline4: GoogleFonts.poppins(
          fontSize: 12.sp,
          color: const Color(0xff00C798),
          fontWeight: FontWeight.w400,
        ),
      ),
      scaffoldBackgroundColor: HexColor("F3F6F9"),
      primaryColor: const Color.fromARGB(255, 22, 116, 10),
      splashColor: Colors.transparent,
      cardColor: const Color.fromARGB(255, 3, 99, 242),
      colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 92, 133, 228),
          secondary: Color(0xffFFFFFF)));
}
