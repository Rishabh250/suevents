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
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Student%20API/authentication_api.dart';
import 'package:suevents/View/no_connection.dart';

import '../../../Controller/Internet Connection/connection_provider.dart';
import '../../../Controller/SharedPreferences/token.dart';
import '../../../Controller/Student_Controllers/events_controller.dart';
import '../../../Models/Student API/student_api.dart';
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
            ? Scaffold(
                body: FutureBuilder(
                    future: userDetailsController.fetchUserData(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        EasyLoading.show();
                        return Container();
                      }
                      if (userDetailsController.user != null) {
                        EasyLoading.dismiss();
                        return CustomScrollView(
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
                                          valueListenable:
                                              userDetailsController.userImage,
                                          builder: (context, value, child) {
                                            return "$value" == ""
                                                ? CircleAvatar(
                                                    radius: 50,
                                                    backgroundImage:
                                                        ExactAssetImage(
                                                      userDetailsController
                                                                  .gender
                                                                  .value ==
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
                                      valueListenable:
                                          userDetailsController.name,
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
                                      valueListenable:
                                          userDetailsController.email,
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
                                      valueListenable:
                                          userDetailsController.systemID,
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
                                                      userDetailsController
                                                          .course,
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
                                                "Course",
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
                                                      userDetailsController
                                                          .year,
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
                                          Column(
                                            children: [
                                              ValueListenableBuilder(
                                                  valueListenable:
                                                      userDetailsController
                                                          .events,
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
                                        ]),
                                  )),

                                  // const SizedBox(
                                  //   height: 30,
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 10.0),
                                  //   child: Row(
                                  //     children: [
                                  //       Text(
                                  //         "Applied Events",
                                  //         style: Theme.of(context)
                                  //             .textTheme
                                  //             .headline1,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 10.0, right: 10),
                                  //   child: StudentEvents(
                                  //     token: userDetailsController.token,
                                  //     width: width,
                                  //     textScale: textScale,
                                  //     themeProvider: themeProvider,
                                  //   ),
                                  // )
                                ],
                              ),
                            )
                          ],
                        );
                      }

                      return const Center(
                        child: Text("Something went wrong"),
                      );
                    })),
              )
            : const NoInternet());
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
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[400]!,
                        ),
                      ),
                    ),
                  )),
            );
          }
          return SizedBox(
            width: _width,
            child: eventData["eventsApplied"].length == 0
                ? Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        width: _width * 0.9,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.2,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : const Color.fromARGB(255, 151, 194, 8)),
                            borderRadius: BorderRadius.circular(10),
                            color: themeProvider.isDarkMode
                                ? HexColor("#020E26")
                                : Colors.white),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "You havn'e applied any event yet...",
                              style: textStyle(
                                  10.sp,
                                  FontWeight.w700,
                                  themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  FontStyle.normal),
                            ),
                          ),
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
