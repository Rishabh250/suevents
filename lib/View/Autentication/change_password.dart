// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/global_snackbar.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Student%20API/authentication_api.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController password = TextEditingController();
  var getEmail = Get.arguments;
  String email = "";
  @override
  void initState() {
    super.initState();
    email = getEmail[0]["email"];
  }

  bool isPassVisible = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
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
                      child: Text("Reset Password",
                          style: GoogleFonts.poppins(
                              fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        width: _width * 0.9,
                        child: TextField(
                          readOnly: true,
                          style: GoogleFonts.poppins(
                              fontSize: 11.5.sp, fontWeight: FontWeight.w600),
                          keyboardType: TextInputType.emailAddress,
                          enableSuggestions: true,
                          decoration: InputDecoration(
                              hintText: getEmail[0]["email"],
                              hintStyle: GoogleFonts.poppins(fontSize: 11.sp),
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
                        width: _width * 0.9,
                        child: TextFormField(
                          obscureText: isPassVisible,
                          controller: password,
                          style: GoogleFonts.poppins(
                              fontSize: 12.sp, fontWeight: FontWeight.w600),
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
                              hintText: "New Password",
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
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                        height: 40,
                        width: _width * 0.5,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 4,
                              primary: const Color.fromARGB(255, 61, 140, 236),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () async {
                            if (password.text.isEmpty) {
                              showError("Empty Field", "Enter your password");
                              return;
                            } else {
                              EasyLoading.show();
                              await resetPassword(
                                  email.toString(), password.text.toString());
                              EasyLoading.dismiss();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 15, right: 15),
                            child: Text(
                              "Reset Password",
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
