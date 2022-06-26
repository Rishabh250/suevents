import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailto/mailto.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Student%20API/authentication_api.dart';
import 'package:suevents/View/Student%20Portal/Navigation%20Bar/navigation_bar.dart';
import 'package:suevents/View/Student%20Portal/Profile%20Page/all_events.dart';
import 'package:suevents/View/Student%20Portal/Profile%20Page/edit_profile.dart';
import 'package:suevents/View/no_connection.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../Controller/Internet Connection/connection_provider.dart';
import '../../../Controller/SharedPreferences/token.dart';
import '../../../Controller/Student_Controllers/events_controller.dart';
import '../../get_started.dart';

UserDetailsController userDetailsController = UserDetailsController();

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseStorage storage = FirebaseStorage.instance;
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Consumer<ConnectivityProvider>(
        builder: (context, value, child) => value.isOnline
            ? WillPopScope(
                onWillPop: () {
                  Get.offAll(() => const NavigationBarPage(),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 500));
                  return Future.value(true);
                },
                child: Scaffold(
                    body: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
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
                                  Get.offAll(() => const EditProfilePage(),
                                      transition: Transition.fadeIn);
                                },
                                child: const Icon(Icons.edit)),
                          )
                        ],
                        leading: GestureDetector(
                          onTap: () async {
                            Get.offAll(() => const NavigationBarPage());
                          },
                          child: Icon(Icons.arrow_back_ios_rounded,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        )),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              ValueListenableBuilder(
                                  valueListenable:
                                      userDetailsController.userImage,
                                  builder: (context, value, child) {
                                    return "$value" == ""
                                        ? CircleAvatar(
                                            radius: 50,
                                            backgroundImage: ExactAssetImage(
                                              userDetailsController
                                                          .gender.value ==
                                                      "Male"
                                                  ? "assets/images/boy.png"
                                                  : "assets/images/girl.png",
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
                                      await uploadProfileImage(
                                          userDetailsController.token,
                                          imageURL.value);
                                      await userDetailsController
                                          .fetchUserData();
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
                            height: 5,
                          ),
                          ValueListenableBuilder(
                              valueListenable: userDetailsController.course,
                              builder: (context, value, child) {
                                return SizedBox(
                                  child: Text("$value",
                                      maxLines: 1,
                                      style: textStyle(
                                          12.sp,
                                          FontWeight.bold,
                                          themeProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          FontStyle.normal)),
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
                                        FontWeight.w600,
                                        themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        FontStyle.normal));
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
                                              userDetailsController.year,
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
                                        height: 10,
                                      ),
                                      Text(
                                        "Year",
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
                                  GestureDetector(
                                    onTap: () => userDetailsController
                                                .events.value !=
                                            0
                                        ? Get.to(
                                            () => const StudentAppliedEvents(),
                                            transition: Transition.fadeIn)
                                        : null,
                                    child: Column(
                                      children: [
                                        ValueListenableBuilder(
                                            valueListenable:
                                                userDetailsController.events,
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
                                          height: 10,
                                        ),
                                        Text(
                                          "Applied",
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
                                  ),
                                ]),
                          )),
                          const SizedBox(
                            height: 30,
                          ),
                          ListTile(
                            onTap: () async {
                              final mailtoLink = Mailto(
                                to: ['rishu25bansal@gmail.com'],
                                subject: 'Student Help & Support',
                                body:
                                    'Hi,\n Myself ${userDetailsController.name} from ${userDetailsController.course} ${userDetailsController.year}\n',
                              );
                              await launchUrlString('$mailtoLink');
                            },
                            title: Row(
                              children: [
                                const Icon(Icons.help_outline_rounded),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Help & Support",
                                  style: textStyle(
                                      12.sp,
                                      FontWeight.bold,
                                      themeProvider.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () async {
                              final mailtoLink = Mailto(
                                to: ['rishu25bansal@gmail.com'],
                                subject: 'Student Report Bug',
                                body:
                                    'Hi,\n Myself ${userDetailsController.name} from ${userDetailsController.course} ${userDetailsController.year}\n',
                              );
                              await launchUrlString('$mailtoLink');
                            },
                            title: Row(
                              children: [
                                const Icon(Icons.bug_report_rounded),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Report bugs and issue",
                                  style: textStyle(
                                      12.sp,
                                      FontWeight.bold,
                                      themeProvider.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              loginStatus(false);
                              accessToken("");
                              Get.offAll(() => const Getstarted());
                            },
                            title: Row(
                              children: [
                                const Icon(Icons.logout_rounded),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Logout",
                                  style: textStyle(
                                      12.sp,
                                      FontWeight.bold,
                                      themeProvider.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
              )
            : const NoInternet());
  }
}
