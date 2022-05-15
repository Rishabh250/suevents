import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:suevents/providers/const.dart';

import '../../../providers/theme_service.dart';

class EventRounds extends StatefulWidget {
  const EventRounds({Key? key}) : super(key: key);

  @override
  State<EventRounds> createState() => _EventRoundsState();
}

class _EventRoundsState extends State<EventRounds> {
  late PageController pageController;
  var eventData = Get.arguments;
  late int _currentIndex;
  late int currentPage;
  @override
  void initState() {
    super.initState();
    currentPage = eventData["event"]["rounds"].length - 1;
    _currentIndex = currentPage;
    pageController = PageController(initialPage: currentPage);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: _width,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: eventData["event"]['rounds'].length,
                    // itemCount: 5,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                            pageController.animateToPage(_currentIndex,
                                curve: Curves.easeIn,
                                duration: const Duration(milliseconds: 500));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: _currentIndex == index
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: textStyle(
                                    15.0,
                                    FontWeight.bold,
                                    _currentIndex == index
                                        ? Colors.white
                                        : const Color.fromARGB(255, 0, 0, 0),
                                    FontStyle.normal),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: _height * 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      // itemCount: 5,
                      itemCount: eventData["event"]['rounds'].length,
                      itemBuilder: (context, index) {
                        return Container(
                            child: Text(
                              "${index + 1}",
                            ),
                            width: 100,
                            height: 100,
                            color: Colors.amber);
                      }),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
