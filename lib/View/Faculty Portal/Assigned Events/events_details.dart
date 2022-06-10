import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/AESEncryption/aes_encryption.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

import '../../../Controller/providers/const.dart';
import '../../../Controller/providers/global_snackbar.dart';
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
  ValueNotifier getIndex = ValueNotifier(0);
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
                            getIndex.value = index;

                            pageController.animateToPage(_currentIndex,
                                curve: Curves.easeIn,
                                duration: const Duration(milliseconds: 500));
                          });

                          // [widget.index]["rounds"][_currentIndex]
                          //     ["present"];
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
                                      eventData["events"][index]["absent"]
                                          .length;
                                  i++) {
                                emailList.add(eventData["events"][index]
                                    ["absent"][i]["email"]);
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
                                                      "QR Code will available on ${eventData["events"][index]["date"]} at ${eventData["events"][index]["time"]}",
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
                                                      eventData["events"][index]
                                                              ["totalStudent"]
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
                                                    "Present : ",
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
                                                              ["present"]
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
                                                    "Absent : ",
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
                                                              ["absent"]
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
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Please make sure to generate attendance",
                                    textAlign: TextAlign.center,
                                    style: textStyle(12.sp, FontWeight.w400,
                                        Colors.red, FontStyle.normal),
                                  ),
                                ],
                              );
                            }
                            return Container();
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
      floatingActionButton: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: const Color.fromARGB(255, 11, 0, 127),
          onPressed: generateAttendance,
          child: Text("Generate Attendance",
              style: textStyle(
                  12.sp, FontWeight.bold, Colors.white, FontStyle.normal))),
    );
  }

  Stream fetchAssignedEvents() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      yield eventData = await getSingleEvent(eventID);
    }
  }

  Future<void> generateAttendance() async {
    var presentSTD = eventData["events"][getIndex.value]["present"];
    var absentSTD = eventData["events"][getIndex.value]["absent"];
    if (presentSTD == null) {
      showError("Empty List", "You have not select any event");
      return;
    }
    EasyLoading.show();

    final excel.Workbook workbook = excel.Workbook();
    final excel.Worksheet worksheet = workbook.worksheets[0];

//Defining a global style with properties.
    final excel.Style globalStyle = workbook.styles.add('globalStyle');
    globalStyle.fontName = 'Times New Roman';
    globalStyle.fontSize = 12;
    globalStyle.fontColor = '#C67878';
    globalStyle.bold = true;
    globalStyle.wrapText = true;
    globalStyle.hAlign = excel.HAlignType.center;
    globalStyle.vAlign = excel.VAlignType.center;
    globalStyle.borders.all.lineStyle = excel.LineStyle.thick;
    worksheet.getRangeByName('A1:F1').cellStyle = globalStyle;

    final excel.Style presentStyle = workbook.styles.add('presentStyle');
    presentStyle.fontName = 'Times New Roman';
    presentStyle.fontSize = 12;
    presentStyle.fontColor = '#00FF00';
    presentStyle.wrapText = true;

    final excel.Style absentStyle = workbook.styles.add('absentStyle');
    absentStyle.fontName = 'Times New Roman';
    absentStyle.fontSize = 12;
    absentStyle.fontColor = '#FF0000';
    absentStyle.wrapText = true;

    worksheet.getRangeByName("A1").setText("Serial No.");
    worksheet.getRangeByName("B1").setText("Student Name");
    worksheet.getRangeByName("C1").setText("Course");
    worksheet.getRangeByName("D1").setText("System ID");
    worksheet.getRangeByName("E1").setText("Email ID");
    worksheet
        .getRangeByName("F1")
        .setText(eventData["events"][getIndex.value]["date"].toString());

    worksheet.name =
        "Attendance List ${eventData["events"][getIndex.value]["date"]}";

    worksheet.setColumnWidthInPixels(1, 100);
    worksheet.setColumnWidthInPixels(2, 150);
    worksheet.setColumnWidthInPixels(3, 150);
    worksheet.setColumnWidthInPixels(4, 150);
    worksheet.setColumnWidthInPixels(5, 300);
    worksheet.setColumnWidthInPixels(6, 150);

    for (int i = 0; i < presentSTD.length; i++) {
      worksheet.getRangeByName("A${i + 2}").setText("${i + 1}");
      worksheet.getRangeByName("B${i + 2}").setText("${presentSTD[i]['name']}");
      worksheet
          .getRangeByName("C${i + 2}")
          .setText("${presentSTD[i]['course']} ${presentSTD[i]['year']} year");
      worksheet
          .getRangeByName("D${i + 2}")
          .setText("${presentSTD[i]['systemID']}");
      worksheet
          .getRangeByName("E${i + 2}")
          .setText("${presentSTD[i]['email']}");

      worksheet.getRangeByName("F${i + 2}").setText("Present");
      worksheet.getRangeByName("F${i + 2}").cellStyle = presentStyle;
    }

    if (eventData["events"][getIndex.value]["absent"].length != 0) {
      int j = 0;
      int k = presentSTD.length;

      for (int i = presentSTD.length + 1;
          i < presentSTD.length + absentSTD.length + 1;
          i++) {
        print("$k : ${absentSTD[j]}");

        worksheet.getRangeByName("A${k + 2}").setText("${k + 1}");
        worksheet
            .getRangeByName("B${k + 2}")
            .setText("${absentSTD[j]['name']}");
        worksheet
            .getRangeByName("C${k + 2}")
            .setText("${absentSTD[j]['course']} ${absentSTD[j]['year']} year");
        worksheet
            .getRangeByName("D${k + 2}")
            .setText("${absentSTD[j]['systemID']}");
        worksheet
            .getRangeByName("E${k + 2}")
            .setText("${absentSTD[j]['email']}");
        worksheet.getRangeByName("F${k + 2}").setText("Absent");
        worksheet.getRangeByName("F${k + 2}").cellStyle = absentStyle;
        j++;
        k++;
      }
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationDocumentsDirectory()).path;
    final String fileName =
        '$path/${eventData["events"][getIndex.value]["date"]} Attendance List.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
    EasyLoading.dismiss();
  }
}
