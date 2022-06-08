import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/AESEncryption/aes_encryption.dart';

import '../../../Controller/providers/const.dart';
import '../../../Controller/providers/theme_service.dart';
import '../../../Models/Faculty API/faculty_api.dart';

class AttendanceEventDetails extends StatefulWidget {
  var event;
  AttendanceEventDetails({Key? key, required this.event}) : super(key: key);

  @override
  State<AttendanceEventDetails> createState() => _AttendanceEventDetailsState();
}

class _AttendanceEventDetailsState extends State<AttendanceEventDetails> {
  AESEncryption aesEncryption = AESEncryption();
  late int _currentIndex;
  late int currentPage;
  late PageController pageController;
  var roundID, eventID, eventData, roundData, encrptyData;

  var currentDate =
      DateTime.now().toString().replaceRange(11, 26, "").split("-");
  String finalDate = "";
  bool isVisible = false;
  var qrCodeData;
  List emailList = [];
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

  @override
  void initState() {
    currentPage = widget.event["rounds"].length - 1;
    _currentIndex = currentPage;
    pageController = PageController(initialPage: currentPage);
    finalDate =
        "${currentDate[2]}${months[int.parse(currentDate[1]) - 1]}, ${currentDate[0]} ";
    super.initState();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back_ios)),
          pinned: true,
          forceElevated: true,
          flexibleSpace: const FlexibleSpaceBar(
            centerTitle: true,
          ),
          elevation: 8,
          backgroundColor: const Color.fromARGB(255, 30, 0, 255),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          title: Text(
            widget.event["title"],
            style: textStyle(
                14.sp, FontWeight.bold, Colors.white, FontStyle.normal),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Rounds",
                style: textStyle(
                    18.sp,
                    FontWeight.w700,
                    themeProvider.isDarkMode ? Colors.white : Colors.black,
                    FontStyle.normal),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: width,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.event['rounds'].length,
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

                          // [widget.index]["rounds"][_currentIndex]
                          //     ["selectedStudends"];
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: height * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    // itemCount: 5,
                    itemCount: widget.event['rounds'].length,
                    itemBuilder: (BuildContext context, int index) {
                      roundID = widget.event['rounds'][index]["_id"];
                      eventID = widget.event["_id"];

                      return StreamBuilder(
                          stream: fetchAssignedEvents(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              EasyLoading.show();
                              return Container();
                            }
                            EasyLoading.dismiss();
                            if (eventData != null) {
                              EasyLoading.dismiss();

                              emailList.clear();
                              for (int i = 0;
                                  i <
                                      eventData["events"][index]
                                              ["unselectedStudends"]
                                          .length;
                                  i++) {
                                emailList.add(eventData["events"][index]
                                    ["unselectedStudends"][i]["email"]);
                              }
                              Map createqrData = {
                                "Date": eventData["events"][index]["date"]
                                    .toString(),
                                "Round Number": eventData["events"][index]
                                        ["roundNumber"]
                                    .toString(),
                                "list": emailList
                              };
                              qrCodeData = jsonEncode(createqrData);
                              encrptyData =
                                  aesEncryption.encryptMsg(qrCodeData).base16;

                              return ListView(
                                children: [
                                  eventData["events"][index]["showQRCode"] ==
                                          true
                                      ? Center(
                                          child: Container(
                                            color: Colors.white,
                                            child: QrImage(
                                              data: encrptyData,
                                              gapless: true,
                                              dataModuleStyle:
                                                  const QrDataModuleStyle(
                                                      color: Colors.black,
                                                      dataModuleShape:
                                                          QrDataModuleShape
                                                              .square),
                                              eyeStyle: const QrEyeStyle(
                                                  eyeShape: QrEyeShape.circle,
                                                  color: Colors.black),
                                                  
                                              version: QrVersions.auto,
                                              size: 200.0,
                                            ),
                                          ),
                                        )
                                      : MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          elevation: 8,
                                          onPressed: () async {},
                                          child: Center(
                                              child: eventData["events"][index]
                                                          ["status"] ==
                                                      "open"
                                                  ? Text(
                                                      "QR Code will availabe on ${eventData["events"][index]["date"]} at ${eventData["events"][index]["time"]}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: textStyle(
                                                          12.sp,
                                                          FontWeight.bold,
                                                          themeProvider.isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                          FontStyle.normal))
                                                  : Text("Round Close",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: textStyle(
                                                          12.sp,
                                                          FontWeight.bold,
                                                          themeProvider
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                          FontStyle.normal))),
                                        ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Center(
                                    child: Card(
                                      color: !themeProvider.isDarkMode
                                          ? HexColor("F3F6F9")
                                          : HexColor("#010A1C"),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SizedBox(
                                        width: width * 0.9,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Total Students : ",
                                                    style: textStyle(
                                                        12.sp,
                                                        FontWeight.bold,
                                                        themeProvider.isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        FontStyle.normal),
                                                  ),
                                                  Text(
                                                      widget
                                                          .event["studentLeft"]
                                                          .length
                                                          .toString(),
                                                      style: textStyle(
                                                          12.sp,
                                                          FontWeight.w500,
                                                          themeProvider
                                                                  .isDarkMode
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
                                                    "Attendance Taken : ",
                                                    style: textStyle(
                                                        12.sp,
                                                        FontWeight.bold,
                                                        themeProvider.isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        FontStyle.normal),
                                                  ),
                                                  Text(
                                                      eventData["events"][index]
                                                              [
                                                              "selectedStudends"]
                                                          .length
                                                          .toString(),
                                                      style: textStyle(
                                                          12.sp,
                                                          FontWeight.w500,
                                                          Colors.green,
                                                          FontStyle.normal))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Student Left : ",
                                                    style: textStyle(
                                                        12.sp,
                                                        FontWeight.bold,
                                                        themeProvider.isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        FontStyle.normal),
                                                  ),
                                                  Text(
                                                      eventData["events"][index]
                                                              [
                                                              "unselectedStudends"]
                                                          .length
                                                          .toString(),
                                                      style: textStyle(
                                                          12.sp,
                                                          FontWeight.w500,
                                                          Colors.red,
                                                          FontStyle.normal))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Card(
                                      color: !themeProvider.isDarkMode
                                          ? HexColor("F3F6F9")
                                          : HexColor("#010A1C"),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SizedBox(
                                        width: width * 0.9,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Lab  : ",
                                                    style: textStyle(
                                                        12.sp,
                                                        FontWeight.w300,
                                                        themeProvider.isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        FontStyle.normal),
                                                  ),
                                                  Text(
                                                      eventData["events"][index]
                                                              ["lab"]
                                                          .toString(),
                                                      style: textStyle(
                                                          12.sp,
                                                          FontWeight.w500,
                                                          themeProvider
                                                                  .isDarkMode
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
                                                    "Round Type : ",
                                                    style: textStyle(
                                                        12.sp,
                                                        FontWeight.w300,
                                                        themeProvider.isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        FontStyle.normal),
                                                  ),
                                                  Text(
                                                      eventData["events"][index]
                                                              ["testType"]
                                                          .toString(),
                                                      style: textStyle(
                                                          12.sp,
                                                          FontWeight.w500,
                                                          themeProvider
                                                                  .isDarkMode
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
                                                    "Date : ",
                                                    style: textStyle(
                                                        12.sp,
                                                        FontWeight.w300,
                                                        themeProvider.isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        FontStyle.normal),
                                                  ),
                                                  Text(
                                                      eventData["events"][index]
                                                              ["date"]
                                                          .toString(),
                                                      style: textStyle(
                                                          12.sp,
                                                          FontWeight.w500,
                                                          themeProvider
                                                                  .isDarkMode
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
                                                    "Time : ",
                                                    style: textStyle(
                                                        12.sp,
                                                        FontWeight.w300,
                                                        themeProvider.isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        FontStyle.normal),
                                                  ),
                                                  Text(
                                                      eventData["events"][index]
                                                              ["time"]
                                                          .toString(),
                                                      style: textStyle(
                                                          12.sp,
                                                          FontWeight.w500,
                                                          themeProvider
                                                                  .isDarkMode
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
                                  ),
                                ],
                              );
                            }
                            return Container();
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  Stream fetchAssignedEvents() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      yield eventData = await getSingleEvent(eventID);
    }
  }
}
