// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, must_call_super, unused_local_variable

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/Internet%20Connection/connection_provider.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Student%20API/authentication_api.dart';
import 'package:suevents/View/Student%20Portal/Profile%20Page/profile.dart';
import 'package:suevents/View/Student%20Portal/Search%20Page/search_page.dart';
import 'package:suevents/View/Student%20Portal/View%20All%20Events/general_events.dart';
import 'package:suevents/View/Student%20Portal/View%20All%20Events/placements_events.dart';
import 'package:suevents/View/no_connection.dart';

import '../../../../Models/Event Api/events_api.dart';
import '../Events/events_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  var token;
  var getUserDetails;
  var eventData, generalEvent;
  ValueNotifier name = ValueNotifier(""),
      greet = ValueNotifier(""),
      searchEvents = ValueNotifier("");
  int eventsIndexLength = 1, eventSearchLength = 0;
  var time = DateTime.now().hour;

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMontering();
    userDetailsController.fetchUserData();
    if (time >= 6 && time <= 12) {
      greet.value = "Good Morning";
    } else if (time > 12 && time <= 16) {
      greet.value = "Good Afternoon";
    } else {
      greet.value = "Good Evening";
    }
    getToken();
  }

  getToken() async {
    if (!mounted) return;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
    getUserDetails = await getUserData(token);
    name.value = getUserDetails["user"]["name"];
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Consumer<ConnectivityProvider>(builder: (context, model, child) {
      return model.isOnline
          ? WillPopScope(
              onWillPop: onWillPop,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
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
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        toolbarHeight: 0,
                      ),
                      body: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const ProfilePage(),
                                          transition: Transition.fadeIn,
                                          duration: const Duration(
                                              milliseconds: 500));
                                    },
                                    child: ValueListenableBuilder(
                                        valueListenable:
                                            userDetailsController.userImage,
                                        builder: (context, value, child) {
                                          return "$value" == ""
                                              ? CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: ExactAssetImage(userDetailsController
                                                                  .gender
                                                                  .value ==
                                                              "Male" ||
                                                          userDetailsController
                                                                  .gender
                                                                  .value ==
                                                              "male"
                                                      ? "assets/images/boy.png"
                                                      : userDetailsController
                                                                      .gender
                                                                      .value ==
                                                                  "Female" ||
                                                              userDetailsController
                                                                      .gender
                                                                      .value ==
                                                                  "female"
                                                          ? "assets/images/girl.png"
                                                          : "assets/images/boy.png"),
                                                )
                                              : CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage:
                                                      NetworkImage("$value"),
                                                );
                                        }),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: greet,
                                      builder: (context, value, child) {
                                        return Text("$value..!",
                                            style: textStyle(
                                                8.sp,
                                                FontWeight.w400,
                                                themeProvider.isDarkMode
                                                    ? Colors.grey
                                                    : Colors.black,
                                                FontStyle.normal));
                                      }),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable:
                                          userDetailsController.name,
                                      builder: (context, value, child) {
                                        return Text(
                                            "Hi, ${userDetailsController.name.value}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2);
                                      }),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Center(
                                    child: Hero(
                                      tag: "searchBar",
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(
                                              () => const StudentEventsSearch(),
                                              transition: Transition.fadeIn);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: width * 0.7,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      style: BorderStyle.solid,
                                                      color: themeProvider
                                                              .isDarkMode
                                                          ? Colors.grey
                                                          : const Color
                                                                  .fromARGB(255,
                                                              151, 194, 8)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0, right: 10),
                                                  child: TextField(
                                                    enabled: false,
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
                                                        hintTextDirection:
                                                            TextDirection.ltr,
                                                        hintStyle: textStyle(
                                                            12.sp,
                                                            FontWeight.w500,
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                129,
                                                                128,
                                                                128),
                                                            FontStyle.normal),
                                                        border:
                                                            InputBorder.none),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: width * 0.14,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 131, 169, 7),
                                                  border: Border.all(
                                                      width: 0,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Center(
                                                  child: Image.asset(
                                                "assets/icons/search.png",
                                                width: 25,
                                                color: Colors.white,
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Placements Events",
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
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(() =>
                                                  const ViewAllPlacements());
                                            },
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
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FutureBuilder(
                                    future: getPlacments(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SingleChildScrollView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.transparent,
                                                  ),
                                                  width: width * 0.6,
                                                  height: textScale == 1.0
                                                      ? 250.0
                                                      : 300,
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        themeProvider.isDarkMode
                                                            ? Colors.black
                                                            : Colors.white,
                                                    highlightColor:
                                                        themeProvider.isDarkMode
                                                            ? Colors
                                                                .white
                                                                .withOpacity(
                                                                    0.5)
                                                            : Colors.black
                                                                .withOpacity(
                                                                    0.3),
                                                    period: const Duration(
                                                        seconds: 2),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 1.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.transparent,
                                                  ),
                                                  width: width * 0.6,
                                                  height: textScale == 1.0
                                                      ? 250.0
                                                      : 300,
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        themeProvider.isDarkMode
                                                            ? Colors.black
                                                            : Colors.white,
                                                    highlightColor:
                                                        themeProvider.isDarkMode
                                                            ? Colors
                                                                .white
                                                                .withOpacity(
                                                                    0.5)
                                                            : Colors.black
                                                                .withOpacity(
                                                                    0.3),
                                                    period: const Duration(
                                                        seconds: 2),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 1.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color:
                                                              Colors.grey[400]!,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        );
                                      }
                                      if (snapshot.hasData) {
                                        if (eventData["events"].length > 0) {
                                          return SizedBox(
                                            width: width,
                                            height:
                                                textScale == 1.0 ? 270.0 : 320,
                                            child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount:
                                                    eventData["events"].length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Card(
                                                      color: Colors.transparent,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      elevation: 8,
                                                      child: OpenContainer(
                                                          openElevation: 0,
                                                          closedElevation: 4,
                                                          closedColor:
                                                              themeProvider
                                                                      .isDarkMode
                                                                  ? HexColor(
                                                                      "#020E26")
                                                                  : Colors
                                                                      .white,
                                                          closedShape:
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                          middleColor:
                                                              themeProvider
                                                                      .isDarkMode
                                                                  ? HexColor(
                                                                      "#020E26")
                                                                  : Colors
                                                                      .white,
                                                          openColor:
                                                              themeProvider
                                                                      .isDarkMode
                                                                  ? HexColor(
                                                                      "#020E26")
                                                                  : Colors
                                                                      .white,
                                                          clipBehavior:
                                                              Clip
                                                                  .antiAliasWithSaveLayer,
                                                          transitionDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          transitionType:
                                                              ContainerTransitionType
                                                                  .fadeThrough,
                                                          closedBuilder:
                                                              (context,
                                                                  action) {
                                                            return Container(
                                                              width:
                                                                  width * 0.6,
                                                              color: themeProvider
                                                                      .isDarkMode
                                                                  ? HexColor(
                                                                      "#020E26")
                                                                  : Colors
                                                                      .white,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          eventData["events"][index]
                                                                              [
                                                                              "title"],
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              2,
                                                                          style: textStyle(
                                                                              15.sp,
                                                                              FontWeight.bold,
                                                                              themeProvider.isDarkMode ? Colors.white : Colors.black,
                                                                              FontStyle.normal),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Text(
                                                                        "Event Type : ${eventData["events"][index]["type"]}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        style: textStyle(
                                                                            10.sp,
                                                                            FontWeight.w600,
                                                                            themeProvider.isDarkMode ? Colors.white : Colors.black,
                                                                            FontStyle.normal),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Date : ${eventData["events"][index]["startDate"]}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        style: textStyle(
                                                                            10.sp,
                                                                            FontWeight.w600,
                                                                            themeProvider.isDarkMode ? Colors.white : Colors.black,
                                                                            FontStyle.normal),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Price : ${eventData["events"][index]["eventPrice"]}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        style: textStyle(
                                                                            10.sp,
                                                                            FontWeight.w600,
                                                                            themeProvider.isDarkMode ? Colors.white : Colors.black,
                                                                            FontStyle.normal),
                                                                      ),
                                                                      const Spacer(),
                                                                      Text(
                                                                        "Hosted By : ${eventData["events"][index]["createdBy"][0]["name"]}",
                                                                        textScaleFactor:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        style: textStyle(
                                                                            11.sp,
                                                                            FontWeight.w600,
                                                                            themeProvider.isDarkMode ? Colors.white : Colors.black,
                                                                            FontStyle.normal),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                              primary: themeProvider.isDarkMode ? const Color.fromARGB(255, 14, 76, 191) : const Color.fromARGB(255, 1, 64, 181),
                                                                              elevation: 4),
                                                                          onPressed: action,
                                                                          child: Center(
                                                                            child:
                                                                                Text(
                                                                              eventData["events"][index]["registration"] == true ? "Participate" : "Registration closed",
                                                                              textScaleFactor: 1,
                                                                              style: textStyle(12.sp, FontWeight.w600, Colors.white, FontStyle.normal),
                                                                            ),
                                                                          ))
                                                                    ]),
                                                              ),
                                                            );
                                                          },
                                                          openBuilder: (context,
                                                              action) {
                                                            return EventDetail(
                                                              event: eventData[
                                                                      "events"]
                                                                  [index],
                                                            );
                                                          }),
                                                    ),
                                                  );
                                                }),
                                          );
                                        } else {
                                          return Card(
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
                                                width: width * 0.9,
                                                height: 120.0,
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
                                                        BorderRadius.circular(
                                                            20),
                                                    color: themeProvider
                                                            .isDarkMode
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "General Events",
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
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => const ViewAllGeneral());
                                          },
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
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FutureBuilder(
                                    future: getGeneral(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SingleChildScrollView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.transparent,
                                                  ),
                                                  width: width * 0.6,
                                                  height: textScale == 1.0
                                                      ? 250.0
                                                      : 300,
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        themeProvider.isDarkMode
                                                            ? Colors.black
                                                            : Colors.white,
                                                    highlightColor:
                                                        themeProvider.isDarkMode
                                                            ? Colors
                                                                .white
                                                                .withOpacity(
                                                                    0.5)
                                                            : Colors.black
                                                                .withOpacity(
                                                                    0.3),
                                                    period: const Duration(
                                                        seconds: 2),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 1.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.transparent,
                                                  ),
                                                  width: width * 0.6,
                                                  height: textScale == 1.0
                                                      ? 250.0
                                                      : 300,
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        themeProvider.isDarkMode
                                                            ? Colors.black
                                                            : Colors.white,
                                                    highlightColor:
                                                        themeProvider.isDarkMode
                                                            ? Colors
                                                                .white
                                                                .withOpacity(
                                                                    0.5)
                                                            : Colors.black
                                                                .withOpacity(
                                                                    0.3),
                                                    period: const Duration(
                                                        seconds: 2),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 1.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color:
                                                              Colors.grey[400]!,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        );
                                      }
                                      if (snapshot.hasData) {
                                        if (generalEvent["events"].length > 0) {
                                          return SizedBox(
                                            width: width,
                                            height:
                                                textScale == 1.0 ? 270.0 : 320,
                                            child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount:
                                                    generalEvent["events"]
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Card(
                                                      color: Colors.transparent,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      elevation: 8,
                                                      child: OpenContainer(
                                                          openElevation: 0,
                                                          closedElevation: 4,
                                                          closedColor:
                                                              themeProvider
                                                                      .isDarkMode
                                                                  ? HexColor(
                                                                      "#020E26")
                                                                  : Colors
                                                                      .white,
                                                          closedShape:
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                          middleColor:
                                                              themeProvider
                                                                      .isDarkMode
                                                                  ? HexColor(
                                                                      "#020E26")
                                                                  : Colors
                                                                      .white,
                                                          openColor:
                                                              themeProvider
                                                                      .isDarkMode
                                                                  ? HexColor(
                                                                      "#020E26")
                                                                  : Colors
                                                                      .white,
                                                          clipBehavior:
                                                              Clip
                                                                  .antiAliasWithSaveLayer,
                                                          transitionDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          transitionType:
                                                              ContainerTransitionType
                                                                  .fadeThrough,
                                                          closedBuilder:
                                                              (context,
                                                                  action) {
                                                            return Container(
                                                              width:
                                                                  width * 0.6,
                                                              color: themeProvider
                                                                      .isDarkMode
                                                                  ? HexColor(
                                                                      "#020E26")
                                                                  : Colors
                                                                      .white,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          generalEvent["events"][index]
                                                                              [
                                                                              "title"],
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              2,
                                                                          style: textStyle(
                                                                              15.sp,
                                                                              FontWeight.bold,
                                                                              themeProvider.isDarkMode ? Colors.white : Colors.black,
                                                                              FontStyle.normal),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Text(
                                                                        "Event Type : ${generalEvent["events"][index]["type"]}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        style: textStyle(
                                                                            10.sp,
                                                                            FontWeight.w600,
                                                                            themeProvider.isDarkMode ? Colors.white : Colors.black,
                                                                            FontStyle.normal),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Date : ${generalEvent["events"][index]["startDate"]}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        style: textStyle(
                                                                            10.sp,
                                                                            FontWeight.w600,
                                                                            themeProvider.isDarkMode ? Colors.white : Colors.black,
                                                                            FontStyle.normal),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Price : ${generalEvent["events"][index]["eventPrice"]}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        style: textStyle(
                                                                            10.sp,
                                                                            FontWeight.w600,
                                                                            themeProvider.isDarkMode ? Colors.white : Colors.black,
                                                                            FontStyle.normal),
                                                                      ),
                                                                      const Spacer(),
                                                                      Text(
                                                                        "Hosted By : ${generalEvent["events"][index]["createdBy"][0]["name"]}",
                                                                        textScaleFactor:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        style: textStyle(
                                                                            11.sp,
                                                                            FontWeight.w600,
                                                                            themeProvider.isDarkMode ? Colors.white : Colors.black,
                                                                            FontStyle.normal),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                              primary: themeProvider.isDarkMode ? const Color.fromARGB(255, 14, 76, 191) : const Color.fromARGB(255, 1, 64, 181),
                                                                              elevation: 4),
                                                                          onPressed: action,
                                                                          child: Center(
                                                                            child:
                                                                                Text(
                                                                              generalEvent["events"][index]["registration"] == true ? "Participate" : "Registration closed",
                                                                              textScaleFactor: 1,
                                                                              style: textStyle(12.sp, FontWeight.w600, Colors.white, FontStyle.normal),
                                                                            ),
                                                                          ))
                                                                    ]),
                                                              ),
                                                            );
                                                          },
                                                          openBuilder: (context,
                                                              action) {
                                                            return EventDetail(
                                                              event: generalEvent[
                                                                      "events"]
                                                                  [index],
                                                            );
                                                          }),
                                                    ),
                                                  );
                                                }),
                                          );
                                        } else {
                                          return Card(
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
                                                width: width * 0.9,
                                                height: 120.0,
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
                                                        BorderRadius.circular(
                                                            20),
                                                    color: themeProvider
                                                            .isDarkMode
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
                                              height: 120.0,
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
                                    },
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            )
          : const NoInternet();
    });
  }

  getGeneral() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    generalEvent = await getGeneralEvents();
    return generalEvent;
  }

  getPlacments() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    eventData = await getPlacementEvents();
    return eventData;
  }

  @override
  bool get wantKeepAlive => true;
}
