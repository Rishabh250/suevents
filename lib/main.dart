// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/Internet%20Connection/connection_provider.dart';
import 'package:suevents/splash_screen.dart';

import 'Controller/providers/theme_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 10)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 30.0
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
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => ConnectivityProvider(),
              child: Sizer(
                builder: (BuildContext context, Orientation orientation,
                    DeviceType deviceType) {
                  return GetMaterialApp(
                      debugShowCheckedModeBanner: false,
                      themeMode: themeMode.value,
                      theme: MyThemes.lightTheme,
                      darkTheme: MyThemes.darkTheme,
                      home: const SplastScreen(),

                      // home: const Getstarted(),
                      builder: EasyLoading.init(builder: (context, builder) {
                        final mediaQueryData = MediaQuery.of(context);
                        final scale =
                            mediaQueryData.textScaleFactor.clamp(1.0, 1.3);
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: scale),
                          child: builder!,
                        );
                      }));
                },
              ),
            )
          ],
          child: Sizer(
            builder: (BuildContext context, Orientation orientation,
                DeviceType deviceType) {
              return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  themeMode: themeMode.value,
                  theme: MyThemes.lightTheme,
                  darkTheme: MyThemes.darkTheme,
                  home: const SplastScreen(),

                  // home: const Getstarted(),
                  builder: EasyLoading.init(builder: (context, builder) {
                    final mediaQueryData = MediaQuery.of(context);
                    final scale =
                        mediaQueryData.textScaleFactor.clamp(1.0, 1.3);
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaleFactor: scale),
                      child: builder!,
                    );
                  }));
            },
          ),
        );
      });
}
