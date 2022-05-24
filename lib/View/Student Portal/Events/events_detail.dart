import 'dart:developer';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';

import '../../../../Controller/Student_Controllers/controller.dart';
import '../../../../Models/Event Api/events_api.dart';

class EventDetail extends StatefulWidget {
  var event;
  EventDetail({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  var user;
  var eventList;
  ValueNotifier<String> btnTxt = ValueNotifier("Participate");

  GetUserData getUserData = GetUserData();

  @override
  void initState() {
    super.initState();
    log(widget.event.toString());

    getData();
  }

  getData() async {
    user = await getUserData.fetchUserData();
    eventList = user["user"]["events"];
    if (eventList.contains(widget.event["_id"])) {
      btnTxt.value = "Participated";
    }
  }

  @override
  void dispose() {
    btnTxt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body:
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    child: Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        "assets/images/bg.jpg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  title: Text(
                    widget.event["title"],
                    style: textStyle(
                        12.sp, FontWeight.w700, Colors.white, FontStyle.normal),
                  )),
              elevation: 0,
              backgroundColor: const Color.fromARGB(255, 30, 0, 255),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(Icons.arrow_back_ios),
              )),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Card(
                    shadowColor: themeProvider.isDarkMode
                        ? const Color.fromARGB(255, 125, 125, 125)
                        : Colors.grey,
                    color: Colors.transparent,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: _width * 0.95,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.2,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : const Color.fromARGB(255, 151, 194, 8)),
                          borderRadius: BorderRadius.circular(20),
                          color: themeProvider.isDarkMode
                              ? HexColor("#020E26")
                              : Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Event Type : ",
                                    style: textStyle(
                                        12.sp,
                                        FontWeight.w400,
                                        themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        FontStyle.normal),
                                  ),
                                  Text(
                                    widget.event["type"],
                                    style: textStyle(
                                        12.sp,
                                        FontWeight.bold,
                                        const Color.fromARGB(255, 43, 6, 210),
                                        FontStyle.normal),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Event Price : ",
                                    style: textStyle(
                                        12.sp,
                                        FontWeight.w400,
                                        themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        FontStyle.normal),
                                  ),
                                  Text(
                                    widget.event["eventPrice"],
                                    style: textStyle(
                                        12.sp,
                                        FontWeight.bold,
                                        const Color.fromARGB(255, 43, 6, 210),
                                        FontStyle.normal),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Start Date : ",
                                    style: textStyle(
                                        12.sp,
                                        FontWeight.w400,
                                        themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        FontStyle.normal),
                                  ),
                                  Text(
                                    widget.event["startDate"],
                                    style: textStyle(
                                        12.sp,
                                        FontWeight.bold,
                                        const Color.fromARGB(255, 43, 6, 210),
                                        FontStyle.normal),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 15),
                  child: Row(
                    children: [
                      Text("About Event : ",
                          style: textStyle(
                              15.sp,
                              FontWeight.bold,
                              themeProvider.isDarkMode
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : Colors.black,
                              FontStyle.normal)),
                    ],
                  ),
                ),
                Card(
                  shadowColor: themeProvider.isDarkMode
                      ? const Color.fromARGB(255, 125, 125, 125)
                      : Colors.grey,
                  color: Colors.transparent,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    width: _width * 0.95,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.2,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : const Color.fromARGB(255, 151, 194, 8)),
                        borderRadius: BorderRadius.circular(20),
                        color: themeProvider.isDarkMode
                            ? HexColor("#020E26")
                            : Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: _width * 0.85,
                          child: ExpandableText(
                            widget.event["description"] == ""
                                ? "No Description"
                                : widget.event["description"],
                            expandText: 'Show more',
                            collapseText: 'Show less',
                            maxLines: 3,
                            animation: true,
                            linkStyle: textStyle(
                                12.sp,
                                FontWeight.w400,
                                themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                FontStyle.normal),
                            style: textStyle(
                                12.sp,
                                FontWeight.bold,
                                const Color.fromARGB(255, 43, 6, 210),
                                FontStyle.normal),
                            expandOnTextTap: true,
                            collapseOnTextTap: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 15),
                  child: Row(
                    children: [
                      Text("Faculty Assigned : ",
                          style: textStyle(
                              15.sp,
                              FontWeight.bold,
                              themeProvider.isDarkMode
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : Colors.black,
                              FontStyle.normal)),
                    ],
                  ),
                ),
                FacultyAssined(
                    width: _width,
                    event: widget.event,
                    themeProvider: themeProvider),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 15),
                  child: Row(
                    children: [
                      Text("Hosted By : ",
                          style: textStyle(
                              15.sp,
                              FontWeight.bold,
                              themeProvider.isDarkMode
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : Colors.black,
                              FontStyle.normal)),
                    ],
                  ),
                ),
                HostedBy(
                    themeProvider: themeProvider,
                    width: _width,
                    event: widget.event),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      FutureBuilder(
                          future: getData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return MaterialButton(
                                  elevation: 4,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  onPressed: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ValueListenableBuilder(
                                        valueListenable: btnTxt,
                                        builder: (context, value, child) {
                                          return Text(
                                            "$value",
                                            style: textStyle(
                                                12.sp,
                                                FontWeight.bold,
                                                Colors.black,
                                                FontStyle.normal),
                                          );
                                        }),
                                  ));
                            }
                            return MaterialButton(
                                elevation: 4,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () async {
                                  if (btnTxt.value == "Participated") {
                                    return;
                                  }
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              themeProvider.isDarkMode
                                                  ? HexColor("#010A1C")
                                                  : Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          title: Text(widget.event["title"],
                                              style: textStyle(
                                                  15.sp,
                                                  FontWeight.bold,
                                                  themeProvider.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  FontStyle.normal)),
                                          content: Text(
                                              "Do want to apply for this event ?",
                                              style: textStyle(
                                                  12.sp,
                                                  FontWeight.w600,
                                                  themeProvider.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  FontStyle.normal)),
                                          elevation: 8,
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  elevation: 8,
                                                  onPressed: () async {
                                                    Get.back();
                                                  },
                                                  child: Center(
                                                      child: Text("Close",
                                                          style: textStyle(
                                                              12.sp,
                                                              FontWeight.bold,
                                                              themeProvider
                                                                      .isDarkMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              FontStyle
                                                                  .normal))),
                                                ),
                                                MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  elevation: 8,
                                                  onPressed: () async {
                                                    SharedPreferences
                                                        sharedPreferences =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    var token =
                                                        sharedPreferences
                                                            .getString(
                                                                "accessToken");
                                                    EasyLoading.show();

                                                    await applyEvent(
                                                        token,
                                                        widget.event["_id"],
                                                        widget.event["title"]
                                                            .toString());
                                                    await getData();

                                                    EasyLoading.dismiss();

                                                    Navigator.pop(context);
                                                  },
                                                  child: Center(
                                                    child: Text("Apply",
                                                        style: textStyle(
                                                            12.sp,
                                                            FontWeight.bold,
                                                            const Color
                                                                    .fromARGB(
                                                                212,
                                                                27,
                                                                124,
                                                                2),
                                                            FontStyle.normal)),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ValueListenableBuilder(
                                        valueListenable: btnTxt,
                                        builder: (context, value, child) {
                                          return Text(
                                            "$value",
                                            style: textStyle(
                                                12.sp,
                                                FontWeight.bold,
                                                Colors.black,
                                                FontStyle.normal),
                                          );
                                        })));
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class HostedBy extends StatelessWidget {
  const HostedBy({
    Key? key,
    required this.themeProvider,
    required double width,
    required this.event,
  })  : _width = width,
        super(key: key);

  final ThemeProvider themeProvider;
  final double _width;
  final event;

  @override
  Widget build(BuildContext context) {
    return Card(
        shadowColor: themeProvider.isDarkMode
            ? const Color.fromARGB(255, 125, 125, 125)
            : Colors.grey,
        color: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: _width * 0.95,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 0.2,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : const Color.fromARGB(255, 151, 194, 8)),
              borderRadius: BorderRadius.circular(20),
              color: themeProvider.isDarkMode
                  ? HexColor("#020E26")
                  : Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Name : ",
                        style: textStyle(
                            12.sp,
                            FontWeight.w400,
                            themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            FontStyle.normal),
                      ),
                      Text(
                        event["createdBy"][0]["name"],
                        style: textStyle(
                            12.sp,
                            FontWeight.bold,
                            const Color.fromARGB(255, 43, 6, 210),
                            FontStyle.normal),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "System ID : ",
                        style: textStyle(
                            12.sp,
                            FontWeight.w400,
                            themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            FontStyle.normal),
                      ),
                      SizedBox(
                        width: _width * 0.5,
                        child: Text(
                          event["createdBy"][0]["systemID"],
                          maxLines: 2,
                          style: textStyle(
                              12.sp,
                              FontWeight.bold,
                              const Color.fromARGB(255, 43, 6, 210),
                              FontStyle.normal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class FacultyAssined extends StatelessWidget {
  const FacultyAssined({
    Key? key,
    required double width,
    required this.event,
    required this.themeProvider,
  })  : _width = width,
        super(key: key);

  final double _width;
  final event;
  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width * 0.95,
      height: 120,
      child: event["facultyAssigned"].length == 0
          ? Card(
              shadowColor: themeProvider.isDarkMode
                  ? const Color.fromARGB(255, 125, 125, 125)
                  : Colors.grey,
              color: Colors.transparent,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                width: _width * 0.5,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.2,
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : const Color.fromARGB(255, 151, 194, 8)),
                    borderRadius: BorderRadius.circular(20),
                    color: themeProvider.isDarkMode
                        ? HexColor("#020E26")
                        : Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        "Faculty has not assigned yet",
                        style: textStyle(
                            12.sp,
                            FontWeight.w500,
                            themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            FontStyle.normal),
                      ),
                    ),
                  ),
                ),
              ))
          : ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: event["facultyAssigned"].length,
              itemBuilder: (context, index) {
                return Card(
                    shadowColor: themeProvider.isDarkMode
                        ? const Color.fromARGB(255, 125, 125, 125)
                        : Colors.grey,
                    color: Colors.transparent,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: _width * 0.5,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.2,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : const Color.fromARGB(255, 151, 194, 8)),
                          borderRadius: BorderRadius.circular(20),
                          color: themeProvider.isDarkMode
                              ? HexColor("#020E26")
                              : Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                event["facultyAssigned"][index]["name"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textStyle(
                                    12.sp,
                                    FontWeight.bold,
                                    const Color.fromARGB(255, 43, 6, 210),
                                    FontStyle.normal),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                child: Text(
                                  event["facultyAssigned"][index]["systemID"],
                                  maxLines: 2,
                                  style: textStyle(
                                      12.sp,
                                      FontWeight.bold,
                                      const Color.fromARGB(255, 43, 6, 210),
                                      FontStyle.normal),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              }),
    );
  }
}
