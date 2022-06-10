import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/global_snackbar.dart';
import 'package:suevents/Models/Faculty%20API/faculty_api.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

import '../../../Controller/providers/const.dart';
import '../../../Controller/providers/theme_service.dart';

class UnselectedList extends StatefulWidget {
  const UnselectedList({Key? key}) : super(key: key);

  @override
  State<UnselectedList> createState() => _UnselectedListState();
}

class _UnselectedListState extends State<UnselectedList> {
  ValueNotifier eventType = ValueNotifier("");
  ValueNotifier gropuValue = ValueNotifier(0);
  var eventsList;
  ValueNotifier selectedEvents = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
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
              "Filter Students",
              style: textStyle(
                  14.sp, FontWeight.bold, Colors.white, FontStyle.normal),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Text(
                    "Select Round",
                    style: textStyle(
                        16.sp,
                        FontWeight.w800,
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                        FontStyle.normal),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: ValueListenableBuilder(
                    builder: ((context, value, child) {
                      return Radio(
                          value: 1,
                          groupValue: value,
                          onChanged: (changeValue) async {
                            EasyLoading.show();
                            gropuValue.value =
                                int.parse(changeValue.toString());
                            eventType.value = "Aptitude Round";
                            eventsList = await getSelectedEvents(
                                eventType.value.toString());
                            selectedEvents.value = [];

                            setState(() {});
                          });
                    }),
                    valueListenable: gropuValue,
                  ),
                  title: Text("Aptitude Round",
                      style: textStyle(
                          12.sp,
                          FontWeight.bold,
                          themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          FontStyle.normal)),
                ),
                ListTile(
                  leading: ValueListenableBuilder(
                    builder: ((context, value, child) {
                      return Radio(
                          value: 2,
                          groupValue: value,
                          onChanged: (changeValue) async {
                            EasyLoading.show();

                            gropuValue.value =
                                int.parse(changeValue.toString());
                            eventType.value = "Technical Round";
                            eventsList = await getSelectedEvents(
                                eventType.value.toString());
                            selectedEvents.value = [];
                            setState(() {});
                          });
                    }),
                    valueListenable: gropuValue,
                  ),
                  title: Text("Technical Round",
                      style: textStyle(
                          12.sp,
                          FontWeight.bold,
                          themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          FontStyle.normal)),
                ),
                ListTile(
                  leading: ValueListenableBuilder(
                    builder: ((context, value, child) {
                      return Radio(
                          value: 3,
                          groupValue: value,
                          onChanged: (changeValue) async {
                            EasyLoading.show();

                            gropuValue.value =
                                int.parse(changeValue.toString());
                            eventType.value = "HR";
                            // setState(() {});
                            eventsList = await getSelectedEvents(
                                eventType.value.toString());
                            selectedEvents.value = [];

                            setState(() {});
                          });
                    }),
                    valueListenable: gropuValue,
                  ),
                  title: Text("HR",
                      style: textStyle(
                          12.sp,
                          FontWeight.bold,
                          themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          FontStyle.normal)),
                ),
                ListTile(
                  leading: ValueListenableBuilder(
                    builder: ((context, value, child) {
                      return Radio(
                          value: 4,
                          groupValue: value,
                          onChanged: (changeValue) async {
                            EasyLoading.show();

                            gropuValue.value =
                                int.parse(changeValue.toString());
                            eventType.value = "Final";
                            // setState(() {});
                            eventsList = await getSelectedEvents(
                                eventType.value.toString());
                            selectedEvents.value = [];

                            setState(() {});
                          });
                    }),
                    valueListenable: gropuValue,
                  ),
                  title: Text("Final",
                      style: textStyle(
                          12.sp,
                          FontWeight.bold,
                          themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          FontStyle.normal)),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Text(
                    "Events",
                    style: textStyle(
                        16.sp,
                        FontWeight.w800,
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                        FontStyle.normal),
                  ),
                ),
                eventType.value == ""
                    ? const Text("")
                    : FutureBuilder(
                        future: fetchRoundsEvents(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            EasyLoading.show();
                          }
                          if (eventsList != null) {
                            EasyLoading.dismiss();
                            return SizedBox(
                              width: width * 0.9,
                              height: height * 0.45,
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                shrinkWrap: true,
                                itemCount: eventsList["list"].length,
                                itemBuilder: (context, index) {
                                  return ValueListenableBuilder(
                                      valueListenable: selectedEvents,
                                      builder: (context, value, child) {
                                        return ListTile(
                                            onTap: () {
                                              if (!selectedEvents.value
                                                  .contains(eventsList["list"]
                                                      [index]["_id"])) {
                                                selectedEvents.value.add(
                                                    eventsList["list"][index]
                                                        ["_id"]);
                                              } else {
                                                selectedEvents.value.remove(
                                                    eventsList["list"][index]
                                                        ["_id"]);
                                              }
                                              setState(() {});
                                              log(selectedEvents.value
                                                  .toString());
                                            },
                                            title: Card(
                                              color: !themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : HexColor("#010A1C"),
                                              elevation: 8,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: SizedBox(
                                                width: width,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        eventsList["list"]
                                                            [index]["title"],
                                                        style: textStyle(
                                                            14.sp,
                                                            FontWeight.w500,
                                                            themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontStyle.normal),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        eventsList["list"]
                                                                [index]
                                                            ["startDate"],
                                                        style: textStyle(
                                                            10.sp,
                                                            FontWeight.w500,
                                                            themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontStyle.normal),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Total Rounds : ${eventsList["list"][index]["rounds"].length}",
                                                        style: textStyle(
                                                            10.sp,
                                                            FontWeight.w500,
                                                            themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontStyle.normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            leading: selectedEvents.value
                                                    .contains(eventsList["list"]
                                                        [index]["_id"])
                                                ? const Icon(
                                                    Icons.radio_button_checked)
                                                : const Icon(Icons
                                                    .radio_button_unchecked));
                                      });
                                },
                              ),
                            );
                          }
                          return Container();
                        })),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: const Color.fromARGB(255, 0, 4, 86),
            onPressed: () async {
              EasyLoading.show();
              studentList = await getUnselectedStudents(
                  eventType.value.toString(), selectedEvents.value);
              EasyLoading.dismiss();
            },
            child: Text(
              "Apply Filter",
              style: textStyle(
                  12.sp, FontWeight.bold, Colors.white, FontStyle.normal),
            ),
          ),
          MaterialButton(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.amber,
            onPressed: createExcel,
            child: Text("Generate Excel",
                style: textStyle(
                    12.sp, FontWeight.bold, Colors.white, FontStyle.normal)),
          ),
        ],
      ),
    );
  }

  var studentList;

  fetchRoundsEvents() async {
    eventsList = await getSelectedEvents(eventType.value.toString());
    return eventsList;
  }

  Future<void> createExcel() async {
    if (studentList == null) {
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

    worksheet.getRangeByName("A1").setText("Serial No.");
    worksheet.getRangeByName("B1").setText("Student Name");
    worksheet.getRangeByName("C1").setText("Course");
    worksheet.getRangeByName("D1").setText("System ID");
    worksheet.getRangeByName("E1").setText("Email ID");
    worksheet.getRangeByName('A1:E1').cellStyle = globalStyle;
    worksheet.name = "Unselected Students List";

    for (int i = 0; i < studentList["list"].length; i++) {
      worksheet.setColumnWidthInPixels(1, 100);
      worksheet.setColumnWidthInPixels(2, 150);
      worksheet.setColumnWidthInPixels(3, 150);
      worksheet.setColumnWidthInPixels(4, 150);
      worksheet.setColumnWidthInPixels(5, 300);

      worksheet.getRangeByName("A${i + 2}").setText("${i + 1}");
      worksheet
          .getRangeByName("B${i + 2}")
          .setText("${studentList["list"][i]['name']}");
      worksheet.getRangeByName("C${i + 2}").setText(
          "${studentList["list"][i]['course']} ${studentList["list"][i]['year']} year");
      worksheet
          .getRangeByName("D${i + 2}")
          .setText("${studentList["list"][i]['systemID']}");
      worksheet
          .getRangeByName("E${i + 2}")
          .setText("${studentList["list"][i]['email']}");
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationDocumentsDirectory()).path;
    final String fileName = '$path/Output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
    EasyLoading.dismiss();
  }
}
