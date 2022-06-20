import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/theme_service.dart';

import 'View/Faculty Portal/Navigation Bar/zoom_drawer.dart';
import 'View/Student Portal/Navigation Bar/zoom_drawer.dart';
import 'View/get_started.dart';

class SplastScreen extends StatefulWidget {
  const SplastScreen({Key? key}) : super(key: key);

  @override
  State<SplastScreen> createState() => _SplastScreenState();
}

class _SplastScreenState extends State<SplastScreen> {
  var isLog, userType;
  @override
  void initState() {
    getuserInfo();
    super.initState();
  }

  getuserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isLog = sharedPreferences.getBool("isLogged");
    userType = sharedPreferences.getString("getUser");
    Future.delayed(const Duration(seconds: 1), () {
      log(isLog.toString());
      isLog == true
          ? userType == "Student"
              ? Get.to(() => const MainScreen(), transition: Transition.fadeIn)
              : Get.to(() => const FacultyMainScreen(),
                  transition: Transition.fadeIn)
          : Get.to(() => const Getstarted(), transition: Transition.fadeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/shardaLogo.png",
                width: 10.h,
                height: 10.h,
              ),
              Column(
                children: [
                  Center(
                    child: Text("Sharda University",
                        style: Theme.of(context).textTheme.headline1),
                  ),
                  Center(
                    child: Text("A Truly Global University",
                        style: GoogleFonts.poppins(
                            fontSize: 12.sp, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                width: MediaQuery.of(context).size.width * 0.4,
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    color: Colors.amber,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
