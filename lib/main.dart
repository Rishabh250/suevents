// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/View/Faculty%20Portal/Navigation%20Bar/zoom_drawer.dart';

import 'Controller/providers/theme_service.dart';
import 'View/Student Portal/Navigation Bar/zoom_drawer.dart';
import 'View/get_started.dart';

var isLog;
var userType;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  isLog = sharedPreferences.getBool("isLogged");
  userType = sharedPreferences.getString("getUser");
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 10)
    ..indicatorType = EasyLoadingIndicatorType.spinningCircle
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 25.0
    ..radius = 15.0
    ..userInteractions = true
    ..dismissOnTap = true;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        EasyLoading.init();
        final themeProvider = Provider.of<ThemeProvider>(context);
        return Sizer(
          builder: (BuildContext context, Orientation orientation,
              DeviceType deviceType) {
            return GetMaterialApp(
                themeMode: themeProvider.themeMode,
                theme: MyThemes.lightTheme,
                darkTheme: MyThemes.darkTheme,
                home: isLog == true
                    ? userType == "Student"
                        ? const MainScreen()
                        : const FacultyMainScreen()
                    : const Getstarted(),

                // home: const Getstarted(),
                builder: EasyLoading.init(builder: (context, builder) {
                  final mediaQueryData = MediaQuery.of(context);
                  final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.3);
                  return MediaQuery(
                    data:
                        MediaQuery.of(context).copyWith(textScaleFactor: scale),
                    child: builder!,
                  );
                }));
          },
        );
      });
}
