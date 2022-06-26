import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/global_snackbar.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/View/Student%20Portal/Profile%20Page/profile.dart';
import 'package:suevents/View/no_connection.dart';

import '../../../Controller/Internet Connection/connection_provider.dart';
import '../../../Controller/Student_Controllers/events_controller.dart';
import '../../../Models/Student API/authentication_api.dart';

UserDetailsController userDetailsController = UserDetailsController();

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController program = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController semester = TextEditingController();
  File? image;
  ValueNotifier imageURL = ValueNotifier("");
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

        imageURL.value = downloadURL.toString();
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
    super.initState();
    userDetailsController.fetchUserData();

    Provider.of<ConnectivityProvider>(context, listen: false).startMontering();
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.dismiss();

    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Consumer<ConnectivityProvider>(
        builder: (context, value, child) => value.isOnline
            ? WillPopScope(
                onWillPop: () {
                  Get.offAll(() => const ProfilePage(),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 500));
                  return Future.value(true);
                },
                child: Scaffold(
                  body: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                          elevation: 0,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          leading: GestureDetector(
                            onTap: () => Get.offAll(() => const ProfilePage()),
                            child: Icon(Icons.arrow_back_ios_rounded,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          )),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            ValueListenableBuilder(
                                valueListenable: userDetailsController.name,
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
                                valueListenable: userDetailsController.email,
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
                              height: 10,
                            ),
                            ValueListenableBuilder(
                                valueListenable: userDetailsController.systemID,
                                builder: (context, value, child) {
                                  return Text("$value",
                                      style: textStyle(
                                          12.sp,
                                          FontWeight.bold,
                                          themeProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          FontStyle.normal));
                                }),
                            const SizedBox(
                              height: 80,
                            ),
                            Center(
                                child: SizedBox(
                              width: width * 0.9,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable:
                                          userDetailsController.course,
                                      builder: (BuildContext context,
                                          dynamic value, Widget? child) {
                                        return TextField(
                                          textInputAction: TextInputAction.next,
                                          style: GoogleFonts.poppins(
                                              fontSize: 11.5.sp,
                                              fontWeight: FontWeight.w600),
                                          controller: program,
                                          keyboardType: TextInputType.text,
                                          enableSuggestions: true,
                                          decoration: InputDecoration(
                                              hintText: "Course : $value",
                                              hintStyle: GoogleFonts.poppins(
                                                  fontSize: 12.sp),
                                              border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable:
                                          userDetailsController.year,
                                      builder: (BuildContext context,
                                          dynamic value, Widget? child) {
                                        return TextField(
                                          textInputAction: TextInputAction.next,
                                          style: GoogleFonts.poppins(
                                              fontSize: 11.5.sp,
                                              fontWeight: FontWeight.w600),
                                          controller: year,
                                          keyboardType: TextInputType.text,
                                          enableSuggestions: true,
                                          decoration: InputDecoration(
                                              hintText: "Year : $value",
                                              hintStyle: GoogleFonts.poppins(
                                                  fontSize: 12.sp),
                                              border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable:
                                          userDetailsController.semester,
                                      builder: (BuildContext context,
                                          dynamic value, Widget? child) {
                                        return TextField(
                                          textInputAction: TextInputAction.done,
                                          style: GoogleFonts.poppins(
                                              fontSize: 11.5.sp,
                                              fontWeight: FontWeight.w600),
                                          controller: semester,
                                          keyboardType: TextInputType.text,
                                          enableSuggestions: true,
                                          decoration: InputDecoration(
                                              hintText: "Semester : $value",
                                              hintStyle: GoogleFonts.poppins(
                                                  fontSize: 12.sp),
                                              border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        MaterialButton(
                                          elevation: 8,
                                          color: const Color.fromARGB(
                                              255, 0, 8, 255),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          onPressed: () async {
                                            if (program.text
                                                .toString()
                                                .isEmpty) {
                                              program.text =
                                                  userDetailsController
                                                      .course.value
                                                      .toString();
                                            }
                                            if (year.text.toString().isEmpty) {
                                              year.text = userDetailsController
                                                  .year.value
                                                  .toString();
                                            }
                                            if (semester.text
                                                .toString()
                                                .isEmpty) {
                                              semester.text =
                                                  userDetailsController
                                                      .semester.value
                                                      .toString();
                                            } else {
                                              EasyLoading.show();

                                              await updateDetails(
                                                  userDetailsController
                                                      .id.value,
                                                  program.text.toString(),
                                                  year.text.toString(),
                                                  semester.text.toString());
                                              await userDetailsController
                                                  .fetchUserData();
                                              EasyLoading.dismiss();
                                              showConfirm(
                                                  "Profile Updated", "");
                                              setState(() {});
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text("Save",
                                                style: textStyle(
                                                    15.sp,
                                                    FontWeight.bold,
                                                    Colors.white,
                                                    FontStyle.normal)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const NoInternet());
  }
}
