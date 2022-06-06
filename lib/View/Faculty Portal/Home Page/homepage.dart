import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/Faculty%20Controller/faculty_controller.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Faculty%20API/faculty_auth.dart';
import 'package:suevents/View/Faculty%20Portal/Create%20Event/event_create.dart';
import 'package:suevents/View/Faculty%20Portal/Home%20Page/event_details.dart';

FacultyController facultyController = FacultyController();

class FacultyHomePage extends StatefulWidget {
  const FacultyHomePage({Key? key}) : super(key: key);

  @override
  State<FacultyHomePage> createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  var token;
  var getUserDetails;
  var eventData;
  String name = "", greet = "", searchEvents = "", searchValue = "";
  int eventsIndexLength = 1, eventSearchLength = 0;
  var time = DateTime.now().hour;
  List createdEvents = [];

  @override
  void initState() {
    super.initState();
    if (time >= 6 && time <= 12) {
      setState(() {
        greet = "Good Morning";
      });
    } else if (time > 12 && time <= 16) {
      setState(() {
        greet = "Good Afternoon";
      });
    } else {
      setState(() {
        greet = "Good Evening";
      });
    }
    getToken();
  }

  int createEventList = 0;

  getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
    getUserDetails = await getFacultyData(token);
    setState(() {
      name = getUserDetails["user"]["name"];
      createdEvents.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    createdEvents.clear();

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
        await Future.delayed(const Duration(milliseconds: 1500));
        await facultyController.fetchFacultyData();

        setState(() {
          createEventList = 0;
          createdEvents.clear();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 0,
        ),
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopBar(themeProvider: themeProvider),
                const SizedBox(
                  height: 20,
                ),
                Text("$greet..!",
                    style: textStyle(
                        8.sp,
                        FontWeight.w400,
                        themeProvider.isDarkMode ? Colors.grey : Colors.black,
                        FontStyle.normal)),
                const SizedBox(
                  height: 1,
                ),
                Text("Hi, $name", style: Theme.of(context).textTheme.headline2),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: OpenContainer(
                      openElevation: 0,
                      closedElevation: 4,
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
                      transitionDuration: const Duration(milliseconds: 500),
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedBuilder: ((context, action) {
                        return Container(
                          width: width * 0.95,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: themeProvider.isDarkMode
                                  ? Colors.black
                                  : Colors.white),
                          child: Center(
                              child: Text(
                            "Create Event",
                            style: textStyle(
                                12.sp,
                                FontWeight.w800,
                                themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                FontStyle.normal),
                          )),
                        );
                      }),
                      openBuilder: (context, action) {
                        return const CreateEvent();
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Your Events",
                      style: textStyle(
                          14.sp,
                          FontWeight.w800,
                          themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          FontStyle.normal),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        "View All",
                        style: textStyle(
                            9.sp,
                            FontWeight.w600,
                            themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            FontStyle.normal),
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: facultyController.fetchFacultyData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                ),
                                width: width * 0.6,
                                height: textScale == 1.0 ? 250.0 : 300,
                                child: Shimmer.fromColors(
                                  baseColor: themeProvider.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                  highlightColor: themeProvider.isDarkMode
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.black.withOpacity(0.3),
                                  period: const Duration(seconds: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                ),
                                width: width * 0.6,
                                height: textScale == 1.0 ? 250.0 : 300,
                                child: Shimmer.fromColors(
                                  baseColor: themeProvider.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                  highlightColor: themeProvider.isDarkMode
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.black.withOpacity(0.3),
                                  period: const Duration(seconds: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      );
                    }
                    if (facultyController.user["user"] != null) {
                      generalEvent =
                          facultyController.user["user"]["eventsCreated"];
                      if (generalEvent.length > 0) {
                        for (int i = 0; i < generalEvent.length; i++) {
                          if (generalEvent[i]["status"] == "open") {
                            createdEvents.add(generalEvent[i]);
                            createEventList = createEventList + 1;
                          }
                        }
                        return SizedBox(
                          width: width,
                          height: textScale == 1.0 ? 270.0 : 320,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: createdEvents.isEmpty
                                  ? 1
                                  : createdEvents.length,
                              itemBuilder: (context, index) {
                                if (createdEvents.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Card(
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 8,
                                      child: OpenContainer(
                                          openElevation: 0,
                                          closedElevation: 4,
                                          closedColor: themeProvider.isDarkMode
                                              ? HexColor("#020E26")
                                              : Colors.white,
                                          closedShape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          middleColor: themeProvider.isDarkMode
                                              ? HexColor("#020E26")
                                              : Colors.white,
                                          openColor: themeProvider.isDarkMode
                                              ? HexColor("#020E26")
                                              : Colors.white,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          transitionDuration:
                                              const Duration(milliseconds: 500),
                                          transitionType:
                                              ContainerTransitionType
                                                  .fadeThrough,
                                          closedBuilder: (context, action) {
                                            return Container(
                                              width: width * 0.6,
                                              color: themeProvider.isDarkMode
                                                  ? HexColor("#020E26")
                                                  : Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          createdEvents[index]
                                                              ["title"],
                                                          textAlign:
                                                              TextAlign.left,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: textStyle(
                                                              15.sp,
                                                              FontWeight.bold,
                                                              themeProvider
                                                                      .isDarkMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              FontStyle.normal),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "Event Type : ${createdEvents[index]["type"]}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: textStyle(
                                                            10.sp,
                                                            FontWeight.w600,
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
                                                        "Date : ${createdEvents[index]["startDate"]}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: textStyle(
                                                            10.sp,
                                                            FontWeight.w600,
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
                                                        "Price : ${createdEvents[index]["eventPrice"]}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: textStyle(
                                                            10.sp,
                                                            FontWeight.w600,
                                                            themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontStyle.normal),
                                                      ),
                                                      const Spacer(),
                                                      ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              primary: themeProvider
                                                                      .isDarkMode
                                                                  ? const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      14,
                                                                      76,
                                                                      191)
                                                                  : const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      1,
                                                                      64,
                                                                      181),
                                                              elevation: 4),
                                                          onPressed: action,
                                                          child: Center(
                                                            child: Text(
                                                              "Open Event",
                                                              textScaleFactor:
                                                                  1,
                                                              style: textStyle(
                                                                  12.sp,
                                                                  FontWeight
                                                                      .w600,
                                                                  Colors.white,
                                                                  FontStyle
                                                                      .normal),
                                                            ),
                                                          ))
                                                    ]),
                                              ),
                                            );
                                          },
                                          openBuilder: (context, action) {
                                            return FacultyEventDetail(
                                              event: createdEvents[index],
                                            );
                                          }),
                                    ),
                                  );
                                }
                                if (createdEvents.isEmpty) {
                                  return Center(
                                    child: Card(
                                      shadowColor: themeProvider.isDarkMode
                                          ? const Color.fromARGB(
                                              255, 125, 125, 125)
                                          : Colors.grey,
                                      color: Colors.transparent,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                          width: width * 0.9,
                                          height: 250.0,
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
                                          child: Center(
                                            child: Text(
                                              "No Events Available",
                                              style: textStyle(
                                                  14.sp,
                                                  FontWeight.w600,
                                                  themeProvider.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  FontStyle.normal),
                                            ),
                                          )),
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }),
                        );
                      } else {
                        return Card(
                          shadowColor: themeProvider.isDarkMode
                              ? const Color.fromARGB(255, 125, 125, 125)
                              : Colors.grey,
                          color: Colors.transparent,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                              width: width * 0.9,
                              height: 250.0,
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
                              child: Center(
                                child: Text(
                                  "No Events Available",
                                  style: textStyle(
                                      14.sp,
                                      FontWeight.w600,
                                      themeProvider.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      FontStyle.normal),
                                ),
                              )),
                        );
                      }
                    } else {
                      return Card(
                        shadowColor: themeProvider.isDarkMode
                            ? const Color.fromARGB(255, 125, 125, 125)
                            : Colors.grey,
                        color: Colors.transparent,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                            width: width * 0.9,
                            height: 250.0,
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
                            child: Center(
                              child: Text(
                                "No Events Available",
                                style: textStyle(
                                    14.sp,
                                    FontWeight.w600,
                                    themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontStyle.normal),
                              ),
                            )),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ))
        ]),
      ),
    );
  }

  var generalEvent;
}

class TopBar extends StatelessWidget {
  const TopBar({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);

  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              ZoomDrawer.of(context)?.open();
            },
            child: Card(
              elevation: 4,
              color:
                  !themeProvider.isDarkMode ? Colors.white : Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                decoration: BoxDecoration(
                    color: !themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12)),
                width: 40,
                height: 40,
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 4,
                      width: 25,
                      decoration: BoxDecoration(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Container(
                      width: 15,
                      height: 4,
                      decoration: BoxDecoration(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                )),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
              onTap: () {}, child: const Icon(Icons.settings_rounded)),
        ],
      ),
    );
  }
}
