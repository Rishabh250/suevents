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
import 'package:suevents/Controller/Faculty%20Controller/faculty_controller.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Faculty%20API/faculty_auth.dart';
import 'package:suevents/View/Faculty%20Portal/Home%20Page/homepage.dart';
import 'package:suevents/View/Faculty%20Portal/Profile%20Page/event_created.dart';
import 'package:suevents/View/get_started.dart';
import 'package:suevents/View/no_connection.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
                body: CustomScrollView(
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
                        Stack(
                          children: [
                            ValueListenableBuilder(
                                valueListenable: controller.userImage,
                                builder: (context, value, child) {
                                  return "$value" == ""
                                      ? const CircleAvatar(
                                          radius: 50,
                                          backgroundImage: ExactAssetImage(
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const FacultyEventCreated(),
                                        transition: Transition.fadeIn);
                                  },
                                  child: Column(
                                    children: [
                                      ValueListenableBuilder(
                                          valueListenable:
                                              facultyController.events,
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
                                            facultyController.systemID,
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
                        const SizedBox(
                          height: 70,
                        ),
                        ListTile(
                          onTap: () async {
                            final mailtoLink = Mailto(
                              to: ['rishu25bansal@gmail.com'],
                              subject: 'Faculty Help & Support',
                              body:
                                  'Hi,\n Myself ${facultyController.name} from ${facultyController.systemID} \n',
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
                              subject: 'Faculty Report Bug',
                              body:
                                  'Hi,\n Myself ${facultyController.name} from ${facultyController.systemID} \n',
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
              ))
            : const NoInternet());
  }
}
