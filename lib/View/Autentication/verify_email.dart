// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/global_snackbar.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Faculty%20API/faculty_auth.dart';
import 'package:suevents/Models/Student%20API/authentication_api.dart';
import 'package:suevents/View/Autentication/login.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({Key? key}) : super(key: key);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();

  bool isPassVisible = true;
  ValueNotifier<String> buttonName = ValueNotifier<String>("Resend OTP");
  var userType = Get.arguments;
  Timer? _timer;
  final ValueNotifier _start = ValueNotifier(30);
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start.value == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start.value--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              )),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text("Verify Sharda Mail ID",
                          style: GoogleFonts.poppins(
                              fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * 0.9,
                        child: TextField(
                          enabled: false,
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          enableSuggestions: true,
                          decoration: InputDecoration(
                              hintText: userType["email"],
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 11.sp, fontWeight: FontWeight.w600),
                              prefixIcon: const Icon(Icons.mail),
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * 0.9,
                        child: TextFormField(
                          controller: otp,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          style: GoogleFonts.poppins(
                              fontSize: 12.sp, fontWeight: FontWeight.w600),
                          enableSuggestions: true,
                          decoration: InputDecoration(
                              counterText: "",
                              hintText: "OTP",
                              hintStyle: GoogleFonts.poppins(fontSize: 12.sp),
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: GestureDetector(
                                onTap: () async {
                                  EasyLoading.show();
                                  _start.value = 30;
                                  startTimer();
                                  setState(() {});
                                  var isSend = userType['isType'] == "Student"
                                      ? await sendOTP(userType["email"])
                                      : await facultysendOTP(userType["email"]);

                                  EasyLoading.dismiss();
                                },
                                child: ValueListenableBuilder(
                                  valueListenable: buttonName,
                                  builder: (context, value, _) {
                                    return Text(
                                      _start.value == 0
                                          ? "Resend"
                                          : "Resend OTP in ${_start.value.toString()} seconds",
                                      style: textStyle(
                                          10.sp,
                                          FontWeight.w800,
                                          themeProvider.isDarkMode
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  255, 11, 112, 234),
                                          FontStyle.normal),
                                    );
                                  },
                                ))),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                        height: 40,
                        width: width * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 4,
                              primary: const Color.fromARGB(255, 61, 140, 236),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () async {
                            EasyLoading.show();
                            bool isVerify = userType["isType"] == "Student"
                                ? await verifyOTP(
                                    userType["email"], otp.text.toString())
                                : await facultyverifyOTP(
                                    userType["email"], otp.text.toString());
                            if (isVerify) {
                              EasyLoading.dismiss();

                              Get.offAll(const LoginPage(),
                                  transition: Transition.fadeIn,
                                  arguments: {"isType": userType["isType"]});
                              return;
                            } else {
                              EasyLoading.dismiss();

                              showError("Invalid OTP", "Enter a vaild otp");
                              return;
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 15, right: 15),
                            child: Text(
                              "Verify OTP",
                              style: textStyle(12.sp, FontWeight.bold,
                                  Colors.white, FontStyle.normal),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            )
          ]),
        ));
  }
}
