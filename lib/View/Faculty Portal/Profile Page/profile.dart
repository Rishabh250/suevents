import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/Faculty%20Controller/faculty_controller.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Faculty%20API/faculty_auth.dart';
import 'package:suevents/View/Faculty%20Portal/Home%20Page/homepage.dart';
import 'package:suevents/View/get_started.dart';
import 'package:suevents/View/no_connection.dart';

import '../../../Controller/Internet Connection/connection_provider.dart';
import '../../../Controller/SharedPreferences/token.dart';

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
          debugPrint(error.toString());
        }
      }
    } catch (err) {
      if (kDebugMode) {
        debugPrint(err.toString());
      }
    }
  }

  @override
  void initState() {
    Provider.of<ConnectivityProvider>(context, listen: false).startMontering();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Consumer<ConnectivityProvider>(
        builder: (context, value, child) => value.isOnline
            ? Scaffold(
                body: FutureBuilder(
                    future: controller.fetchFacultyData(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        EasyLoading.show();
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
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          loginStatus(false);
                                          accessToken("");
                                          Get.offAll(() => const Getstarted());
                                        },
                                        child:
                                            const Icon(Icons.logout_rounded)),
                                  )
                                ],
                                leading: GestureDetector(
                                  onTap: () => Get.back(),
                                  child: const Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: Colors.white),
                                )),
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      ValueListenableBuilder(
                                          valueListenable: controller.userImage,
                                          builder: (context, value, child) {
                                            return "$value" == ""
                                                ? const CircleAvatar(
                                                    radius: 50,
                                                    backgroundImage:
                                                        ExactAssetImage(
                                                      "assets/images/faculty.png",
                                                    ),
                                                  )
                                                : CircleAvatar(
                                                    radius: 12.w,
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
                                                  controller.token,
                                                  imageURL.value);
                                              await controller
                                                  .fetchFacultyData();
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
                                      valueListenable: facultyController.name,
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
                                      valueListenable: facultyController.email,
                                      builder: (context, value, child) {
                                        return Text(
                                          "$value",
                                          style: textStyle(
                                              10.sp,
                                              FontWeight.w600,
                                              themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontStyle.normal),
                                        );
                                      }),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Center(
                                      child: SizedBox(
                                    width: width * 0.9,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              ValueListenableBuilder(
                                                  valueListenable:
                                                      facultyController.events,
                                                  builder:
                                                      (context, value, child) {
                                                    return Text("$value",
                                                        style: textStyle(
                                                            12.sp,
                                                            FontWeight.bold,
                                                            themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontStyle.normal));
                                                  }),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Events Created",
                                                style: textStyle(
                                                    10.sp,
                                                    FontWeight.w400,
                                                    themeProvider.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                    FontStyle.normal),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: 1,
                                            height: 20,
                                            color: themeProvider.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          Column(
                                            children: [
                                              ValueListenableBuilder(
                                                  valueListenable:
                                                      facultyController
                                                          .systemID,
                                                  builder:
                                                      (context, value, child) {
                                                    return Text("$value",
                                                        style: textStyle(
                                                            12.sp,
                                                            FontWeight.bold,
                                                            themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontStyle.normal));
                                                  }),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "System ID",
                                                style: textStyle(
                                                    10.sp,
                                                    FontWeight.w400,
                                                    themeProvider.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                    FontStyle.normal),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  )),
                                ],
                              ),
                            )
                          ],
                        );
                      }

                      return const Center(child: Text("Something went wrong"));
                    })),
              )
            : const NoInternet());
  }
}
