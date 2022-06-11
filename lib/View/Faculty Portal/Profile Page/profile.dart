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
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/Faculty%20Controller/faculty_controller.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Faculty%20API/faculty_auth.dart';

class FacultyProfilePage extends StatefulWidget {
  const FacultyProfilePage({Key? key}) : super(key: key);

  @override
  State<FacultyProfilePage> createState() => _FacultyProfilePageState();
}

FacultyController controller = FacultyController();

class _FacultyProfilePageState extends State<FacultyProfilePage> {
  FirebaseStorage storage = FirebaseStorage.instance;
  File? image;
  ValueNotifier imageURL = ValueNotifier("");
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

        imageURL.value = downloadURL;
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
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: FutureBuilder(
          future: controller.fetchFacultyData(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              EasyLoading.show(dismissOnTap: false);
              return Container();
            }
            if (controller.user != null) {
              EasyLoading.dismiss(animation: true);

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                      elevation: 0,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      leading: GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(Icons.arrow_back_ios_rounded,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black),
                      )),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        controller.userImage.value == ""
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
                                          await facultyUploadImage(
                                              controller.token, imageURL.value);
                                          await controller.fetchFacultyData();
                                        },
                                        child: const Icon(
                                          Icons.camera_alt_rounded,
                                        ),
                                      ))
                                ],
                              )
                            : Stack(
                                children: [
                                  ValueListenableBuilder(
                                      valueListenable: controller.userImage,
                                      builder: (context, value, child) {
                                        return CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              NetworkImage("$value"),
                                        );
                                      }),
                                  Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          EasyLoading.show();
                                          await _upload();
                                          await facultyUploadImage(
                                              controller.token, imageURL.value);
                                          await controller.fetchFacultyData();
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
                        ValueListenableBuilder(
                            valueListenable: controller.name,
                            builder: (context, value, child) {
                              return Text(
                                "$value",
                                style: textStyle(
                                    15.sp,
                                    FontWeight.bold,
                                    themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontStyle.normal),
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        ValueListenableBuilder(
                            valueListenable: controller.email,
                            builder: (context, value, child) {
                              return Text(
                                "$value",
                                style: textStyle(
                                    15.sp,
                                    FontWeight.bold,
                                    themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontStyle.normal),
                              );
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            width: width * 0.9,
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
                                      ValueListenableBuilder(
                                          valueListenable: controller.systemID,
                                          builder: (context, value, child) {
                                            return Text(
                                              "$value",
                                              style: textStyle(
                                                  15.sp,
                                                  FontWeight.bold,
                                                  themeProvider.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  FontStyle.normal),
                                            );
                                          }),
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
                                      ValueListenableBuilder(
                                          valueListenable: controller.gender,
                                          builder: (context, value, child) {
                                            return Text(
                                              "$value",
                                              style: textStyle(
                                                  15.sp,
                                                  FontWeight.bold,
                                                  themeProvider.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  FontStyle.normal),
                                            );
                                          }),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Events Created : ",
                                        style: textStyle(
                                            12.sp,
                                            FontWeight.w400,
                                            themeProvider.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            FontStyle.normal),
                                      ),
                                      ValueListenableBuilder(
                                          valueListenable: controller.events,
                                          builder: (context, value, child) {
                                            return Text(
                                              "$value",
                                              style: textStyle(
                                                  15.sp,
                                                  FontWeight.bold,
                                                  themeProvider.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  FontStyle.normal),
                                            );
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
