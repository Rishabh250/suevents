import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Student%20API/authentication_api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseStorage storage = FirebaseStorage.instance;
  File? image;
  String imageURL = '';
  var token;
  var user;

  Future<void> _upload() async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage =
          await picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);
      image = File(pickedImage.path);

      try {
        var snapshot = await storage.ref(fileName).putFile(imageFile);
        var downloadURL = await snapshot.ref.getDownloadURL();

        setState(() {
          imageURL = downloadURL;
        });
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
    user = await getUserData(token);
    log(user.toString());
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios_rounded,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black),
          )),
      body: FutureBuilder(
          future: fetchUserData(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (user != null) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        user["user"]["profileImage"] == ""
                            ? Stack(
                                children: [
                                  const CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage("assets/images/bg.jpg"),
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          EasyLoading.show();
                                          await _upload();
                                          await uploadProfileImage(
                                              token, imageURL.toString());
                                        },
                                        child: const Icon(
                                          Icons.camera_alt_rounded,
                                        ),
                                      ))
                                ],
                              )
                            : Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                        user["user"]["profileImage"]),
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          EasyLoading.show();
                                          await _upload();
                                          await uploadProfileImage(
                                              token, imageURL.toString());
                                          EasyLoading.dismiss();
                                        },
                                        child: const Icon(
                                          Icons.camera_alt_rounded,
                                        ),
                                      ))
                                ],
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          user["user"]["name"],
                          style: textStyle(
                              15.sp,
                              FontWeight.bold,
                              themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              FontStyle.normal),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          user["user"]["email"],
                          style: textStyle(
                              10.sp,
                              FontWeight.w600,
                              themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              FontStyle.normal),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            width: _width * 0.9,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.2,
                                    color: themeProvider.isDarkMode
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 151, 194, 8)),
                                borderRadius: BorderRadius.circular(20),
                                color: themeProvider.isDarkMode
                                    ? HexColor("020E26")
                                    : Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "System ID : ",
                                        style: textStyle(
                                            12.sp,
                                            FontWeight.w400,
                                            themeProvider.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            FontStyle.normal),
                                      ),
                                      Text(user["user"]["systemID"],
                                          style: textStyle(
                                              12.sp,
                                              FontWeight.bold,
                                              themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontStyle.normal))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Course : ",
                                            style: textStyle(
                                                12.sp,
                                                FontWeight.w400,
                                                themeProvider.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                FontStyle.normal),
                                          ),
                                          Text(user["user"]["course"],
                                              style: textStyle(
                                                  12.sp,
                                                  FontWeight.bold,
                                                  themeProvider.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  FontStyle.normal))
                                        ],
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          Text(
                                            "Year : ",
                                            style: textStyle(
                                                12.sp,
                                                FontWeight.w400,
                                                themeProvider.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                FontStyle.normal),
                                          ),
                                          Text(
                                              user["user"]["year"].toString() +
                                                  " ( ${user["user"]["semester"].toString()} Semester )",
                                              style: textStyle(
                                                  12.sp,
                                                  FontWeight.bold,
                                                  themeProvider.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  FontStyle.normal))
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Gender : ",
                                        style: textStyle(
                                            12.sp,
                                            FontWeight.w400,
                                            themeProvider.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            FontStyle.normal),
                                      ),
                                      Text(user["user"]["gender"],
                                          style: textStyle(
                                              12.sp,
                                              FontWeight.bold,
                                              themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontStyle.normal))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Events Applied : ",
                                        style: textStyle(
                                            12.sp,
                                            FontWeight.w400,
                                            themeProvider.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            FontStyle.normal),
                                      ),
                                      Text(
                                          user["user"]["events"]
                                              .length
                                              .toString(),
                                          style: textStyle(
                                              12.sp,
                                              FontWeight.bold,
                                              themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontStyle.normal))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }

            return const Center(child: Text("Something went wrong"));
          })),
    );
  }
}
