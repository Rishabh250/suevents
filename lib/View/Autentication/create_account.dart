import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/View/get_started.dart';
import 'package:suevents/View/no_connection.dart';

import '../../Controller/Internet Connection/connection_provider.dart';
import '../../Controller/providers/const.dart';
import '../../Controller/providers/theme_service.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => Create_AccountState();
}

class Create_AccountState extends State<CreateAccount> {
  var userType = Get.arguments;
  ValueNotifier isPassVisible = ValueNotifier(true);
  ValueNotifier gropuValue = ValueNotifier(0);

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController systemID = TextEditingController();
  TextEditingController program = TextEditingController();
  TextEditingController branch = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController semester = TextEditingController();
  ValueNotifier gender = ValueNotifier("");

  @override
  void initState() {
    super.initState();
    print(userData.deviceID.value);
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
            ? Scaffold(
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
                          height: 10.h,
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
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(15))),
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
                                SizedBox(
                                  width: width * 0.4,
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
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
                                            borderSide: const BorderSide(
                                                color: Colors.blue),
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: width * 0.4,
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    style: GoogleFonts.poppins(
                                        fontSize: 11.5.sp,
                                        fontWeight: FontWeight.w600),
                                    controller: program,
                                    keyboardType: TextInputType.number,
                                    enableSuggestions: true,
                                    decoration: InputDecoration(
                                        hintText: "Course",
                                        hintStyle: GoogleFonts.poppins(
                                            fontSize: 12.sp),
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.blue),
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: SizedBox(
                            width: width * 0.9,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width * 0.4,
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
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
                                            borderSide: const BorderSide(
                                                color: Colors.blue),
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: width * 0.4,
                                  child: TextField(
                                    maxLength: 2,
                                    textInputAction: TextInputAction.next,
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
                                            borderSide: const BorderSide(
                                                color: Colors.blue),
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                      ],
                    ),
                  )
                ],
              ))
            : const NoInternet();
      },
    );
  }
}
