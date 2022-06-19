import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Controller/providers/const.dart';
import '../Controller/providers/theme_service.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          pinned: true,
          forceElevated: true,
          flexibleSpace: const FlexibleSpaceBar(
            centerTitle: true,
          ),
          elevation: 8,
          backgroundColor: const Color.fromARGB(255, 30, 0, 255),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          title: Text(
            "About App",
            style: textStyle(
                14.sp, FontWeight.bold, Colors.white, FontStyle.normal),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [],
            ),
          ),
        )
      ],
    ));
  }
}
