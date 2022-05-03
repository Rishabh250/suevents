import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/providers/const.dart';

import '../../DB Connectivity/api/authentication_api.dart';
import '../../providers/theme_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var token;
  var user;
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
    user = await getUserData(token);
    log(user.toString());
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: FutureBuilder(
          future: fetchUserData(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (user != null) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        user["user"]["profileImage"] == ""
                            ? const CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage("assets/images/bg.jpg"),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(user["user"]["profileImage"]),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          user["user"]["name"],
                          style: textStyle(
                              15.sp,
                              FontWeight.bold,
                              themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              FontStyle.normal),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          user["user"]["email"],
                          style: textStyle(
                              10.sp,
                              FontWeight.w600,
                              themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              FontStyle.normal),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }

            return const Center(child: Text("Something went wrong"));
          })),
    );
  }
}
