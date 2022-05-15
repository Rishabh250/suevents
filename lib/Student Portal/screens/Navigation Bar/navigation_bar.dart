import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_service.dart';
import '../Applied Events/events.dart';
import '../Home Page/homepage.dart';
import '../Profile Page/profile.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
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
          children: const [HomePage(), EventsPage(), ProfilePage()],
        ),
        extendBody: true,
        bottomNavigationBar: CustomNavigationBar(
          elevation: 0,
          iconSize: 30.0,
          selectedColor: const Color.fromARGB(255, 0, 4, 255),
          strokeColor: const Color.fromARGB(255, 5, 135, 241),
          unSelectedColor: Colors.black,
          backgroundColor: Colors.transparent,
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
        ));
  }
}
