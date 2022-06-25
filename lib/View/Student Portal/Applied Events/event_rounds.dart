// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/AESEncryption/aes_encryption.dart';
import 'package:suevents/Controller/Student_Controllers/events_controller.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/theme_service.dart';
import 'package:suevents/View/no_connection.dart';

import '../../../../Models/Student API/student_api.dart';
import '../../../Controller/Internet Connection/connection_provider.dart';
import '../../../Controller/providers/global_snackbar.dart';

class EventRounds extends StatefulWidget {
  var events;
  var index;

  EventRounds({key, required this.events, required this.index})
      : super(key: key);

  @override
  State<EventRounds> createState() => _EventRoundsState();
}

class _EventRoundsState extends State<EventRounds> {
  AESEncryption aesEncryption = AESEncryption();
  EventController eventController = EventController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final ScrollController _scrollController = ScrollController();
  ValueNotifier isDisable = ValueNotifier(false);
  late PageController pageController;
  var user, token, eventDetail, getEvent;
  late int _currentIndex;
  late int currentPage;

  final String _scanBarcode = 'Unknown';
  var currentDate =
      DateTime.now().toString().replaceRange(11, 26, "").split("-");
  String finalDate = "";
  List months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final key = encrypt.Key.fromUtf8('my 32 length key................');
  final iv = IV.fromLength(16);
  bool isVisible = false;
  var roundID, eventID, eventData, roundData, encrypter, decrypted;
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMontering();
    encrypter = Encrypter(AES(key));
    EasyLoading.show(dismissOnTap: false);
    currentPage = widget.events["rounds"].length - 1;
    _currentIndex = currentPage;
    pageController = PageController(initialPage: currentPage);
    eventController.userData();
    finalDate =
        "${currentDate[2]}${months[int.parse(currentDate[1]) - 1]}, ${currentDate[0]} ";
    fetchEvents();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    _scrollController.dispose();
    eventController.name.dispose();
    eventController.email.dispose();
    eventController.systemID.dispose();
    eventController.attendence.dispose();
  }

  Future<bool> _onBackPressed() {
    EasyLoading.dismiss();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Consumer<ConnectivityProvider>(builder: (context, model, child) {
        return model.isOnline
            ? RefreshIndicator(
                displacement: 100,
                backgroundColor:
                    themeProvider.isDarkMode ? Colors.grey[400] : Colors.white,
                color: themeProvider.isDarkMode ? Colors.black : Colors.black,
                strokeWidth: 3,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 1500));
                  await fetchEvents();
                  setState(() {});
                },
                child: Scaffold(
                  body: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        leading: GestureDetector(
                            onTap: () {
                              EasyLoading.dismiss();
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
                          widget.events['title'],
                          style: textStyle(14.sp, FontWeight.bold, Colors.white,
                              FontStyle.normal),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                widget.events['type']
                                        .toString()
                                        .contains("Placement")
                                    ? "Rounds"
                                    : "Session",
                                style: textStyle(
                                    18.sp,
                                    FontWeight.w700,
                                    themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    FontStyle.normal),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 1),
                              height: 50,
                              width: width,
                              child: ListView.builder(
                                  controller: _scrollController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.events['rounds'].length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        EasyLoading.show(dismissOnTap: false);
                                        setState(() {
                                          isVisible = false;
                                          _currentIndex = index;
                                          pageController.animateToPage(
                                              _currentIndex,
                                              curve: Curves.easeIn,
                                              duration: const Duration(
                                                  milliseconds: 500));
                                        });
                                        await fetchEvents();
                                        var event = roundData["present"];

                                        await eventController.checkAttendence(
                                            event, eventController.email.value);
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
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              "${index + 1}",
                                              style: textStyle(
                                                  15.0,
                                                  FontWeight.bold,
                                                  _currentIndex == index
                                                      ? Colors.white
                                                      : const Color.fromARGB(
                                                          255, 0, 0, 0),
                                                  FontStyle.normal),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: height * 0.9,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: PageView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: pageController,
                                    scrollDirection: Axis.horizontal,
                                    // itemCount: 5,
                                    itemCount: widget.events['rounds'].length,
                                    itemBuilder: (context, index) {
                                      roundID =
                                          widget.events['rounds'][index]["_id"];
                                      eventID = widget.events["_id"];

                                      return ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        controller: _scrollController,
                                        padding:
                                            const EdgeInsets.only(bottom: 50),
                                        shrinkWrap: true,
                                        children: [
                                          Card(
                                              color: Colors.transparent,
                                              elevation: 8,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Container(
                                                width: width,
                                                height: 300,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                        colors: [
                                                          HexColor("7ec9f5")
                                                              .withOpacity(0.5),
                                                          HexColor("3957ed")
                                                              .withOpacity(0.5)
                                                        ])),
                                                child: Visibility(
                                                  visible: isVisible,
                                                  replacement: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ValueListenableBuilder(
                                                        valueListenable:
                                                            eventController
                                                                .name,
                                                        builder: (context,
                                                            value, child) {
                                                          return Text(
                                                            "$value",
                                                            style: textStyle(
                                                                12.sp,
                                                                FontWeight.bold,
                                                                themeProvider
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                FontStyle
                                                                    .normal),
                                                          );
                                                        },
                                                      ),
                                                      ValueListenableBuilder(
                                                        valueListenable:
                                                            eventController
                                                                .email,
                                                        builder: (context,
                                                            value, child) {
                                                          return SizedBox(
                                                            width: width * 0.9,
                                                            child: Center(
                                                              child: Text(
                                                                "$value",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: textStyle(
                                                                    12.sp,
                                                                    FontWeight
                                                                        .bold,
                                                                    themeProvider.isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : const Color.fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    FontStyle
                                                                        .normal),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      ValueListenableBuilder(
                                                        valueListenable:
                                                            eventController
                                                                .systemID,
                                                        builder: (context,
                                                            value, child) {
                                                          return Text(
                                                            "$value",
                                                            style: textStyle(
                                                                12.sp,
                                                                FontWeight.bold,
                                                                themeProvider
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                FontStyle
                                                                    .normal),
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text("Status : ",
                                                              style: textStyle(
                                                                  12.sp,
                                                                  FontWeight
                                                                      .w600,
                                                                  themeProvider
                                                                          .isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                  FontStyle
                                                                      .normal)),
                                                          ValueListenableBuilder(
                                                              valueListenable:
                                                                  eventController
                                                                      .attendence,
                                                              builder: (context,
                                                                  value,
                                                                  child) {
                                                                return Text(
                                                                    "$value",
                                                                    style: textStyle(
                                                                        12.sp,
                                                                        FontWeight
                                                                            .bold,
                                                                        "$value" ==
                                                                                "Present"
                                                                            ? const Color.fromARGB(
                                                                                255,
                                                                                7,
                                                                                186,
                                                                                10)
                                                                            : Colors
                                                                                .red,
                                                                        FontStyle
                                                                            .normal));
                                                              })
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(),
                                                ),
                                              )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ValueListenableBuilder(
                                                  valueListenable: isDisable,
                                                  builder:
                                                      (context, value, child) {
                                                    return AbsorbPointer(
                                                      absorbing:
                                                          isDisable.value,
                                                      child: MaterialButton(
                                                        elevation: 4,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        color: Colors.blue,
                                                        onPressed: !finalDate
                                                                .contains(widget
                                                                    .events[
                                                                        'rounds']
                                                                        [index]
                                                                        ["date"]
                                                                    .toString())
                                                            ? null
                                                            : () {
                                                                isDisable
                                                                        .value =
                                                                    true;

                                                                onQRViewCreated();
                                                              },
                                                        child: !finalDate.contains(widget
                                                                .events['rounds'][index]
                                                                    ["date"]
                                                                .toString())
                                                            ? Text("",
                                                                style: textStyle(
                                                                    12.sp,
                                                                    FontWeight
                                                                        .bold,
                                                                    Colors
                                                                        .white,
                                                                    FontStyle
                                                                        .normal))
                                                            : Text("Mark Attendance",
                                                                style: textStyle(
                                                                    12.sp,
                                                                    FontWeight.bold,
                                                                    Colors.white,
                                                                    FontStyle.normal)),
                                                      ),
                                                    );
                                                  })
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Card(
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            color: Colors.transparent,
                                            child: Container(
                                              width: width * 0.95,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: themeProvider
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : const Color
                                                                  .fromARGB(255,
                                                              151, 194, 8)),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color:
                                                      themeProvider.isDarkMode
                                                          ? HexColor("#020E26")
                                                          : Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "Lab : ${widget.events['rounds'][index]["lab"]}",
                                                        style: textStyle(
                                                            12.sp,
                                                            FontWeight.w600,
                                                            themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontStyle.normal)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        "Test Type : ${widget.events['rounds'][index]["testType"]}",
                                                        style: textStyle(
                                                            12.sp,
                                                            FontWeight.w600,
                                                            themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontStyle.normal)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        "Round Date : ${widget.events['rounds'][index]["date"]}",
                                                        style: textStyle(
                                                            12.sp,
                                                            FontWeight.w600,
                                                            themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontStyle.normal))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const NoInternet();
      }),
    );
  }

  var scanResult;

  Future onQRViewCreated() async {
    EasyLoading.show();
    var getAppliedData = await getSingleEvents(eventID);

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      EasyLoading.dismiss();
    } on Exception catch (e) {
      isDisable.value = false;
      EasyLoading.dismiss();

      debugPrint(e.toString());
    }
    if (!mounted) return;
    isDisable.value = false;

    setState(() => scanResult = scanResult);
    if (scanResult.toString() == "-1" || scanResult == null) return;

    var getdata = aesEncryption.decryptMsg(aesEncryption.getCode(scanResult));
    Map data = jsonDecode(getdata);

    if (finalDate.toString().contains(data["Date"].toString())) {
      if (widget.events['rounds'][_currentIndex]["roundNumber"].toString() ==
          data["Round Number"]) {
        if (data["list"]
            .toString()
            .contains(eventController.email.value.toString())) {
          await takeAttendence();
        } else {
          showError("Details not found", "You were out of this event");
        }
      } else {
        showError("Invalid QR Code", "");
        return;
      }
    } else {
      showError("Invalid QR Code", "");
      return;
    }
  }

  takeAttendence() async {
    // controller?.stopCamera();
    EasyLoading.show();
    await applyForRound(token, eventID, roundID);
    await fetchEvents();
    await eventController.fetchUserData(getEvent);
    EasyLoading.dismiss();
  }

  fetchEvents() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
    eventDetail = await getStudentEvents(token);
    roundData = await getSingleRound(eventID, roundID);
    getEvent = roundData["present"];
    // log(getEvent.toString());
    eventController.fetchUserData(getEvent);
  }
}
