import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/Faculty%20Controller/faculty_controller.dart';
import 'package:suevents/View/Faculty%20Portal/Assigned%20Events/events_details.dart';

import '../../../Controller/providers/const.dart';
import '../../../Controller/providers/theme_service.dart';

class AssignedEvents extends StatefulWidget {
  const AssignedEvents({Key? key}) : super(key: key);

  @override
  State<AssignedEvents> createState() => _AssignedEventsState();
}

class _AssignedEventsState extends State<AssignedEvents> {
  FacultyController facultyController = FacultyController();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return RefreshIndicator(
      displacement: 100,
      backgroundColor:
          themeProvider.isDarkMode ? Colors.grey[400] : Colors.white,
      color: themeProvider.isDarkMode ? Colors.black : Colors.black,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
            automaticallyImplyLeading: true,
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
              "Assigned Events",
              style: textStyle(
                  14.sp, FontWeight.bold, Colors.white, FontStyle.normal),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
                future: facultyController.getFacultyAssignedEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Container(
                                        width: width * 0.9,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.transparent,
                                        ),
                                        child: Shimmer.fromColors(
                                          baseColor: themeProvider.isDarkMode
                                              ? Colors.black
                                              : Colors.white,
                                          highlightColor:
                                              Colors.grey.withOpacity(0.5),
                                          period: const Duration(seconds: 2),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.grey[400]!,
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                );
                              })
                        ],
                      ),
                    );
                  }

                  if (facultyController
                          .assignedEvents["eventsAssigned"].length ==
                      0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            width: width * 0.9,
                            height: 100,
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
                              child: Center(
                                child: Text(
                                  "No events assigned yet or left...",
                                  textAlign: TextAlign.center,
                                  style: textStyle(
                                      14.sp,
                                      FontWeight.w700,
                                      themeProvider.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      FontStyle.normal),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  if (facultyController.assignedEvents != null) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: facultyController
                            .assignedEvents["eventsAssigned"].length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 8,
                              child: OpenContainer(
                                  openElevation: 0,
                                  closedElevation: 8,
                                  closedColor: themeProvider.isDarkMode
                                      ? HexColor("#020E26")
                                      : Colors.white,
                                  closedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  middleColor: themeProvider.isDarkMode
                                      ? HexColor("#020E26")
                                      : Colors.white,
                                  openColor: themeProvider.isDarkMode
                                      ? HexColor("#020E26")
                                      : Colors.white,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                  transitionType:
                                      ContainerTransitionType.fadeThrough,
                                  closedBuilder: (context, action) {
                                    return Container(
                                      width: width * 0.9,
                                      color: themeProvider.isDarkMode
                                          ? HexColor("#020E26")
                                          : Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              facultyController.assignedEvents[
                                                      "eventsAssigned"][index]
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
                                              "Round : ${facultyController.assignedEvents["eventsAssigned"][index]["rounds"].length}",
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
                                                  "Round Start on ${facultyController.assignedEvents["eventsAssigned"][index]["rounds"][facultyController.assignedEvents["eventsAssigned"][index]["rounds"].length - 1]["date"]} \n at ${facultyController.assignedEvents["eventsAssigned"][index]["rounds"][facultyController.assignedEvents["eventsAssigned"][index]["rounds"].length - 1]["time"]}",
                                                  style: textStyle(
                                                      10.sp,
                                                      FontWeight.w700,
                                                      themeProvider.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      FontStyle.normal),
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: action,
                                                  child: const Icon(Icons
                                                      .arrow_circle_right_rounded),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  openBuilder: (context, acion) {
                                    return AttendanceEventDetails(
                                      event: facultyController
                                              .assignedEvents["eventsAssigned"]
                                          [index],
                                    );
                                  }),
                            ),
                          );
                        });
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          width: width * 0.9,
                          height: 100,
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
                            child: Center(
                              child: Text(
                                "No events assigned yet or left...",
                                textAlign: TextAlign.center,
                                style: textStyle(
                                    14.sp,
                                    FontWeight.w700,
                                    themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontStyle.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ]),
      ),
    );
  }
}
