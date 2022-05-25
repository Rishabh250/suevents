import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Models/Faculty%20API/faculty_auth.dart';
import 'package:suevents/View/get_started.dart';

import '../../../../Controller/SharedPreferences/token.dart';
import '../Profile Page/profile.dart';

class FacultyMenuScreen extends StatefulWidget {
  const FacultyMenuScreen({Key? key}) : super(key: key);

  @override
  State<FacultyMenuScreen> createState() => _FacultyMenuScreenState();
}

class _FacultyMenuScreenState extends State<FacultyMenuScreen> {
  String name = "",
      appName = "",
      packageName = "",
      version = "",
      buildNumber = "",
      userImage = "";
  var userData;
  var token;
  @override
  void initState() {
    super.initState();
    fetchData();
    getAppInfo();
  }

  getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  fetchData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
  }

  Stream fetchUserData() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      userData = await getFacultyData(token);
      setState(() {
        name = userData["user"]["name"];
        userImage = userData["user"]["profileImage"];
      });
      yield userData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 2.h,
        ),
        GestureDetector(
          onTap: () {
            ZoomDrawer.of(context)?.close();

            Get.to(const FacultyProfilePage(), transition: Transition.fadeIn);
          },
          child: StreamBuilder(
              stream: fetchUserData(),
              builder: (context, snapshot) {
                return DrawerHeader(
                    child: Column(
                  children: [
                    userImage == ""
                        ? CircleAvatar(
                            radius: 12.w,
                            backgroundImage:
                                const AssetImage("assets/images/bg.jpg"),
                          )
                        : CircleAvatar(
                            radius: 12.w,
                            backgroundImage: NetworkImage(userImage),
                          ),
                    const Spacer(),
                    Text(
                      name,
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle(10.sp, FontWeight.w700, Colors.white,
                          FontStyle.normal),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                  ],
                ));
              }),
        ),
        SizedBox(
          height: 5.h,
        ),
        ListTile(
          onTap: () {},
          title: Text("About app",
              style: textStyle(
                  10.sp, FontWeight.w400, Colors.white, FontStyle.normal)),
        ),
        ListTile(
          title: Text("Help & Support",
              style: textStyle(
                  10.sp, FontWeight.w400, Colors.white, FontStyle.normal)),
        ),
        ListTile(
          title: Text("Feedback",
              style: textStyle(
                  10.sp, FontWeight.w400, Colors.white, FontStyle.normal)),
        ),
        const Spacer(),
        ListTile(
          title: Text("Version : $version",
              style: textStyle(
                  10.sp, FontWeight.w400, Colors.white, FontStyle.normal)),
        ),
        ListTile(
          onTap: () async {
            EasyLoading.show();
            await Future.delayed(const Duration(seconds: 1));
            EasyLoading.dismiss();
            loginStatus(false);
            getUser("");
            Get.offAll(() => const Getstarted());
          },
          title: Row(
            children: [
              const Icon(Icons.logout_rounded, color: Colors.white),
              const SizedBox(
                width: 10,
              ),
              Text("Logout",
                  style: textStyle(
                      10.sp, FontWeight.w400, Colors.white, FontStyle.normal)),
            ],
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }
}
