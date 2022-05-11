import 'package:flutter/material.dart';

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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "shardaLogo.png",
                        height: 100.0,
                      ),
                      Column(
                        children: [
                          Text("Sharda University"),
                          Text("A Truly Global University"),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  Text("Select Your Occupation"),
                  SizedBox(
                    height: 70.0,
                  ),
                  SelectionButtons(
                    Occupation: "Teacher",
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  SelectionButtons(Occupation: "Student"),
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
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(8.0),
        child: Text(
          Occupation,
        ),
      ),
    );
  }
}
