import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/View/Faculty%20Portal/Assigned%20Events/assigned_events.dart';
import 'package:suevents/View/Faculty%20Portal/Home%20Page/homepage.dart';

class FacultyNavigationBarPage extends StatefulWidget {
  const FacultyNavigationBarPage({Key? key}) : super(key: key);

  @override
  State<FacultyNavigationBarPage> createState() =>
      _FacultyNavigationBarPageState();
}

class _FacultyNavigationBarPageState extends State<FacultyNavigationBarPage> {
  late PageController pageController;
  final GlobalKey<FormFieldState<String>> pageKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _currentIndex, keepPage: true);
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          key: pageKey,
          onPageChanged: (index) {},
          children: const [FacultyHomePage(), AssignedEvents()],
        ),
        extendBody: true,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: CustomNavigationBar(
            isFloating: true,
            elevation: 4,
            iconSize: 25.0,
            scaleFactor: 0.2,
            blurEffect: true,
            selectedColor: const Color.fromARGB(255, 8, 0, 255),
            strokeColor: Colors.transparent,
            unSelectedColor: Colors.white,
            backgroundColor: Colors.black,
            borderRadius: const Radius.circular(20),
            items: [
              CustomNavigationBarItem(
                icon: const Icon(Icons.home),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Icons.event_rounded),
              ),
            ],
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                setState(() {
                  pageController.animateToPage(_currentIndex,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.linearToEaseOut);
                });
              });
            },
          ),
        ));
  }
}
