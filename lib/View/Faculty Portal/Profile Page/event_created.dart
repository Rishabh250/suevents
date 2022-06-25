import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/Internet%20Connection/connection_provider.dart';
import 'package:suevents/View/Faculty%20Portal/Home%20Page/homepage.dart';
import 'package:suevents/View/no_connection.dart';

import '../../../Controller/providers/const.dart';
import '../../../Controller/providers/theme_service.dart';

class FacultyEventCreated extends StatefulWidget {
  const FacultyEventCreated({Key? key}) : super(key: key);

  @override
  State<FacultyEventCreated> createState() => Student_AppliedEventsState();
}

class Student_AppliedEventsState extends State<FacultyEventCreated> {
  ScrollController scrollController = ScrollController();
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
    return Consumer<ConnectivityProvider>(builder: (context, model, child) {
      return model.isOnline
          ? Scaffold(
              body: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    leading: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
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
                      "Events Created",
                      style: textStyle(14.sp, FontWeight.bold, Colors.white,
                          FontStyle.normal),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: facultyController.events.value,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                child: Banner(
                                  color: facultyController
                                              .allEvents.value[index]["type"] ==
                                          "Placement Event"
                                      ? Colors.red
                                      : Colors.green,
                                  location: BannerLocation.topStart,
                                  message: facultyController
                                              .allEvents.value[index]["type"] ==
                                          "Placement Event"
                                      ? "Placement"
                                      : "General",
                                  child: Card(
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 8,
                                      child: Container(
                                        width: width * 0.6,
                                        decoration: (BoxDecoration(
                                            color: themeProvider.isDarkMode
                                                ? HexColor("#020E26")
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  facultyController.allEvents
                                                      .value[index]["title"],
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: textStyle(
                                                      15.sp,
                                                      FontWeight.bold,
                                                      themeProvider.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      FontStyle.normal),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "Event Type : ${facultyController.allEvents.value[index]["type"]}",
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: textStyle(
                                                      10.sp,
                                                      FontWeight.w600,
                                                      themeProvider.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      FontStyle.normal),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Date : ${facultyController.allEvents.value[index]["startDate"]}",
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: textStyle(
                                                      10.sp,
                                                      FontWeight.w600,
                                                      themeProvider.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      FontStyle.normal),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Price : ${facultyController.allEvents.value[index]["eventPrice"]}",
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: textStyle(
                                                      10.sp,
                                                      FontWeight.w600,
                                                      themeProvider.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      FontStyle.normal),
                                                ),
                                              ]),
                                        ),
                                      )),
                                ),
                              ),
                            );
                          }))
                ],
              ),
            )
          : const NoInternet();
    });
  }
}
