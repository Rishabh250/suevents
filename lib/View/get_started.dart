import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';

import 'Autentication/login.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({Key? key}) : super(key: key);

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  SizedBox(height: 10.h),
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
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Select your occupation",
                    style: textStyle(
                        17.sp,
                        FontWeight.w700,
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                        FontStyle.normal),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  GestureDetector(
                    onTap: (() => Get.to(const LoginPage(),
                        transition: Transition.fadeIn,
                        arguments: {"isType": "Faculty"})),
                    child: SelectionButtons(
                      occupation: "Faculty",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "or",
                    style: textStyle(
                        14.sp, FontWeight.w500, Colors.black, FontStyle.normal),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () => Get.to(const LoginPage(),
                        transition: Transition.fadeIn,
                        arguments: {"isType": "Student"}),
                    child: SelectionButtons(
                      occupation: "Student",
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectionButtons extends StatefulWidget {
  SelectionButtons({Key? key, required this.occupation}) : super(key: key);

  String occupation;

  @override
  State<SelectionButtons> createState() => _SelectionButtonsState();
}

class _SelectionButtonsState extends State<SelectionButtons> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: const Color.fromARGB(255, 62, 127, 247),
        ),
        width: width * 0.95,
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text(
            widget.occupation,
            style: textStyle(
                16.sp, FontWeight.w700, Colors.black, FontStyle.normal),
          ),
        ),
      ),
    );
  }
}
