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
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Faculty%20API/faculty_auth.dart';
import 'package:suevents/Models/Student%20API/student_api.dart';

class FacultyProfilePage extends StatefulWidget {
  const FacultyProfilePage({Key? key}) : super(key: key);

  @override
  State<FacultyProfilePage> createState() => _FacultyProfilePageState();
}

class _FacultyProfilePageState extends State<FacultyProfilePage> {
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
    user = await getFacultyData(token);
    log(user.toString());
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
              EasyLoading.show(dismissOnTap: false);
              return Container();
            }
            if (user != null) {
              EasyLoading.dismiss(animation: true);

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
                                          await facultyUploadImage(
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
                                          await facultyUploadImage(
                                              token, imageURL.toString());
                                          setState(() {});
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
                                        "Events Created : ",
                                        style: textStyle(
                                            12.sp,
                                            FontWeight.w400,
                                            themeProvider.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            FontStyle.normal),
                                      ),
                                      Text(
                                          user["user"]["eventsCreated"]
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

class StudentEvents extends StatelessWidget {
  StudentEvents({
    Key? key,
    required this.token,
    required double width,
    required this.textScale,
    required this.themeProvider,
  })  : _width = width,
        super(key: key);

  final token;
  final double _width;
  final double textScale;
  final ThemeProvider themeProvider;
  var eventData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchAllEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                  width: _width * 0.9,
                  height: 100,
                  child: Shimmer.fromColors(
                    baseColor:
                        themeProvider.isDarkMode ? Colors.black : Colors.white,
                    highlightColor: Colors.grey,
                    period: const Duration(seconds: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[400]!,
                      ),
                    ),
                  )),
            );
          }
          return SizedBox(
            width: _width,
            height: 320,
            child: eventData["eventsApplied"].length == 0
                ? Card(
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
                                    : const Color.fromARGB(255, 151, 194, 8)),
                            borderRadius: BorderRadius.circular(20),
                            color: themeProvider.isDarkMode
                                ? HexColor("#020E26")
                                : Colors.white),
                        child: const Center(
                          child: Text("You havn'e applied any event yet..."),
                        )),
                  )
                : ShaderMask(
                    shaderCallback: (Rect rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.purple,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.purple
                        ],
                        stops: [
                          0.0,
                          0.1,
                          0.9,
                          1.0
                        ], // 10% purple, 80% transparent, 10% purple
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: eventData["eventsApplied"].length,
                        itemBuilder: (context, index) {
                          return Card(
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
                                      ? HexColor("#020E26")
                                      : Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      eventData["eventsApplied"][index]
                                          ["title"],
                                      style: textStyle(
                                          14.sp,
                                          FontWeight.w700,
                                          themeProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          FontStyle.normal),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Date : " +
                                          eventData["eventsApplied"][index]
                                              ["startDate"],
                                      style: textStyle(
                                          10.sp,
                                          FontWeight.w700,
                                          themeProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          FontStyle.normal),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Price :  " +
                                              eventData["eventsApplied"][index]
                                                  ["eventPrice"],
                                          style: textStyle(
                                              10.sp,
                                              FontWeight.w700,
                                              themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontStyle.normal),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
          );
        });
  }

  fetchAllEvents() async {
    eventData = await getStudentEvents(token);
    return eventData;
  }
}
