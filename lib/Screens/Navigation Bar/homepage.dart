// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, must_call_super, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/DB%20Connectivity/api/Events%20API/events_api.dart';
import 'package:suevents/DB%20Connectivity/api/authentication_api.dart';
import 'package:suevents/Screens/Events/events_detail.dart';
import 'package:suevents/providers/const.dart';

import '../../providers/theme_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  var token;
  var getUserDetails;
  var eventData;
  String name = "";
  String greet = "";
  String searchEvents = "";
  String searchValue = "";
  int eventsIndexLength = 1;
  int eventSearchLength = 0;
  var time = DateTime.now().hour;

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
    getAllEvents();
    getToken();
  }

  getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
    getUserDetails = await getUserData(token);
    setState(() {
      name = getUserDetails["user"]["name"];
    });
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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            toolbarHeight: 0,
          ),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                ZoomDrawer.of(context)?.toggle();
                              },
                              child: Card(
                                elevation: 4,
                                color: !themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.transparent,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 4,
                                        width: 25,
                                        decoration: BoxDecoration(
                                            color: themeProvider.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20)),
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
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                                onTap: () {},
                                child: const Icon(Icons.settings_rounded))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(greet + "..!",
                          style: textStyle(
                              8.sp,
                              FontWeight.w400,
                              themeProvider.isDarkMode
                                  ? Colors.grey
                                  : Colors.black,
                              FontStyle.normal)),
                      const SizedBox(
                        height: 1,
                      ),
                      Text("Hi, " + name,
                          style: Theme.of(context).textTheme.headline2),
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: _width * 0.7,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      style: BorderStyle.solid,
                                      color: themeProvider.isDarkMode
                                          ? Colors.grey
                                          : const Color.fromARGB(
                                              255, 151, 194, 8)),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 10),
                                  child: TextField(
                                    onChanged: (value) {
                                      searchValue = value;
                                      searchEvents = value;
                                      eventSearchLength = 0;
                                    },
                                    enableSuggestions: true,
                                    autocorrect: true,
                                    autofillHints: const [
                                      "TCS",
                                      "Placements",
                                      "Events"
                                    ],
                                    style: textStyle(
                                        12.sp,
                                        FontWeight.w600,
                                        themeProvider.isDarkMode
                                            ? Colors.grey
                                            : Colors.black,
                                        FontStyle.normal),
                                    decoration: InputDecoration(
                                        hintText:
                                            "Search for Events & Placement",
                                        hintTextDirection: TextDirection.ltr,
                                        hintStyle: textStyle(
                                            12.sp,
                                            FontWeight.w500,
                                            const Color.fromARGB(
                                                255, 129, 128, 128),
                                            FontStyle.normal),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  searchEvents = searchValue;
                                  eventSearchLength = 0;
                                });
                              },
                              child: Container(
                                width: _width * 0.14,
                                height: 50,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 131, 169, 7),
                                    border: Border.all(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                    child: Image.asset(
                                  "assets/icons/search.png",
                                  width: 25,
                                  color: Colors.white,
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "All Events",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      StreamBuilder(
                        stream: getEvents(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, right: 8),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: _width * 0.6,
                                        height: textScale == 1.0 ? 250.0 : 300,
                                        child: Shimmer.fromColors(
                                          baseColor: themeProvider.isDarkMode
                                              ? Colors.black
                                              : Colors.white,
                                          highlightColor: Colors.grey,
                                          period: const Duration(seconds: 2),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.grey[400]!,
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                        width: _width * 0.6,
                                        height: textScale == 1.0 ? 250.0 : 300,
                                        child: Shimmer.fromColors(
                                          baseColor: themeProvider.isDarkMode
                                              ? Colors.black
                                              : Colors.white,
                                          highlightColor: Colors.grey,
                                          period: const Duration(seconds: 2),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.grey[400]!,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (eventData["events"].length > 0) {
                              eventsIndexLength = eventData["events"].length;
                              if (searchEvents != "") {
                                for (int i = 0;
                                    i < eventData["events"].length;
                                    i++) {
                                  if (eventData["events"][i]["title"]
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              searchEvents.toLowerCase()) ==
                                      true) {
                                    eventSearchLength += 1;
                                  }
                                  if (eventSearchLength == 0) {
                                    eventsIndexLength = 1;
                                  }
                                }
                              }
                              return SizedBox(
                                width: _width,
                                height: textScale == 1.0 ? 270.0 : 320,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: eventsIndexLength,
                                    itemBuilder: (context, index) {
                                      if (eventData["events"][index]["title"]
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                                  searchEvents.toLowerCase()) ||
                                          searchEvents.toString().isEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, right: 8),
                                          child: Card(
                                            shadowColor:
                                                themeProvider.isDarkMode
                                                    ? const Color.fromARGB(
                                                        255, 125, 125, 125)
                                                    : Colors.grey,
                                            color: Colors.transparent,
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Container(
                                              width: _width * 0.6,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: themeProvider
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : const Color
                                                                  .fromARGB(255,
                                                              151, 194, 8)),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color:
                                                      themeProvider.isDarkMode
                                                          ? HexColor("#020E26")
                                                          : Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child: Hero(
                                                          transitionOnUserGestures:
                                                              true,
                                                          tag: eventData[
                                                                  "events"]
                                                              [index]["title"],
                                                          child: Text(
                                                            eventData["events"]
                                                                    [index]
                                                                ["title"],
                                                            textAlign:
                                                                TextAlign.left,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                            style: textStyle(
                                                                15.sp,
                                                                FontWeight.bold,
                                                                themeProvider
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                                FontStyle
                                                                    .normal),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "Event Type : " +
                                                            eventData["events"]
                                                                [index]["type"],
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
                                                        "Date : " +
                                                            eventData["events"]
                                                                    [index]
                                                                ["startDate"],
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
                                                        "Price : " +
                                                            eventData["events"]
                                                                    [index]
                                                                ["eventPrice"],
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
                                                      Text(
                                                        "Hosted By : " +
                                                            eventData["events"]
                                                                        [index][
                                                                    "createdBy"]
                                                                [0]["name"],
                                                        textScaleFactor: 1,
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: textStyle(
                                                            11.sp,
                                                            FontWeight.w600,
                                                            themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontStyle.normal),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
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
                                                          onPressed: () {
                                                            Get.to(
                                                                () =>
                                                                    const EventDetail(),
                                                                transition: Transition.fadeIn,
                                                                duration: const Duration(milliseconds: 500),
                                                                arguments: {
                                                                  "eventData":
                                                                      eventData[
                                                                              "events"]
                                                                          [
                                                                          index]
                                                                });
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              "Participate",
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
                                            ),
                                          ),
                                        );
                                      }
                                      if (eventSearchLength == 0) {
                                        return Card(
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
                                              width: _width * 0.9,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: themeProvider
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : const Color
                                                                  .fromARGB(255,
                                                              151, 194, 8)),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color:
                                                      themeProvider.isDarkMode
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

                                      return Container();
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
                                    width: _width * 0.9,
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
                          }

                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Stream getEvents() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      eventData = await getAllEvents();
      yield eventData;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
