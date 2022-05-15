import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/providers/const.dart';

import '../../../DB Connectivity/api/authentication_api.dart';
import '../../../providers/theme_service.dart';

class EventRounds extends StatefulWidget {
  const EventRounds({Key? key}) : super(key: key);

  @override
  State<EventRounds> createState() => _EventRoundsState();
}

class _EventRoundsState extends State<EventRounds> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final ScrollController _scrollController = ScrollController();
  late PageController pageController;
  var user, eventData = Get.arguments;
  late int _currentIndex;
  late int currentPage;
  Barcode? result;
  QRViewController? controller;
  String email = "", systemID = "", attendence = "Not Taken", name = "";
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    currentPage = eventData["event"]["rounds"].length - 1;
    _currentIndex = currentPage;
    pageController = PageController(initialPage: currentPage);
    fetchUserData();
    checkAttendence();
  }

  fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("accessToken");
    user = await getUserData(token);
    setState(() {
      email = user["user"]["email"];
      systemID = user["user"]["systemID"];
    });
    return user;
  }

  getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("accessToken");
    user = await getUserData(token);
    return user;
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: CustomScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Rounds",
                  style: textStyle(
                      18.sp,
                      FontWeight.w700,
                      themeProvider.isDarkMode ? Colors.white : Colors.black,
                      FontStyle.normal),
                ),
                SizedBox(
                  height: 50,
                  width: _width,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: eventData["event"]['rounds'].length,
                      // itemCount: 5,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              isVisible = false;
                              _currentIndex = index;
                              pageController.animateToPage(_currentIndex,
                                  curve: Curves.easeIn,
                                  duration: const Duration(milliseconds: 500));
                            });
                            log(_currentIndex.toString());

                            await fetchUserData();
                            await checkAttendence();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: _currentIndex == index
                                      ? Colors.blue
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: textStyle(
                                      15.0,
                                      FontWeight.bold,
                                      _currentIndex == index
                                          ? Colors.white
                                          : const Color.fromARGB(255, 0, 0, 0),
                                      FontStyle.normal),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: _height * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: pageController,
                        scrollDirection: Axis.horizontal,
                        // itemCount: 5,
                        itemCount: eventData["event"]['rounds'].length,
                        itemBuilder: (context, index) {
                          return ListView(
                            controller: _scrollController,
                            shrinkWrap: true,
                            children: [
                              Card(
                                color: Colors.transparent,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  width: _width,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.amber),
                                  child: Visibility(
                                    visible: isVisible,
                                    replacement: FutureBuilder(
                                        future: getUser(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child: CircularProgressIndicator
                                                  .adaptive(),
                                            );
                                          }
                                          if (snapshot.hasData) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  user["user"]["name"],
                                                  style: textStyle(
                                                      12.sp,
                                                      FontWeight.bold,
                                                      _currentIndex == index
                                                          ? Colors.white
                                                          : const Color
                                                                  .fromARGB(
                                                              255, 0, 0, 0),
                                                      FontStyle.normal),
                                                ),
                                                Text(
                                                  user["user"]["email"],
                                                  style: textStyle(
                                                      12.sp,
                                                      FontWeight.bold,
                                                      _currentIndex == index
                                                          ? Colors.white
                                                          : const Color
                                                                  .fromARGB(
                                                              255, 0, 0, 0),
                                                      FontStyle.normal),
                                                ),
                                                Text(
                                                  user["user"]["systemID"],
                                                  style: textStyle(
                                                      12.sp,
                                                      FontWeight.bold,
                                                      _currentIndex == index
                                                          ? Colors.white
                                                          : const Color
                                                                  .fromARGB(
                                                              255, 0, 0, 0),
                                                      FontStyle.normal),
                                                )
                                              ],
                                            );
                                          }
                                          return const Center(
                                            child: Text(
                                                "Something went wrong....\nPlease login again"),
                                          );
                                        }),
                                    child: QRView(
                                        overlay: QrScannerOverlayShape(
                                            borderWidth: 5,
                                            borderColor: Colors.white,
                                            borderLength: 40,
                                            borderRadius: 20),
                                        overlayMargin: const EdgeInsets.all(10),
                                        key: qrKey,
                                        onQRViewCreated: _onQRViewCreated),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MaterialButton(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.blue,
                                    onPressed: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    },
                                    child: isVisible == true
                                        ? Text("Hide Scanner",
                                            style: textStyle(
                                                12.sp,
                                                FontWeight.bold,
                                                Colors.white,
                                                FontStyle.normal))
                                        : Text("Show Scanner",
                                            style: textStyle(
                                                12.sp,
                                                FontWeight.bold,
                                                Colors.white,
                                                FontStyle.normal)),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        flipCam();
                                      },
                                      child: const Icon(Icons.flip_camera_ios)),
                                  GestureDetector(
                                      onTap: () {
                                        flashLight();
                                      },
                                      child: const Icon(Icons.flashlight_on))
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Round " +
                                    eventData["event"]['rounds'][index]
                                            ["roundNumber"]
                                        .toString(),
                                style: textStyle(
                                    18.sp,
                                    FontWeight.bold,
                                    themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontStyle.normal),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: Colors.transparent,
                                child: Container(
                                  width: _width * 0.95,
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
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Lab : " +
                                                eventData["event"]['rounds']
                                                    [index]["lab"],
                                            style: textStyle(
                                                12.sp,
                                                FontWeight.w600,
                                                themeProvider.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                FontStyle.normal)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "Test Type : " +
                                                eventData["event"]['rounds']
                                                    [index]["testType"],
                                            style: textStyle(
                                                12.sp,
                                                FontWeight.w600,
                                                themeProvider.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                FontStyle.normal)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "Round Date : " +
                                                eventData["event"]['rounds']
                                                    [index]["date"],
                                            style: textStyle(
                                                12.sp,
                                                FontWeight.w600,
                                                themeProvider.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                FontStyle.normal))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Attendence : ",
                                      style: textStyle(
                                          12.sp,
                                          FontWeight.w600,
                                          themeProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          FontStyle.normal)),
                                  Text(attendence,
                                      style: textStyle(
                                          12.sp,
                                          FontWeight.bold,
                                          attendence == "Present"
                                              ? const Color.fromARGB(
                                                  255, 7, 186, 10)
                                              : Colors.red,
                                          FontStyle.normal)),
                                ],
                              )
                            ],
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  checkAttendence() {
    if (eventData["event"]['rounds'][_currentIndex]["selectedStudends"].length >
        0) {
      for (int i = 0;
          i <
              eventData["event"]['rounds'][_currentIndex]["selectedStudends"]
                  .length;
          i++) {
        if (eventData["event"]['rounds'][_currentIndex]["selectedStudends"][i]
                ["email"]
            .toString()
            .contains(email)) {
          setState(() {
            attendence = "Present";
          });
        } else {
          setState(() {
            attendence = "Not Taken";
          });
        }
      }
    } else {
      setState(() {
        attendence = "Not Taken";
      });
    }
  }

  void _onQRViewCreated(controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      log(result!.code.toString());
    });
  }

  void flipCam() {
    log("asda");
    controller?.flipCamera();
  }

  void flashLight() {
    controller?.toggleFlash();
  }
}
