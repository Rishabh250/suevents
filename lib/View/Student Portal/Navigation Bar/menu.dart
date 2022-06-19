import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:mailto/mailto.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/View/get_started.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../Controller/SharedPreferences/token.dart';
import '../../about_app.dart';
import '../Profile Page/profile.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  ValueNotifier appName = ValueNotifier(""),
      packageName = ValueNotifier(""),
      version = ValueNotifier(""),
      buildNumber = ValueNotifier("");
  var userData;
  var token;
  @override
  void initState() {
    super.initState();
    userDetailsController.fetchUserData();
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
            Get.to(const ProfilePage(), transition: Transition.fadeIn);
          },
          child: FutureBuilder(
              future: userDetailsController.fetchUserData(),
              builder: (context, snapshot) {
                return DrawerHeader(
                    child: Column(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: userDetailsController.userImage,
                        builder: (context, value, child) {
                          return "$value" == ""
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: ExactAssetImage(
                                    userDetailsController.gender.value == "Male"
                                        ? "assets/images/boy.png"
                                        : "assets/images/girl.png",
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 12.w,
                                  backgroundImage: NetworkImage("$value"),
                                );
                        }),
                    const Spacer(),
                    ValueListenableBuilder(
                        valueListenable: userDetailsController.name,
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
        Text(
          "Student Portal",
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style:
              textStyle(8.sp, FontWeight.w400, Colors.white, FontStyle.normal),
        ),
        SizedBox(
          height: 5.h,
        ),
        ListTile(
          onTap: () {
            ZoomDrawer.of(context)?.close();

            Get.to(() => const AboutApp(), transition: Transition.fadeIn);
          },
          title: Text("About app",
              style: textStyle(
                  10.sp, FontWeight.w400, Colors.white, FontStyle.normal)),
        ),
        ListTile(
          onTap: () async {
            final mailtoLink = Mailto(
              to: ['rishu25bansal@gmail.com'],
              subject: 'Student Help & Support',
              body:
                  'Hello Sir/Mam, \n\n Myself ${userDetailsController.name.value} from ${userDetailsController.course.value} ${userDetailsController.year.value} year \n System ID: ${userDetailsController.systemID.value} \n',
            );
            await launchUrlString('$mailtoLink');
          },
          title: Text("Help & Support",
              style: textStyle(
                  10.sp, FontWeight.w400, Colors.white, FontStyle.normal)),
        ),
        ListTile(
          onTap: () async {
            final mailtoLink = Mailto(
              to: ['rishu25bansal@gmail.com'],
              subject: 'Student Feedback',
              body:
                  'Hello Sir/Mam, \n\n Myself ${userDetailsController.name.value} from ${userDetailsController.course.value} ${userDetailsController.year.value} year \n System ID: ${userDetailsController.systemID.value} \n',
            );
            await launchUrlString('$mailtoLink');
          },
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
