// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/AESEncryption/aes_encryption.dart';
import 'package:suevents/Controller/Student_Controllers/events_controller.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';

import '../../../../Models/Student API/student_api.dart';
import '../../../Controller/providers/global_snackbar.dart';

class EventRounds extends StatefulWidget {
  var events;
  var index;

  EventRounds({key, required this.events, required this.index})
      : super(key: key);

  @override
  State<EventRounds> createState() => _EventRoundsState();
}

class _EventRoundsState extends State<EventRounds> {
  AESEncryption aesEncryption = AESEncryption();
  EventController eventController = EventController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final ScrollController _scrollController = ScrollController();
  late PageController pageController;
  var user, token, eventDetail, getEvent;
  late int _currentIndex;
  late int currentPage;
  final String _scanBarcode = 'Unknown';
  var currentDate =
      DateTime.now().toString().replaceRange(11, 26, "").split("-");
  String finalDate = "";
  List months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final key = encrypt.Key.fromUtf8('my 32 length key................');
  final iv = IV.fromLength(16);
  bool isVisible = false;
  var roundID, eventID, eventData, roundData, encrypter, decrypted;
  @override
  void initState() {
    super.initState();
    encrypter = Encrypter(AES(key));
    EasyLoading.show();
    currentPage = widget.events["rounds"].length - 1;
    _currentIndex = currentPage;
    pageController = PageController(initialPage: currentPage);
    eventController.userData();
    finalDate =
        "${currentDate[2]}${months[int.parse(currentDate[1]) - 1]}, ${currentDate[0]} ";
    log(finalDate);
    fetchEvents();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    _scrollController.dispose();
    eventController.name.dispose();
    eventController.email.dispose();
    eventController.systemID.dispose();
    eventController.attendence.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
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
                  width: width,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.events['rounds'].length,
                      // itemCount: 5,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            EasyLoading.show();
                            setState(() {
                              isVisible = false;
                              _currentIndex = index;
                              pageController.animateToPage(_currentIndex,
                                  curve: Curves.easeIn,
                                  duration: const Duration(milliseconds: 500));
                            });
                            log(_currentIndex.toString());
                            await fetchEvents();
                            var event = roundData["present"];
                            log("Rishabh : $event");
                            // [widget.index]["rounds"][_currentIndex]
                            //     ["present"];
                            await eventController.checkAttendence(
                                event, eventController.email.value);
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
                  height: height * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: pageController,
                        scrollDirection: Axis.horizontal,
                        // itemCount: 5,
                        itemCount: widget.events['rounds'].length,
                        itemBuilder: (context, index) {
                          roundID = widget.events['rounds'][index]["_id"];
                          eventID = widget.events["_id"];

                          return ListView(
                            padding: const EdgeInsets.only(bottom: 50),
                            shrinkWrap: true,
                            children: [
                              Card(
                                  color: Colors.transparent,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    width: width,
                                    height: 300,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              HexColor("7ec9f5")
                                                  .withOpacity(0.5),
                                              HexColor("3957ed")
                                                  .withOpacity(0.5)
                                            ])),
                                    child: Visibility(
                                      visible: isVisible,
                                      replacement: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ValueListenableBuilder(
                                            valueListenable:
                                                eventController.name,
                                            builder: (context, value, child) {
                                              return Text(
                                                "$value",
                                                style: textStyle(
                                                    12.sp,
                                                    FontWeight.bold,
                                                    themeProvider.isDarkMode
                                                        ? Colors.white
                                                        : const Color.fromARGB(
                                                            255, 0, 0, 0),
                                                    FontStyle.normal),
                                              );
                                            },
                                          ),
                                          ValueListenableBuilder(
                                            valueListenable:
                                                eventController.email,
                                            builder: (context, value, child) {
                                              return SizedBox(
                                                width: width * 0.9,
                                                child: Center(
                                                  child: Text(
                                                    "$value",
                                                    textAlign: TextAlign.center,
                                                    style: textStyle(
                                                        12.sp,
                                                        FontWeight.bold,
                                                        themeProvider.isDarkMode
                                                            ? Colors.white
                                                            : const Color
                                                                    .fromARGB(
                                                                255, 0, 0, 0),
                                                        FontStyle.normal),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          ValueListenableBuilder(
                                            valueListenable:
                                                eventController.systemID,
                                            builder: (context, value, child) {
                                              return Text(
                                                "$value",
                                                style: textStyle(
                                                    12.sp,
                                                    FontWeight.bold,
                                                    themeProvider.isDarkMode
                                                        ? Colors.white
                                                        : const Color.fromARGB(
                                                            255, 0, 0, 0),
                                                    FontStyle.normal),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      child: Container(),
                                    ),
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MaterialButton(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.blue,
                                    onPressed: !finalDate.contains(widget
                                            .events['rounds'][index]["date"]
                                            .toString())
                                        ? null
                                        : onQRViewCreated,
                                    child: !finalDate.contains(widget
                                            .events['rounds'][index]["date"]
                                            .toString())
                                        ? Text("",
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
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          // flipCam();
                                        },
                                        child:
                                            const Icon(Icons.flip_camera_ios)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Round ${widget.events['rounds'][index]["roundNumber"]}",
                                      style: textStyle(
                                          18.sp,
                                          FontWeight.bold,
                                          themeProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          FontStyle.normal),
                                    ),
                                  ],
                                ),
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
                                  width: width * 0.95,
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
                                            "Lab : ${widget.events['rounds'][index]["lab"]}",
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
                                            "Test Type : ${widget.events['rounds'][index]["testType"]}",
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
                                            "Round Date : ${widget.events['rounds'][index]["date"]}",
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
                              Center(
                                child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.transparent,
                                  child: Container(
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
                                    width: width * 0.95,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Attendence : ",
                                              style: textStyle(
                                                  12.sp,
                                                  FontWeight.w600,
                                                  themeProvider.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  FontStyle.normal)),
                                          ValueListenableBuilder(
                                              valueListenable:
                                                  eventController.attendence,
                                              builder: (context, value, child) {
                                                return Text("$value",
                                                    style: textStyle(
                                                        12.sp,
                                                        FontWeight.bold,
                                                        "$value" == "Present"
                                                            ? const Color
                                                                    .fromARGB(
                                                                255, 7, 186, 10)
                                                            : Colors.red,
                                                        FontStyle.normal));
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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

  var scanResult;

  Future onQRViewCreated() async {
    var getAppliedData = await getSingleEvents(eventID);

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;

    setState(() => scanResult = scanResult);
    if (scanResult.toString() == "-1" || scanResult == null) return;

    var getdata = aesEncryption.decryptMsg(aesEncryption.getCode(scanResult));
    Map data = jsonDecode(getdata);

    if (finalDate.toString().contains(data["Date"].toString())) {
      if (widget.events['rounds'][_currentIndex]["roundNumber"].toString() ==
          data["Round Number"]) {
        for (int i = 0;
            i < getAppliedData["events"]["appliedStudents"].length;
            i++) {
          if (data["list"].toString().contains(
              getAppliedData["events"]["appliedStudents"][i]["email"])) {
            log(data["list"]
                .toString()
                .contains(getAppliedData["events"]["appliedStudents"][i]
                        ["email"]
                    .toString())
                .toString());
            await takeAttendence();
          }
        }
      } else {
        showError("Invalid QR Code", "");
        return;
      }
    } else {
      showError("Invalid QR Code", "");
      return;
    }
  }

  takeAttendence() async {
    // controller?.stopCamera();
    EasyLoading.show();
    await applyForRound(token, eventID, roundID);
    await fetchEvents();
    await eventController.fetchUserData(getEvent);
    EasyLoading.dismiss();
  }

  fetchEvents() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
    eventDetail = await getStudentEvents(token);
    roundData = await getSingleRound(eventID, roundID);
    getEvent = roundData["present"];
    log(getEvent.toString());
    eventController.fetchUserData(getEvent);
  }
}
