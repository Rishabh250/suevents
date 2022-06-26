// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/Faculty%20Controller/faculty_controller.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Controller/providers/global_snackbar.dart';
import 'package:suevents/View/no_connection.dart';

import '../../../Controller/Internet Connection/connection_provider.dart';
import '../../../Controller/providers/theme_service.dart';
import '../../../Models/Faculty API/faculty_api.dart';
import 'event_created.dart';

TextEditingController eventTitle = TextEditingController();
TextEditingController aboutEvent = TextEditingController();
TextEditingController lab = TextEditingController();
TextEditingController roundNumber = TextEditingController();
TextEditingController testType = TextEditingController();
ValueNotifier<bool> isLastRound = ValueNotifier<bool>(false);
ValueNotifier roundType = ValueNotifier("");
ValueNotifier roundDate = ValueNotifier("");
ValueNotifier eventType = ValueNotifier("");
ValueNotifier finalDate = ValueNotifier("");
ValueNotifier endDate = ValueNotifier("");
ValueNotifier eventPrice = ValueNotifier("");
ValueNotifier roundTime = ValueNotifier("");

bool isVisible = false;
var title, about, timePick, timePicked;

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

ValueNotifier facultyListData = ValueNotifier([]);
ValueNotifier selectedFaculty = ValueNotifier([]);

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  CreateEventState createState() => CreateEventState();
}

