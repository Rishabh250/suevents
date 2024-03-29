// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/global_snackbar.dart';
import 'package:suevents/View/Student%20Portal/Navigation%20Bar/navigation_bar.dart';

import 'View/Faculty Portal/Navigation Bar/navigation_bar.dart';
import 'View/get_started.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
    var isConnected = await connection();
    if (isConnected) {
      Future.delayed(const Duration(seconds: 1), () {
        isLog == true
            ? userType == "Student"
                ? Get.offAll(() => const NavigationBarPage(),
                    transition: Transition.fadeIn)
                : Get.offAll(() => const FacultyNavigationBarPage(),
                    transition: Transition.fadeIn)
            : Get.offAll(() => const Getstarted(),
                transition: Transition.fadeIn);
      });
    } else {
      showError("Server Down", "Please try again later");
    }
  }

  @override
  Widget build(BuildContext context) {
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

  connection() async {
    try {
      var response = await https.get(Uri.parse(
          "https://suevents2022.herokuapp.com/"));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
