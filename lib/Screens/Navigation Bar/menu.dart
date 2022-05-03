import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/DB%20Connectivity/api/authentication_api.dart';
import 'package:suevents/Screens/Autentication/login.dart';
import 'package:suevents/SharedPreferences/token.dart';
import 'package:suevents/providers/const.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String name = "";
  String appName = "";
  String packageName = "";
  String version = "";
  String buildNumber = "";
  var userData;
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
    var token = sharedPreferences.getString("accessToken");
    userData = await getUserData(token);
    setState(() {
      name = userData["user"]["name"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 2.h,
        ),
        DrawerHeader(
            child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
            ),
            const Spacer(),
            Text(
              name,
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: textStyle(
                  10.sp, FontWeight.w700, Colors.white, FontStyle.normal),
            ),
            SizedBox(
              height: 1.h,
            ),
          ],
        )),
        SizedBox(
          height: 5.h,
        ),
        ListTile(
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
            Get.offAll(() => const LoginPage());
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
