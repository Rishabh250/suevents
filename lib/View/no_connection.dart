import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Controller/providers/const.dart';
import '../Controller/providers/theme_service.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/connectionlost.png",
            height: 150,
            width: 100,
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
          const SizedBox(
            height: 20,
          ),
          Text('No Internet Connection',
              style: textStyle(
                  20.sp,
                  FontWeight.bold,
                  themeProvider.isDarkMode ? Colors.white : Colors.black,
                  FontStyle.normal)),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: width * 0.95,
            child: Text(
                'You are not connected to the internet.\nMake sure Wi-Fi or Mobile Data is on, Airplane Mode is off and try again',
                textAlign: TextAlign.center,
                style: textStyle(
                    12.sp,
                    FontWeight.w400,
                    themeProvider.isDarkMode ? Colors.white : Colors.black,
                    FontStyle.normal)),
          ),
        ],
      ),
    ));
  }
}
