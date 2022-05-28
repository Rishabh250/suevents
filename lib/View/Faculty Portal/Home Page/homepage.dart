import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/Models/Faculty%20API/faculty_auth.dart';
import 'package:suevents/View/Faculty%20Portal/Create%20Event/event_create.dart';

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

  getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
    getUserDetails = await getFacultyData(token);
    setState(() {
      name = getUserDetails["user"]["name"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
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
            children: [
              TopBar(themeProvider: themeProvider),
              SizedBox(
                height: 4.h,
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
                      return CreateEvent();
                    }),
              ),
            ],
          ),
        ))
      ]),
    );
  }
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
              onTap: () {}, child: const Icon(Icons.settings_rounded))
        ],
      ),
    );
  }
}
