import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/Faculty%20Controller/faculty_controller.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/View/get_started.dart';

import '../../../../Controller/SharedPreferences/token.dart';
import '../Profile Page/profile.dart';

class FacultyMenuScreen extends StatefulWidget {
  const FacultyMenuScreen({Key? key}) : super(key: key);

  @override
  State<FacultyMenuScreen> createState() => _FacultyMenuScreenState();
}

class _FacultyMenuScreenState extends State<FacultyMenuScreen> {
  FacultyController controller = FacultyController();
  ValueNotifier appName = ValueNotifier(""),
      packageName = ValueNotifier(""),
      version = ValueNotifier(""),
      buildNumber = ValueNotifier("");
  @override
  void initState() {
    super.initState();
    getAppInfo();
  }

  getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName.value = packageInfo.appName;
    packageName.value = packageInfo.packageName;
    version.value = packageInfo.version;
    buildNumber.value = packageInfo.buildNumber;
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
          child: FutureBuilder(
              future: controller.fetchFacultyData(),
              builder: (context, snapshot) {
                return DrawerHeader(
                    child: Column(
                  children: [
                    controller.userImage.value == ""
                        ? CircleAvatar(
                            radius: 12.w,
                            backgroundImage:
                                const AssetImage("assets/images/bg.jpg"),
                          )
                        : ValueListenableBuilder(
                            valueListenable: controller.userImage,
                            builder: (context, value, child) {
                              return CircleAvatar(
                                radius: 12.w,
                                backgroundImage: NetworkImage("$value"),
                              );
                            }),
                    const Spacer(),
                    ValueListenableBuilder(
                        valueListenable: controller.name,
                        builder: (context, value, child) {
                          return Text(
                            "$value",
                            textScaleFactor: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: textStyle(10.sp, FontWeight.w700,
                                Colors.white, FontStyle.normal),
                          );
                        }),
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
          title: ValueListenableBuilder(
            valueListenable: version,
            builder: (context, value, child) {
              return Text("Version : $value",
                  style: textStyle(
                      10.sp, FontWeight.w400, Colors.white, FontStyle.normal));
            },
          ),
        ),
        ListTile(
          onTap: () async {
            EasyLoading.show();
            await Future.delayed(const Duration(seconds: 1));
            EasyLoading.dismiss();
            loginStatus(false);
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