class CreateEventState extends State<CreateEvent> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMontering();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Consumer<ConnectivityProvider>(
        builder: (context, value, child) => value.isOnline
            ? Scaffold(
                appBar: AppBar(
                  leading: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
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
                    'Create Event',
                    style: textStyle(
                        15.sp, FontWeight.bold, Colors.white, FontStyle.normal),
                  ),
                ),
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Stepper(
                          controlsBuilder: (context, details) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                children: [
                                  _currentStep != 2
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 4,
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          onPressed: details.onStepContinue,
                                          child: Text(
                                            'Next',
                                            style: textStyle(
                                                10.sp,
                                                FontWeight.bold,
                                                Colors.black,
                                                FontStyle.normal),
                                          ),
                                        )
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 4,
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          onPressed: () async {
                                            SharedPreferences
                                                sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            var token = sharedPreferences
                                                .getString("accessToken");
                                            if (isVisible == true) {
                                              eventPrice.value = "Free";
                                            }

                                            if (eventTitle.text.isEmpty) {
                                              showError("Empty Field",
                                                  "Add Event Title");
                                              return;
                                            }
                                            if (eventType.value == "") {
                                              showError("Empty Field",
                                                  "Select Event Type");
                                              return;
                                            }
                                            if (aboutEvent.text.isEmpty) {
                                              showError("Empty Field",
                                                  "Add some points about event");
                                              return;
                                            }
                                            if (finalDate.value.isEmpty) {
                                              showError("Empty Field",
                                                  "Select Event starting date");
                                              return;
                                            }
                                            if (endDate.value.isEmpty) {
                                              showError("Empty Field",
                                                  "Select Registration close date");
                                              return;
                                            }
                                            if (eventPrice.value.isEmpty) {
                                              showError("Empty Field",
                                                  "Event Price can't e empty");
                                              return;
                                            }
                                            if (facultyListData.value.isEmpty) {
                                              showError("Empty Field",
                                                  "Assign atleast one faculty");
                                              return;
                                            }
                                            if (lab.text.isEmpty) {
                                              showError("Empty Field",
                                                  "Add Lab Details");
                                              return;
                                            }
                                            if (roundType.value.isEmpty) {
                                              showError("Empty Field",
                                                  "Select Round Type");
                                              return;
                                            }
                                            if (roundDate.value.isEmpty) {
                                              showError("Empty Field",
                                                  "Select Round Date");
                                              return;
                                            }
                                            if (roundTime.value.isEmpty) {
                                              showError("Empty Field",
                                                  "Select Round Time");
                                              return;
                                            }

                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        themeProvider.isDarkMode
                                                            ? HexColor(
                                                                "#010A1C")
                                                            : Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    title: Text("Create Event",
                                                        style: textStyle(
                                                            15.sp,
                                                            FontWeight.bold,
                                                            themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontStyle.normal)),
                                                    content: Text(
                                                        "Note : Once an event is created, you will be able to undo it.",
                                                        style: textStyle(
                                                            12.sp,
                                                            FontWeight.w600,
                                                            themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontStyle.normal)),
                                                    elevation: 8,
                                                    actions: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          MaterialButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            elevation: 8,
                                                            onPressed:
                                                                () async {
                                                              Get.back();
                                                            },
                                                            child: Center(
                                                                child: Text(
                                                                    "Edit",
                                                                    style: textStyle(
                                                                        12.sp,
                                                                        FontWeight
                                                                            .bold,
                                                                        themeProvider.isDarkMode
                                                                            ? Colors
                                                                                .white
                                                                            : Colors
                                                                                .black,
                                                                        FontStyle
                                                                            .normal))),
                                                          ),
                                                          MaterialButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            elevation: 8,
                                                            onPressed:
                                                                () async {
                                                              EasyLoading.show(
                                                                  dismissOnTap:
                                                                      false);

                                                              if (eventType
                                                                  .value
                                                                  .toString()
                                                                  .contains(
                                                                      "General")) {
                                                                isLastRound
                                                                        .value =
                                                                    true;
                                                              }

                                                              title = eventTitle
                                                                  .text
                                                                  .toString();
                                                              about = aboutEvent
                                                                  .text
                                                                  .toString();

                                                              var event = await createEvent(
                                                                  token,
                                                                  eventTitle
                                                                      .text
                                                                      .toString(),
                                                                  eventType
                                                                      .value
                                                                      .toString(),
                                                                  aboutEvent
                                                                      .text
                                                                      .toString(),
                                                                  finalDate
                                                                      .value
                                                                      .toString(),
                                                                  endDate.value
                                                                      .toString(),
                                                                  eventPrice
                                                                      .value
                                                                      .toString());

                                                              if (event ==
                                                                  false) return;

                                                              await assignFaculty(
                                                                  event["event"]
                                                                              [
                                                                              0]
                                                                          [
                                                                          "_id"]
                                                                      .toString(),
                                                                  facultyListData
                                                                      .value);
                                                              var list =
                                                                  facultyListData
                                                                      .value
                                                                      .clear();

                                                              await createRound(
                                                                  token,
                                                                  lab.text
                                                                      .toString(),
                                                                  event["event"]
                                                                              [
                                                                              0]
                                                                          [
                                                                          "_id"]
                                                                      .toString(),
                                                                  roundType
                                                                      .value
                                                                      .toString(),
                                                                  roundDate
                                                                      .value
                                                                      .toString(),
                                                                  roundTime
                                                                      .value
                                                                      .toString(),
                                                                  isLastRound
                                                                      .value);

                                                              EasyLoading
                                                                  .dismiss();

                                                              eventTitle
                                                                  .clear();
                                                              aboutEvent
                                                                  .clear();
                                                              lab.clear();
                                                              roundNumber
                                                                  .clear();
                                                              testType.clear();

                                                              eventTitle
                                                                  .clear();
                                                              aboutEvent
                                                                  .clear();
                                                              lab.clear();
                                                              roundNumber
                                                                  .clear();
                                                              testType.clear();
                                                              facultyListData
                                                                  .value
                                                                  .clear();
                                                              setState(() {
                                                                isVisible =
                                                                    false;
                                                              });
                                                              isLastRound
                                                                      .value =
                                                                  false;

                                                              Get.offAll(
                                                                  () =>
                                                                      const CreateEventConfirm(),
                                                                  arguments: {
                                                                    "title": title
                                                                        .toString(),
                                                                    "date": finalDate
                                                                        .value
                                                                        .toString(),
                                                                    "type": eventType
                                                                        .value
                                                                        .toString(),
                                                                    "about": about
                                                                        .toString(),
                                                                  });
                                                            },
                                                            child: Center(
                                                              child: Text(
                                                                  "Create",
                                                                  style: textStyle(
                                                                      12.sp,
                                                                      FontWeight
                                                                          .bold,
                                                                      const Color
                                                                              .fromARGB(
                                                                          212,
                                                                          27,
                                                                          124,
                                                                          2),
                                                                      FontStyle
                                                                          .normal)),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Text(
                                            'Finish',
                                            style: textStyle(
                                                10.sp,
                                                FontWeight.bold,
                                                Colors.black,
                                                FontStyle.normal),
                                          ),
                                        ),
                                  if (_currentStep != 0)
                                    TextButton(
                                      onPressed: details.onStepCancel,
                                      child: Text(
                                        'Back',
                                        style: textStyle(
                                            10.sp,
                                            FontWeight.bold,
                                            themeProvider.isDarkMode
                                                ? Colors.white
                                                : Colors.black.withOpacity(0.3),
                                            FontStyle.normal),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                          type: stepperType,
                          physics: const BouncingScrollPhysics(),
                          currentStep: _currentStep,
                          onStepTapped: (step) => tapped(step),
                          onStepContinue: continued,
                          elevation: 4,
                          onStepCancel: cancel,
                          steps: <Step>[
                            Step(
                              title: Text('Create Event',
                                  style: textStyle(
                                      12.sp,
                                      FontWeight.bold,
                                      themeProvider.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      FontStyle.normal)),
                              content: EventCreation(
                                themeProvider: themeProvider,
                              ),
                              isActive: _currentStep >= 0,
                              state: StepState.disabled,
                            ),
                            Step(
                              title:
                                  eventType.value.toString().contains("General")
                                      ? Text('Session Details',
                                          style: textStyle(
                                              12.sp,
                                              FontWeight.bold,
                                              themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontStyle.normal))
                                      : Text('Round Details',
                                          style: textStyle(
                                              12.sp,
                                              FontWeight.bold,
                                              themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontStyle.normal)),
                              content: RoundDetails(
                                themeProvider: themeProvider,
                              ),
                              isActive: _currentStep >= 0,
                              state: StepState.disabled,
                            ),
                            Step(
                              title: Text('Assign Faculty',
                                  style: textStyle(
                                      12.sp,
                                      FontWeight.bold,
                                      themeProvider.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      FontStyle.normal)),
                              content:
                                  AssignFaculty(themeProvider: themeProvider),
                              isActive: _currentStep >= 0,
                              state: StepState.disabled,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            : const NoInternet());
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}

class EventCreation extends StatefulWidget {
  final themeProvider;
  const EventCreation({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);

  @override
  State<EventCreation> createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreation> {
  var picked, picked2;
  ValueNotifier gropuValue = ValueNotifier(0);
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: TextField(
            controller: eventTitle,
            autocorrect: true,
            enableSuggestions: true,
            keyboardType: TextInputType.text,
            style: textStyle(
                12.sp,
                FontWeight.bold,
                widget.themeProvider.isDarkMode ? Colors.white : Colors.black,
                FontStyle.normal),
            maxLines: 1,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: "Event Title",
                hintStyle: textStyle(
                    12.sp, FontWeight.bold, Colors.grey, FontStyle.normal)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
            title: Text(
              "Event Type",
              style: textStyle(
                  12.sp,
                  FontWeight.bold,
                  widget.themeProvider.isDarkMode ? Colors.white : Colors.black,
                  FontStyle.normal),
            ),
            subtitle: Column(
              children: [
                ListTile(
                  leading: ValueListenableBuilder(
                    builder: ((context, value, child) {
                      return Radio(
                          value: 1,
                          groupValue: value,
                          onChanged: (changeValue) {
                            gropuValue.value =
                                int.parse(changeValue.toString());
                            eventType.value = "General Event";
                          });
                    }),
                    valueListenable: gropuValue,
                  ),
                  title: Text("General Event",
                      style: textStyle(
                          12.sp,
                          FontWeight.bold,
                          widget.themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          FontStyle.normal)),
                ),
                ListTile(
                  leading: ValueListenableBuilder(
                    builder: ((context, value, child) {
                      return Radio(
                          value: 2,
                          groupValue: value,
                          onChanged: (changeValue) {
                            gropuValue.value =
                                int.parse(changeValue.toString());
                            eventType.value = "Placement Event";
                            setState(() {});
                          });
                    }),
                    valueListenable: gropuValue,
                  ),
                  title: Text("Placement Event",
                      style: textStyle(
                          12.sp,
                          FontWeight.bold,
                          widget.themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          FontStyle.normal)),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )),
        ListTile(
          title: TextField(
            controller: aboutEvent,

            autocorrect: true,
            maxLength: 1000,
            enableSuggestions: true,
            // keyboardType: TextInputType.text,
            style: textStyle(
                10.sp,
                FontWeight.bold,
                widget.themeProvider.isDarkMode ? Colors.white : Colors.black,
                FontStyle.normal),
            maxLines: 8,
            decoration: InputDecoration(
                hintText: "About Event",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintStyle: textStyle(
                    12.sp, FontWeight.bold, Colors.grey, FontStyle.normal)),
          ),
        ),
        ListTile(
          title: GestureDetector(
              onTap: () async {
                picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate != picked;
                  });
                }
                if (picked != null) {
                  var currentDate =
                      picked.toString().replaceRange(11, 23, "").split("-");
                  finalDate.value =
                      "${currentDate[2]}${months[int.parse(currentDate[1]) - 1]}, ${currentDate[0]} ";
                }
              },
              child: Row(children: [
                const Icon(Icons.calendar_month_rounded),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  picked == null
                      ? "Select Starting Date"
                      : "${finalDate.value}",
                  style: textStyle(
                      12.sp,
                      FontWeight.bold,
                      widget.themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      FontStyle.normal),
                ),
              ])),
        ),
        ListTile(
          title: GestureDetector(
              onTap: () async {
                picked2 = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime(2101),
                );
                if (picked2 != null && picked2 != selectedDate) {
                  setState(() {
                    selectedDate != picked2;
                  });
                }
                if (picked2 != null) {
                  var currentDate2 =
                      picked2.toString().replaceRange(11, 23, "").split("-");
                  endDate.value =
                      "${currentDate2[2]}${months[int.parse(currentDate2[1]) - 1]}, ${currentDate2[0]} ";
                }
              },
              child: Row(children: [
                const Icon(Icons.calendar_month_rounded),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  picked2 == null
                      ? "Registration Close date"
                      : "Close : ${endDate.value}",
                  style: textStyle(
                      12.sp,
                      FontWeight.bold,
                      widget.themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      FontStyle.normal),
                ),
              ])),
        ),
        Visibility(
          visible: !isVisible,
          child: ListTile(
            title: TextField(
              enabled: false,
              onChanged: ((value) {
                eventPrice.value = value;
              }),
              autocorrect: true,
              enableSuggestions: true,
              keyboardType: TextInputType.number,
              style: textStyle(
                  12.sp, FontWeight.bold, Colors.white, FontStyle.normal),
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: "Event Price",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintStyle: textStyle(
                      12.sp, FontWeight.bold, Colors.grey, FontStyle.normal)),
            ),
          ),
        ),
        ListTile(
          leading: Checkbox(
            shape: const CircleBorder(),
            checkColor: Colors.amber,
            onChanged: (value) {
              setState(() {
                isVisible = !isVisible;
              });
            },
            value: isVisible,
            activeColor: Colors.amber,
          ),
          title: Text("Free Event",
              style: textStyle(
                  12.sp,
                  FontWeight.bold,
                  widget.themeProvider.isDarkMode ? Colors.white : Colors.black,
                  FontStyle.normal)),
        )
      ],
    );
  }
}

