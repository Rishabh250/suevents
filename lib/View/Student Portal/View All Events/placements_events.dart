import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../Controller/providers/const.dart';
import '../../../Controller/providers/theme_service.dart';
import '../../../Models/Event Api/events_api.dart';
import '../Events/events_detail.dart';

class ViewAllPlacements extends StatefulWidget {
  const ViewAllPlacements({Key? key}) : super(key: key);

  @override
  State<ViewAllPlacements> createState() => _ViewAllPlacementsState();
}

class _ViewAllPlacementsState extends State<ViewAllPlacements> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        body: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      slivers: [
        SliverAppBar(
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back_ios)),
          elevation: 0,
          title: Text(
            "Placements Events",
            style: textStyle(
                14.sp,
                FontWeight.w800,
                themeProvider.isDarkMode ? Colors.white : Colors.black,
                FontStyle.normal),
          ),
          backgroundColor: Colors.transparent,
        ),
        SliverToBoxAdapter(
          child: FutureBuilder(
            future: getPlacements(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Container(
                                width: width * 0.9,
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: themeProvider.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                  highlightColor: Colors.grey.withOpacity(0.5),
                                  period: const Duration(seconds: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey[400]!,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Container(
                                width: width * 0.9,
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: themeProvider.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                  highlightColor: Colors.grey.withOpacity(0.5),
                                  period: const Duration(seconds: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey[400]!,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              if (snapshot.hasData) {
                if (eventData["events"].length > 0) {
                  return Center(
                    child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: eventData["events"].length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: width,
                              height: 250,
                              child: Card(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
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
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    transitionType:
                                        ContainerTransitionType.fadeThrough,
                                    closedBuilder: (context, action) {
                                      return Container(
                                        width: width * 0.6,
                                        color: themeProvider.isDarkMode
                                            ? HexColor("#020E26")
                                            : Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    eventData["events"][index]
                                                        ["title"],
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
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "Event Type : ${eventData["events"][index]["type"]}",
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
                                                  "Date : ${eventData["events"][index]["startDate"]}",
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
                                                  "Price : ${eventData["events"][index]["eventPrice"]}",
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
                                                const Spacer(),
                                                Text(
                                                  "Hosted By : ${eventData["events"][index]["createdBy"][0]["name"]}",
                                                  textScaleFactor: 1,
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: textStyle(
                                                      11.sp,
                                                      FontWeight.w600,
                                                      themeProvider.isDarkMode
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
                                                    onPressed: action,
                                                    child: Center(
                                                      child: Text(
                                                        "Participate",
                                                        textScaleFactor: 1,
                                                        style: textStyle(
                                                            12.sp,
                                                            FontWeight.w600,
                                                            Colors.white,
                                                            FontStyle.normal),
                                                      ),
                                                    ))
                                              ]),
                                        ),
                                      );
                                    },
                                    openBuilder: (context, action) {
                                      return EventDetail(
                                        event: eventData["events"][index],
                                      );
                                    }),
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
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
                      ),
                    ],
                  );
                }
              }

              return Container();
            },
          ),
        )
      ],
    ));
  }

  var eventData;
  getPlacements() async {
    eventData = await getPlacementEvents();
    return eventData;
  }
}
