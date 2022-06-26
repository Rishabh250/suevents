// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Models/Faculty%20API/faculty_auth.dart';
import 'package:suevents/View/Autentication/login.dart';
import 'package:suevents/View/Autentication/verify_email.dart';
import 'package:suevents/View/get_started.dart';
import 'package:suevents/View/no_connection.dart';

import '../../Controller/Internet Connection/connection_provider.dart';
import '../../Controller/providers/const.dart';
import '../../Controller/providers/global_snackbar.dart';
import '../../Controller/providers/theme_service.dart';
import '../../Models/Student API/authentication_api.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  var userType = Get.arguments;
  ValueNotifier isPassVisible = ValueNotifier(true);
  ValueNotifier gropuValue = ValueNotifier(0);

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController systemID = TextEditingController();
  TextEditingController program = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController semester = TextEditingController();
  ValueNotifier gender = ValueNotifier("");

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMontering();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Consumer<ConnectivityProvider>(
      builder: (context, value, child) {
        return value.isOnline
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Scaffold(
                    body: CustomScrollView(
                  slivers: [
                    const SliverAppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                    SliverToBoxAdapter(
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
                            height: 8.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Text("Create Account",
                                style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: SizedBox(
                              width: width * 0.9,
                              child: TextField(
                                textInputAction: TextInputAction.next,
                                style: GoogleFonts.poppins(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w600),
                                controller: name,
                                keyboardType: TextInputType.emailAddress,
                                enableSuggestions: true,
                                decoration: InputDecoration(
                                    hintText: "Full Name",
                                    hintStyle:
                                        GoogleFonts.poppins(fontSize: 12.sp),
                                    prefixIcon: const Icon(Icons.person),
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
                              child: TextField(
                                textInputAction: TextInputAction.next,
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
                          ValueListenableBuilder(
                              valueListenable: isPassVisible,
                              builder: (context, value, child) {
                                return Center(
                                  child: SizedBox(
                                    width: width * 0.9,
                                    child: TextField(
                                      textInputAction: TextInputAction.next,
                                      controller: password,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600),
                                      obscureText: isPassVisible.value,
                                      enableSuggestions: true,
                                      decoration: InputDecoration(
                                          suffixIcon: GestureDetector(
                                              onTap: () {
                                                isPassVisible.value =
                                                    !isPassVisible.value;
                                              },
                                              child: Icon(
                                                  isPassVisible.value == true
                                                      ? Icons.visibility
                                                      : Icons.visibility_off)),
                                          hintText: "Password",
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: 12.sp),
                                          prefixIcon: const Icon(Icons.lock),
                                          border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                    ),
                                  ),
                                );
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: SizedBox(
                              width: width * 0.9,
                              child: Row(
                                children: [
                                  userType["isType"] == "Student"
                                      ? SizedBox(
                                          width: width * 0.4,
                                          child: TextField(
                                            textInputAction:
                                                TextInputAction.next,
                                            maxLength: 10,
                                            style: GoogleFonts.poppins(
                                                fontSize: 11.5.sp,
                                                fontWeight: FontWeight.w600),
                                            controller: systemID,
                                            keyboardType: TextInputType.number,
                                            enableSuggestions: true,
                                            decoration: InputDecoration(
                                                counterText: "",
                                                hintText: "System ID",
                                                hintStyle: GoogleFonts.poppins(
                                                    fontSize: 12.sp),
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15))),
                                          ),
                                        )
                                      : SizedBox(
                                          width: width * 0.7,
                                          child: TextField(
                                            textInputAction:
                                                TextInputAction.next,
                                            maxLength: 10,
                                            style: GoogleFonts.poppins(
                                                fontSize: 11.5.sp,
                                                fontWeight: FontWeight.w600),
                                            controller: systemID,
                                            keyboardType: TextInputType.number,
                                            enableSuggestions: true,
                                            decoration: InputDecoration(
                                                counterText: "",
                                                hintText: "System/Employee ID",
                                                hintStyle: GoogleFonts.poppins(
                                                    fontSize: 12.sp),
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15))),
                                          ),
                                        ),
                                  const Spacer(),
                                  userType["isType"] == "Student"
                                      ? SizedBox(
                                          width: width * 0.4,
                                          child: TextField(
                                            textInputAction:
                                                TextInputAction.next,
                                            style: GoogleFonts.poppins(
                                                fontSize: 11.5.sp,
                                                fontWeight: FontWeight.w600),
                                            controller: program,
                                            keyboardType: TextInputType.text,
                                            enableSuggestions: true,
                                            decoration: InputDecoration(
                                                hintText: "Course",
                                                hintStyle: GoogleFonts.poppins(
                                                    fontSize: 12.sp),
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15))),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          userType["isType"] == "Student"
                              ? Center(
                                  child: SizedBox(
                                    width: width * 0.9,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.4,
                                          child: TextField(
                                            textInputAction:
                                                TextInputAction.next,
                                            maxLength: 1,
                                            style: GoogleFonts.poppins(
                                                fontSize: 11.5.sp,
                                                fontWeight: FontWeight.w600),
                                            controller: year,
                                            keyboardType: TextInputType.number,
                                            enableSuggestions: true,
                                            decoration: InputDecoration(
                                                counterText: "",
                                                hintText: "Year",
                                                hintStyle: GoogleFonts.poppins(
                                                    fontSize: 12.sp),
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15))),
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: width * 0.4,
                                          child: TextField(
                                            maxLength: 2,
                                            textInputAction:
                                                TextInputAction.next,
                                            style: GoogleFonts.poppins(
                                                fontSize: 11.5.sp,
                                                fontWeight: FontWeight.w600),
                                            controller: semester,
                                            keyboardType: TextInputType.number,
                                            enableSuggestions: true,
                                            decoration: InputDecoration(
                                                counterText: "",
                                                hintText: "Semester",
                                                hintStyle: GoogleFonts.poppins(
                                                    fontSize: 12.sp),
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: userType["isType"] == "Student" ? 20 : 0,
                          ),
                          Center(
                            child: SizedBox(
                              width: width * 0.9,
                              child: Row(
                                children: [
                                  Text(
                                    "Gender : ",
                                    style: textStyle(
                                        12.sp,
                                        FontWeight.bold,
                                        themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        FontStyle.normal),
                                  ),
                                  Row(
                                    children: [
                                      ValueListenableBuilder(
                                        builder: ((context, value, child) {
                                          return Radio(
                                              value: 1,
                                              groupValue: value,
                                              onChanged: (changeValue) {
                                                gropuValue.value = int.parse(
                                                    changeValue.toString());
                                                gender.value = "Male";
                                              });
                                        }),
                                        valueListenable: gropuValue,
                                      ),
                                      Text("Male",
                                          style: textStyle(
                                              12.sp,
                                              FontWeight.bold,
                                              themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontStyle.normal)),
                                      ValueListenableBuilder(
                                        builder: ((context, value, child) {
                                          return Radio(
                                              value: 2,
                                              groupValue: value,
                                              onChanged: (changeValue) {
                                                gropuValue.value = int.parse(
                                                    changeValue.toString());
                                                gender.value = "Female";
                                              });
                                        }),
                                        valueListenable: gropuValue,
                                      ),
                                      Text("Female",
                                          style: textStyle(
                                              12.sp,
                                              FontWeight.bold,
                                              themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontStyle.normal)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: SizedBox(
                              height: 40,
                              width: width * 0.5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    primary:
                                        const Color.fromARGB(255, 61, 140, 236),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                onPressed: () async {
                                  if (name.text.isEmpty) {
                                    showError(
                                        "Empty Field", "Enter your Full Name");
                                    return;
                                  }
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
                                  // if (!email.text.toString().contains("@") ||
                                  //     !email.text
                                  //         .toString()
                                  //         .contains("sharda.ac.in")) {
                                  //   showError("Invalid Sharda Mail ID",
                                  //       "Please enter a valid sharda mail id");
                                  //   return;
                                  // }

                                  if (password.text.isEmpty) {
                                    showError(
                                        "Empty Field", "Enter your password");
                                    return;
                                  }
                                  if (systemID.text.isEmpty) {
                                    showError(
                                        "Empty Field", "Enter your System ID");
                                    return;
                                  }
                                  if (userType["isType"] == "Student") {
                                    if (program.text.isEmpty) {
                                      showError(
                                          "Empty Field", "Enter your Course");
                                      return;
                                    }
                                    if (year.text.isEmpty) {
                                      showError("Empty Field",
                                          "Enter your Course year");
                                      return;
                                    }
                                    if (semester.text.isEmpty) {
                                      showError("Empty Field",
                                          "Enter your Course Semester");
                                      return;
                                    }
                                  }
                                  if (gender.value == "") {
                                    showError("Empty Field",
                                        "Please select your gender");
                                    return;
                                  } else {
                                    EasyLoading.show();
                                    bool isCreated =
                                        userType["isType"] == "Student"
                                            ? await createStudent(
                                                email.text.toString(),
                                                password.text.toString(),
                                                name.text.toString(),
                                                systemID.text.toString(),
                                                program.text.toString(),
                                                year.text.toString(),
                                                semester.text.toString(),
                                                gender.value.toString(),
                                                userData.deviceID.value,
                                              )
                                            : await createFaculty(
                                                email.text.toString(),
                                                password.text.toString(),
                                                name.text.toString(),
                                                systemID.text.toString(),
                                                gender.value.toString(),
                                              );

                                    if (isCreated) {
                                      EasyLoading.dismiss();

                                      userType["isType"] == "Student"
                                          ? await sendOTP(email.text.toString())
                                          : facultysendOTP(
                                              email.text.toString());

                                      Get.to(() => const EmailVerify(),
                                          arguments: {
                                            "isType": userType["isType"],
                                            "email": email.text.toString()
                                          },
                                          transition: Transition.fadeIn);
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 8.0,
                                      left: 15,
                                      right: 15),
                                  child: Text(
                                    "Create Account",
                                    style: textStyle(12.sp, FontWeight.bold,
                                        Colors.white, FontStyle.normal),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have account ?",
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
                                    Get.offAll(() => const LoginPage(),
                                        arguments: {
                                          "isType": userType["isType"]
                                        },
                                        transition: Transition.fadeIn);
                                  },
                                  child: Text(
                                    "Login",
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
                        ],
                      ),
                    )
                  ],
                )),
              )
            : const NoInternet();
      },
    );
  }
}