class RoundDetails extends StatefulWidget {
  final themeProvider;

  const RoundDetails({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);

  @override
  State<RoundDetails> createState() => _RoundDetailsState();
}

class _RoundDetailsState extends State<RoundDetails> {
  ValueNotifier<int> gropuValue = ValueNotifier(0);
  DateTime selectedDate = DateTime.now();
  DateTime? picked;
  TimeOfDay selectTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: TextField(
            controller: lab,
            autocorrect: true,
            enableSuggestions: true,
            keyboardType: TextInputType.text,
            style: textStyle(
                12.sp,
                FontWeight.bold,
                widget.themeProvider.isDarkMode ? Colors.white : Colors.black,
                FontStyle.normal),
            maxLines: 1,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: eventType.value.toString().contains("General")
                    ? "Venue"
                    : "Lab number & Block",
                hintStyle: textStyle(
                    12.sp, FontWeight.bold, Colors.grey, FontStyle.normal)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: Text(
            eventType.value.toString().contains("General")
                ? "Session Type"
                : "Round Type",
            style: textStyle(
                12.sp,
                FontWeight.bold,
                widget.themeProvider.isDarkMode ? Colors.white : Colors.black,
                FontStyle.normal),
          ),
          subtitle: eventType.value.toString().contains("General")
              ? ListTile(
                  leading: ValueListenableBuilder(
                    builder: ((context, value, child) {
                      return Radio(
                          value: gropuValue.value,
                          groupValue: value,
                          onChanged: (changeValue) {
                            gropuValue.value =
                                int.parse(changeValue.toString());
                          });
                    }),
                    valueListenable: gropuValue,
                  ),
                  title: TextField(
                    onChanged: ((roundValue) {
                      roundType.value = roundValue;
                    }),
                    autocorrect: true,
                    enableSuggestions: true,
                    keyboardType: TextInputType.text,
                    style: textStyle(
                        12.sp,
                        FontWeight.bold,
                        widget.themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        FontStyle.normal),
                    maxLines: 1,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintStyle: textStyle(12.sp, FontWeight.bold,
                            Colors.grey, FontStyle.normal)),
                  ),
                )
              : Column(
                  children: [
                    ListTile(
                      leading: ValueListenableBuilder(
                        builder: ((context, value, child) {
                          return Radio(
                              value: 1,
                              groupValue: value,
                              onChanged: (changeValue) {
                                gropuValue.value =
                                    int.parse(changeValue.toString());
                                roundType.value = "Aptitude Test";
                              });
                        }),
                        valueListenable: gropuValue,
                      ),
                      title: Text("Aptitude Test",
                          style: textStyle(
                              12.sp,
                              FontWeight.bold,
                              widget.themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              FontStyle.normal)),
                    ),
                    ListTile(
                      leading: ValueListenableBuilder(
                        builder: ((context, value, child) {
                          return Radio(
                              value: 2,
                              groupValue: value,
                              onChanged: (changeValue) {
                                gropuValue.value =
                                    int.parse(changeValue.toString());
                                roundType.value = "Technical Round";
                              });
                        }),
                        valueListenable: gropuValue,
                      ),
                      title: Text("Technical Round",
                          style: textStyle(
                              12.sp,
                              FontWeight.bold,
                              widget.themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              FontStyle.normal)),
                    ),
                    ListTile(
                      leading: ValueListenableBuilder(
                        builder: ((context, value, child) {
                          return Radio(
                              value: 3,
                              groupValue: value,
                              onChanged: (changeValue) {
                                gropuValue.value =
                                    int.parse(changeValue.toString());
                                roundType.value = "HR";
                              });
                        }),
                        valueListenable: gropuValue,
                      ),
                      title: Text("HR",
                          style: textStyle(
                              12.sp,
                              FontWeight.bold,
                              widget.themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              FontStyle.normal)),
                    ),
                    ListTile(
                      leading: ValueListenableBuilder(
                        builder: ((context, value, child) {
                          return Radio(
                              value: 4,
                              groupValue: value,
                              onChanged: (changeValue) {
                                gropuValue.value =
                                    int.parse(changeValue.toString());
                              });
                        }),
                        valueListenable: gropuValue,
                      ),
                      title: TextField(
                        onChanged: ((roundValue) {
                          roundType.value = roundValue;
                        }),
                        autocorrect: true,
                        enableSuggestions: true,
                        keyboardType: TextInputType.text,
                        style: textStyle(
                            12.sp,
                            FontWeight.bold,
                            widget.themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            FontStyle.normal),
                        maxLines: 1,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: "Other",
                            hintStyle: textStyle(12.sp, FontWeight.bold,
                                Colors.grey, FontStyle.normal)),
                      ),
                    ),
                  ],
                ),
        ),
        ListTile(
          title: ValueListenableBuilder(
              valueListenable: roundDate,
              builder: (context, value, child) {
                return GestureDetector(
                  onTap: () async {
                    picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != selectedDate) {
                      selectedDate != picked;
                    }
                    if (picked != null) {
                      var currentDate =
                          picked.toString().replaceRange(11, 23, "").split("-");
                      roundDate.value =
                          "${currentDate[2]}${months[int.parse(currentDate[1]) - 1]}, ${currentDate[0]}";
                      log(roundDate.value);
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        picked == null
                            ? "Select Starting Date"
                            : "${roundDate.value}",
                        style: textStyle(
                            12.sp,
                            FontWeight.bold,
                            widget.themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            FontStyle.normal),
                      ),
                    ],
                  ),
                );
              }),
        ),
        ListTile(
          title: ValueListenableBuilder(
              valueListenable: roundTime,
              builder: (context, value, child) {
                return GestureDetector(
                  onTap: () async {
                    timePick = await showTimePicker(
                      context: context,
                      initialTime: selectTime,
                    );
                    if (timePick != null && picked != selectedDate) {
                      selectedDate != picked;
                    }
                    if (timePick != null) {
                      roundTime.value = timePick.format(context);
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        timePick == null ? "Select Time" : "${roundTime.value}",
                        style: textStyle(
                            12.sp,
                            FontWeight.bold,
                            widget.themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            FontStyle.normal),
                      ),
                    ],
                  ),
                );
              }),
        ),
        eventType.value.toString().contains("General")
            ? Container()
            : ValueListenableBuilder(
                valueListenable: isLastRound,
                builder: (context, value, child) {
                  return ListTile(
                    leading: Checkbox(
                      shape: const CircleBorder(),
                      checkColor: Colors.amber,
                      onChanged: (value) {
                        isLastRound.value = !isLastRound.value;
                      },
                      value: isLastRound.value,
                      activeColor: Colors.amber,
                    ),
                    title: Text("Final Round",
                        style: textStyle(
                            12.sp,
                            FontWeight.bold,
                            widget.themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            FontStyle.normal)),
                  );
                })
      ],
    );
  }
}

