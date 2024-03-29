import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';

import '../../../../Models/Student API/student_api.dart';
import '../../../Controller/Internet Connection/connection_provider.dart';
import '../../no_connection.dart';
import 'event_rounds.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  var eventData;
  var token;

  @override
  void initState() {
    super.initState();
    EasyLoading.dismiss();
    Provider.of<ConnectivityProvider>(context, listen: false).startMontering();
  }

  DateTime currentBackPressTime = DateTime.now();

  Future<bool> onWillPop() {
    print("object");
    DateTime now = DateTime.now();

    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: 'Tap Again to Exit'); // you can use snackbar too here
      return Future.value(false);
    }
    return Future.value(true);
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Consumer<ConnectivityProvider>(
        builder: (context, value, child) => value.isOnline
            ? WillPopScope(
                onWillPop: onWillPop,
                child: RefreshIndicator(
                  displacement: 100,
                  backgroundColor: themeProvider.isDarkMode
                      ? Colors.grey[400]
                      : Colors.white,
                  color: themeProvider.isDarkMode ? Colors.black : Colors.black,
                  strokeWidth: 3,
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 1500));

                    setState(() {});
                  },
                  child: Scaffold(
                    body: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      controller: scrollController,
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          pinned: true,
                          forceElevated: true,
                          flexibleSpace: const FlexibleSpaceBar(
                            centerTitle: true,
                          ),
                          elevation: 8,
                          backgroundColor:
                              const Color.fromARGB(255, 30, 0, 255),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          title: Text(
                            "Your Events",
                            style: textStyle(14.sp, FontWeight.bold,
                                Colors.white, FontStyle.normal),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: FutureBuilder(
                            future: getEvents(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 5,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Center(
                                                child: Container(
                                                    width: width * 0.9,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.transparent,
                                                    ),
                                                    child: Shimmer.fromColors(
                                                      baseColor: themeProvider
                                                              .isDarkMode
                                                          ? Colors.black
                                                          : Colors.white,
                                                      highlightColor: Colors
                                                          .grey
                                                          .withOpacity(0.5),
                                                      period: const Duration(
                                                          seconds: 2),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors
                                                                .grey[400]!,
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

                              if (snapshot.hasData) {
                                if (eventData["eventsApplied"].length == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Center(
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Container(
                                          width: width * 0.9,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.2,
                                                  color: themeProvider
                                                          .isDarkMode
                                                      ? Colors.white
                                                      : const Color.fromARGB(
                                                          255, 151, 194, 8)),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: themeProvider.isDarkMode
                                                  ? HexColor("#020E26")
                                                  : Colors.white),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Center(
                                              child: Text(
                                                "You haven't applied any event yet .....",
                                                style: textStyle(
                                                    12.sp,
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

                                return SizedBox(
                                  height: height * 0.9,
                                  width: width,
                                  child: ListView.builder(
                                      controller: scrollController,
                                      shrinkWrap: true,
                                      itemCount:
                                          eventData["eventsApplied"].length,
                                      itemBuilder: (context, index) {
                                        int openEvents = 0;

                                        if (eventData["eventsApplied"][index]
                                                ["status"] ==
                                            "open") {
                                          openEvents++;
                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              elevation: 8,
                                              child: OpenContainer(
                                                  openElevation: 0,
                                                  closedElevation: 8,
                                                  closedColor: themeProvider
                                                          .isDarkMode
                                                      ? HexColor("#020E26")
                                                      : Colors.white,
                                                  closedShape:
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                  middleColor: themeProvider
                                                          .isDarkMode
                                                      ? HexColor("#020E26")
                                                      : Colors.white,
                                                  openColor: themeProvider
                                                          .isDarkMode
                                                      ? HexColor("#020E26")
                                                      : Colors.white,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 500),
                                                  transitionType:
                                                      ContainerTransitionType
                                                          .fadeThrough,
                                                  closedBuilder:
                                                      (context, action) {
                                                    return Banner(
                                                      location:
                                                          BannerLocation.topEnd,
                                                      color: eventData["eventsApplied"]
                                                                      [index]
                                                                  ["type"] ==
                                                              "Placement Event"
                                                          ? Colors.red
                                                          : Colors.green,
                                                      message:
                                                          eventData["eventsApplied"]
                                                                          [
                                                                          index]
                                                                      [
                                                                      "type"] ==
                                                                  "Placement Event"
                                                              ? "Placement"
                                                              : "General",
                                                      child: Container(
                                                        width: width * 0.9,
                                                        color: themeProvider
                                                                .isDarkMode
                                                            ? HexColor(
                                                                "#020E26")
                                                            : Colors.white,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                eventData["eventsApplied"]
                                                                        [index]
                                                                    ["title"],
                                                                style: textStyle(
                                                                    14.sp,
                                                                    FontWeight
                                                                        .w700,
                                                                    themeProvider.isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    FontStyle
                                                                        .normal),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                "Starting from  " +
                                                                    eventData["eventsApplied"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "startDate"],
                                                                style: textStyle(
                                                                    10.sp,
                                                                    FontWeight
                                                                        .w700,
                                                                    themeProvider.isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    FontStyle
                                                                        .normal),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Price :  " +
                                                                        eventData["eventsApplied"][index]
                                                                            [
                                                                            "eventPrice"],
                                                                    style: textStyle(
                                                                        10.sp,
                                                                        FontWeight
                                                                            .w700,
                                                                        themeProvider.isDarkMode
                                                                            ? Colors
                                                                                .white
                                                                            : Colors
                                                                                .black,
                                                                        FontStyle
                                                                            .normal),
                                                                  ),
                                                                  const Spacer(),
                                                                  GestureDetector(
                                                                    onTap:
                                                                        action,
                                                                    child: const Icon(
                                                                        Icons
                                                                            .arrow_circle_right_rounded),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  openBuilder:
                                                      (context, acion) {
                                                    return EventRounds(
                                                      events: eventData[
                                                              "eventsApplied"]
                                                          [index],
                                                      index: index,
                                                    );
                                                  }),
                                            ),
                                          );
                                        }
                                        if (openEvents == 0) {
                                          return Center(
                                            child: Card(
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Container(
                                                width: width * 0.9,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Center(
                                                    child: Text(
                                                      "Your all events has been closed ...",
                                                      style: textStyle(
                                                          12.sp,
                                                          FontWeight.w700,
                                                          themeProvider
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                          FontStyle.normal),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                );
                              }
                              return Card(
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
                                    child: Text(
                                      "You haven't applied any event yet .....",
                                      style: textStyle(14.sp, FontWeight.w700,
                                          Colors.black, FontStyle.normal),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : const NoInternet());
  }

  getEvents() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
    eventData = await getStudentEvents(token);
    return eventData;
  }
}
