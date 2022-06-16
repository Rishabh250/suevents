import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Controller/providers/const.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('No Internet Connection',
          style:
              textStyle(20.sp, FontWeight.bold, Colors.red, FontStyle.normal)),
    ));
  }
}