class AssignFaculty extends StatefulWidget {
  final themeProvider;
  const AssignFaculty({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);

  @override
  State<AssignFaculty> createState() => _AssignFacultyState();
}

class _AssignFacultyState extends State<AssignFaculty> {
  FacultyController facultyController = FacultyController();
  String searchByID = "";

  bool isSelected = false;
  var facultyData, searchList, facultyList;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    facultyData = await facultyController.fetchAllFacultyData();
    await filterList(searchByID);
  }

  filterList(value) {
    facultyList = facultyController.facultyList["user"];
    if (searchByID == "") {
      searchList = facultyList;
      return searchList;
    } else {
      log(value.toString());
      searchList = facultyList.where((user) {
        return user["systemID"].toString().contains(value.toString());
      }).toList();
      setState(() {});
      return searchList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return facultyData == null
        ? Container()
        : facultyController.facultyList["user"].length == 0
            ? const Text("Not Found")
            : Column(
                children: [
                  TextField(
                    autocorrect: true,
                    onChanged: (value) async {
                      searchByID = value;
                      log(searchByID.toString());
                      await filterList(searchByID);
                    },
                    enableSuggestions: true,
                    keyboardType: TextInputType.number,
                    style: textStyle(
                        12.sp,
                        FontWeight.bold,
                        widget.themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        FontStyle.normal),
                    maxLines: 1,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Search by Employee ID",
                        hintStyle: textStyle(12.sp, FontWeight.bold,
                            Colors.grey, FontStyle.normal)),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchList.length,
                      itemBuilder: (context, index) {
                        return ValueListenableBuilder(
                            valueListenable: facultyListData,
                            builder: (context, value, _) {
                              return ListTile(
                                  onTap: () {
                                    if (!facultyListData.value.contains(
                                        facultyController.facultyList["user"]
                                            [index]["_id"])) {
                                      facultyListData.value.add(
                                          facultyController.facultyList["user"]
                                              [index]["_id"]);
                                    } else {
                                      facultyListData.value.remove(
                                          facultyController.facultyList["user"]
                                              [index]["_id"]);
                                    }
                                    setState(() {});
                                  },
                                  title: Text(
                                    facultyController.facultyList["user"][index]
                                            ["name"]
                                        .toString(),
                                    style: textStyle(
                                        12.sp,
                                        FontWeight.bold,
                                        widget.themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        FontStyle.normal),
                                  ),
                                  subtitle: Text(
                                    facultyController.facultyList["user"][index]
                                            ["systemID"]
                                        .toString(),
                                    style: textStyle(
                                        10.sp,
                                        FontWeight.bold,
                                        const Color.fromARGB(255, 92, 89, 89),
                                        FontStyle.normal),
                                  ),
                                  leading: facultyListData.value.contains(
                                          facultyController.facultyList["user"]
                                              [index]["_id"])
                                      ? const Icon(Icons.radio_button_checked)
                                      : const Icon(
                                          Icons.radio_button_unchecked));
                            });
                      }),
                ],
              );
  }
}
