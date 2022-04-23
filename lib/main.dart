import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Screens/Autentication/login.dart';
import 'package:suevents/providers/theme_service.dart';

var isLog;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  isLog = sharedPreferences.getBool("isLogged");
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 35.0
    ..radius = 20.0
    ..userInteractions = true
    ..dismissOnTap = true;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
                home: const LoginPage(),
                builder: EasyLoading.init(builder: (context, builder) {
                  final mediaQueryData = MediaQuery.of(context);
                  final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.3);
                  return MediaQuery(
                    child: builder!,
                    data:
                        MediaQuery.of(context).copyWith(textScaleFactor: scale),
                  );
                }));
          },
        );
      });
}
