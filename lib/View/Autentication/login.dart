// ignore_for_file: unused_local_variable

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/Internet%20Connection/connection_provider.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/global_snackbar.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Faculty%20API/faculty_auth.dart';
import 'package:suevents/Models/Student%20API/authentication_api.dart';
import 'package:suevents/View/get_started.dart';
import 'package:suevents/View/no_connection.dart';

import 'create_account.dart';
import 'forgetpassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  ValueNotifier<String> deviceID = ValueNotifier("");
  var userType = Get.arguments;
  bool isPassVisible = true;
  final deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void initState() {
    userData.getDeviceInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Consumer<ConnectivityProvider>(
        builder: (context, value, child) => value.isOnline
            ? Scaffold(
                resizeToAvoidBottomInset: false,
                body: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    overScroll.disallowIndicator();
                    return true;
                  },
                  child: CustomScrollView(slivers: [
                    const SliverAppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1),
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
                              height: 10.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text("Login",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text("Please sign in to continue",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: SizedBox(
                                width: width * 0.9,
                                child: TextField(
                                  style: GoogleFonts.poppins(
                                      fontSize: 11.5.sp,
                                      fontWeight: FontWeight.w600),
                                  controller: email,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  decoration: InputDecoration(
                                      hintText: "Sharda Email ID",
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 12.sp),
                                      prefixIcon: const Icon(Icons.mail),
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(15))),
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
                                  controller: password,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                  obscureText: isPassVisible,
                                  enableSuggestions: true,
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isPassVisible = !isPassVisible;
                                            });
                                          },
                                          child: Icon(isPassVisible == true
                                              ? Icons.visibility
                                              : Icons.visibility_off)),
                                      hintText: "Password",
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 12.sp),
                                      prefixIcon: const Icon(Icons.lock),
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => const ForgotPassword(),
                                            transition: Transition.fadeIn,
                                            arguments: {
                                              "isType": userType["isType"]
                                            });
                                      },
                                      child: Text(
                                        "Forgot Password ?",
                                        style: textStyle(
                                            10.sp,
                                            FontWeight.w800,
                                            themeProvider.isDarkMode
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                    255, 11, 112, 234),
                                            FontStyle.normal),
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SizedBox(
                                height: 40,
                                width: width * 0.4,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 4,
                                      primary: const Color.fromARGB(
                                          255, 61, 140, 236),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  onPressed: () async {
                                    if (email.text.isEmpty) {
                                      showError("Empty Field",
                                          "Enter your Sharda Email ID");
                                      return;
                                    }

                                    if (userType["isType"] == "Student") {
                                      if (email.text
                                              .toString()
                                              .split(".")[0]
                                              .length !=
                                          10) {
                                        showError("Invalid Sharda Mail ID",
                                            "Please enter a valid sharda mail id");
                                        return;
                                      }
                                    }
                                    if (!email.text.toString().contains("@")) {
                                      showError("Invalid Sharda Mail ID",
                                          "Please enter a valid sharda mail id");
                                      return;
                                    }

                                    if (password.text.isEmpty) {
                                      showError(
                                          "Empty Field", "Enter your password");
                                      return;
                                    } else {
                                      EasyLoading.show();
                                      userType["isType"] == "Student"
                                          ? await userLogin(
                                              email.text.toString(),
                                              password.text.toString(),
                                              userData.deviceID.value
                                                  .toString())
                                          : await facultyLogin(
                                              email.text.toString(),
                                              password.text.toString());
                                      EasyLoading.dismiss();
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 8.0,
                                        left: 15,
                                        right: 15),
                                    child: Text(
                                      "Login",
                                      style: textStyle(12.sp, FontWeight.bold,
                                          Colors.white, FontStyle.normal),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have account ?",
                                    style: textStyle(
                                        10.sp,
                                        FontWeight.w500,
                                        themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        FontStyle.normal),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (userType["isType"] == "Faculty") {
                                        Get.offAll(() => const CreateAccount(),
                                            arguments: {
                                              "isType": userType["isType"]
                                            },
                                            transition: Transition.fadeIn);
                                      } else {
                                        EasyLoading.show();

                                        var checkID = await checkDevice(
                                            userData.deviceID.value);

                                        if (checkID) {
                                          EasyLoading.dismiss();

                                          Get.offAll(
                                              () => const CreateAccount(),
                                              arguments: {
                                                "isType": userType["isType"]
                                              },
                                              transition: Transition.fadeIn);
                                        } else {
                                          EasyLoading.dismiss();
                                        }
                                      }
                                    },
                                    child: Text(
                                      "Create Account",
                                      style: textStyle(
                                          11.sp,
                                          FontWeight.bold,
                                          const Color.fromARGB(255, 8, 122, 0),
                                          FontStyle.normal),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]),
                    )
                  ]),
                ))
            : const NoInternet());
  }
}
