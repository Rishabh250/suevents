import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/View/Faculty%20Portal/Navigation%20Bar/navigation_bar.dart';

import '../../../Controller/providers/theme_service.dart';

class CreateEventConfirm extends StatefulWidget {
  const CreateEventConfirm({Key? key}) : super(key: key);

  @override
  State<CreateEventConfirm> createState() => _CreateEventConfirmState();
}

class _CreateEventConfirmState extends State<CreateEventConfirm> {
  var eventData = Get.arguments;
  @override
  void initState() {
    log(eventData.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.transparent,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Text(
                  "Event Created",
                  style: textStyle(
                      20.sp,
                      FontWeight.bold,
                      themeProvider.isDarkMode ? Colors.white : Colors.black,
                      FontStyle.normal),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                    width: width * 0.9,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Title : ",
                                style: textStyle(
                                    15.sp,
                                    FontWeight.w400,
                                    themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontStyle.normal),
                              ),
                              Text(
                                eventData["title"],
                                style: textStyle(
                                    15.sp,
                                    FontWeight.bold,
                                    themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontStyle.normal),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Type : ",
                                style: textStyle(
                                    15.sp,
                                    FontWeight.w400,
                                    themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontStyle.normal),
                              ),
                              Text(
                                eventData["type"],
                                style: textStyle(
                                    15.sp,
                                    FontWeight.bold,
                                    themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontStyle.normal),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Date : ",
                                style: textStyle(
                                    15.sp,
                                    FontWeight.w400,
                                    themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontStyle.normal),
                              ),
                              Text(
                                eventData["date"],
                                style: textStyle(
                                    15.sp,
                                    FontWeight.bold,
                                    themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontStyle.normal),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(eventData["about"],
                          textAlign: TextAlign.center,
                          style: textStyle(
                              12.sp,
                              FontWeight.w600,
                              themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              FontStyle.normal)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.offAll(() => const FacultyNavigationBarPage(),
              transition: Transition.fadeIn);
        },
        label: Row(
          children: [
            Icon(
              Icons.arrow_back,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              size: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Text("Back to home",
                style: textStyle(
                    12.sp,
                    FontWeight.w600,
                    themeProvider.isDarkMode
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : Colors.black,
                    FontStyle.normal)),
          ],
        ),
      ),
    );
  }
}
