import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/providers/const.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({Key? key}) : super(key: key);

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/shardaLogo.png",
                        height: 100.0,
                      ),
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sharda University",
                            style: textStyle(16.sp, FontWeight.w600,
                                Colors.black, FontStyle.normal),
                          ),
                          Text("A Truly Global University"),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 70.0,
                  ),
                  Text("Select Your Occupation", style: textStyle(17.sp, FontWeight.w300,
                                Colors.black, FontStyle.normal), ),
                  SizedBox(
                    height: 50.0,
                  ),
                  SelectionButtons(
                    Occupation: "Teacher",
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SelectionButtons(
                    Occupation: "Student",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectionButtons extends StatelessWidget {
  SelectionButtons({required this.Occupation});

  String Occupation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xFF6851FD),
      ),
      width: double.infinity,
      height: 87,
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          Occupation ,
          style: textStyle(20.sp, FontWeight.w400,
                                  Colors.black, FontStyle.normal),
        ),
      ),
    );
  }
}
