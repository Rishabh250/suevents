import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';

import '../../../Models/Faculty API/faculty_api.dart';

class FacultyEventDetail extends StatefulWidget {
  var event;
  FacultyEventDetail({Key? key, required this.event}) : super(key: key);

  @override
  State<FacultyEventDetail> createState() => _FacultyEventDetailState();
}

class _FacultyEventDetailState extends State<FacultyEventDetail> {
  var user;
  var eventList;
  ValueNotifier<String> btnTxt = ValueNotifier("Participate");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    btnTxt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            slivers: [
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
                        style: textStyle(12.sp, FontWeight.w700, Colors.white,
                            FontStyle.normal),
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
                          width: width * 0.95,
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
                                            const Color.fromARGB(
                                                255, 43, 6, 210),
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
                                            const Color.fromARGB(
                                                255, 43, 6, 210),
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
                                            const Color.fromARGB(
                                                255, 43, 6, 210),
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
                        width: width * 0.95,
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
                              width: width * 0.85,
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
                      width: width,
                      eventID: widget.event["_id"],
                      themeProvider: themeProvider,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                            elevation: 4,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () async {},
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ValueListenableBuilder(
                                    valueListenable: btnTxt,
                                    builder: (context, value, child) {
                                      return Text(
                                        "Create Round ${widget.event["rounds"].length + 1}",
                                        style: textStyle(12.sp, FontWeight.bold,
                                            Colors.black, FontStyle.normal),
                                      );
                                    }))),
                        MaterialButton(
                            elevation: 4,
                            color: const Color.fromARGB(255, 104, 4, 4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () async {},
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ValueListenableBuilder(
                                    valueListenable: btnTxt,
                                    builder: (context, value, child) {
                                      return Text(
                                        "Close Event",
                                        style: textStyle(12.sp, FontWeight.bold,
                                            Colors.white, FontStyle.normal),
                                      );
                                    }))),
                      ],
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

class FacultyAssined extends StatelessWidget {
  final double _width;
  final ThemeProvider themeProvider;
  var eventID;
  FacultyAssined({
    Key? key,
    required double width,
    required this.eventID,
    required this.themeProvider,
  })  : _width = width,
        super(key: key);

  var faculty;

  getFacultyData() async {
    faculty = await getAssignedFaculty(eventID);
    return faculty;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width * 0.95,
      height: 120,
      child: FutureBuilder(
          future: getFacultyData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: _width * 0.6,
                          height: 250.0,
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
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: _width * 0.6,
                          height: 250,
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
                    ),
                  ],
                ),
              );
            }
            if (faculty["facultyAssigned"].length == 0) {
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
                  ));
            }
            return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: faculty["facultyAssigned"].length,
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
                                  faculty["facultyAssigned"][index]["name"],
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
                                    faculty["facultyAssigned"][index]
                                        ["systemID"],
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
                });
          }),
    );
  }
}
