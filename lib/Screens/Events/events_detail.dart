import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/DB%20Connectivity/api/Events%20API/events_api.dart';
import 'package:suevents/providers/const.dart';

import '../../providers/theme_service.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({Key? key}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  var event = Get.arguments;

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
        body: CustomScrollView(slivers: [
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
                  title: Hero(
                    tag: event["eventData"]["title"],
                    child: Text(
                      event["eventData"]["title"],
                      style: textStyle(12.sp, FontWeight.w700, Colors.white,
                          FontStyle.normal),
                    ),
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
                                    event["eventData"]["type"],
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
                                    event["eventData"]["eventPrice"],
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
                                    event["eventData"]["startDate"],
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
                            event["eventData"]["description"] == ""
                                ? "No Description"
                                : event["eventData"]["description"],
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
                                    event["eventData"]["createdBy"][0]["name"],
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
                                    width: _width * 0.6,
                                    child: Text(
                                      event["eventData"]["createdBy"][0]
                                          ["systemID"],
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
                                    event["eventData"]["startDate"],
                                    style: textStyle(
                                        12.sp,
                                        FontWeight.bold,
                                        const Color.fromARGB(255, 43, 6, 210),
                                        FontStyle.normal),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          )
        ]),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              var token = sharedPreferences.getString("accessToken");
              EasyLoading.show();
              await applyEvent(token, event["eventData"]["_id"],
                  event["eventData"]["title"].toString());
              EasyLoading.dismiss();
            },
            label: Text(
              "Participate",
              style: textStyle(
                  12.sp, FontWeight.bold, Colors.black, FontStyle.normal),
            )),
      ),
    );
  }
}
