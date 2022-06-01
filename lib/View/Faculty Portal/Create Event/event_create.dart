// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/Faculty%20Controller/faculty_controller.dart';
import 'package:suevents/Controller/providers/const.dart';
import 'package:suevents/Models/Faculty%20API/faculty_api.dart';

import '../../../Controller/providers/theme_service.dart';

TextEditingController eventTitle = TextEditingController();
TextEditingController aboutEvent = TextEditingController();
TextEditingController lab = TextEditingController();
TextEditingController roundNumber = TextEditingController();
TextEditingController testType = TextEditingController();
bool islastRound = false;
// String finalDate = "", endDate = "", eventPrice = "";
bool isVisible = false;
ValueNotifier<bool> isLastRound = ValueNotifier<bool>(false);
ValueNotifier roundType = ValueNotifier("");
ValueNotifier roundDate = ValueNotifier("");
ValueNotifier eventType = ValueNotifier("");
ValueNotifier finalDate = ValueNotifier("");
ValueNotifier endDate = ValueNotifier("");
ValueNotifier eventPrice = ValueNotifier("");
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
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: const Color.fromARGB(255, 3, 13, 78),
        automaticallyImplyLeading: false,
        title: Text(
          'Create Event',
          style:
              textStyle(15.sp, FontWeight.bold, Colors.white, FontStyle.normal),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      _currentStep != 2
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: details.onStepContinue,
                              child: Text(
                                'Next',
                                style: textStyle(10.sp, FontWeight.bold,
                                    Colors.black, FontStyle.normal),
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () async {
                                EasyLoading.show();
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                var token =
                                    sharedPreferences.getString("accessToken");
                                if (isVisible == true) {
                                  eventPrice.value = "Free";
                                }

                                var event = await createEvent(
                                    token,
                                    eventTitle.text.toString(),
                                    eventType.value.toString(),
                                    aboutEvent.text.toString(),
                                    finalDate.value.toString(),
                                    endDate.value.toString(),
                                    eventPrice.value.toString());

                                var round = await createRound(
                                    token,
                                    lab.text.toString(),
                                    event["event"][0]["_id"].toString(),
                                    roundType.value.toString(),
                                    roundDate.value.toString(),
                                    isLastRound.value);
                                log("$round");
                                EasyLoading.dismiss();
                              },
                              child: Text(
                                'Finish',
                                style: textStyle(10.sp, FontWeight.bold,
                                    Colors.black, FontStyle.normal),
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
                  title: Text('Round Details',
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
                  content: AssignFaculty(themeProvider: themeProvider),
                  isActive: _currentStep >= 0,
                  state: StepState.disabled,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                12.sp, FontWeight.bold, Colors.white, FontStyle.normal),
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
            keyboardType: TextInputType.text,
            style: textStyle(
                10.sp, FontWeight.bold, Colors.white, FontStyle.normal),
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
                firstDate: DateTime(2022, 1, 1), // the earliest allowable
                lastDate: DateTime(2100, 12, 31),
                // the latest allowable
                initialDate: selectedDate,
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
            child: Text(
              picked == null
                  ? "Select Starting Date"
                  : "Starting Date : $finalDate",
              style: textStyle(
                  12.sp,
                  FontWeight.bold,
                  widget.themeProvider.isDarkMode ? Colors.white : Colors.black,
                  FontStyle.normal),
            ),
          ),
        ),
        ListTile(
          title: GestureDetector(
            onTap: () async {
              picked2 = await showDatePicker(
                context: context,
                firstDate: DateTime(2022, 1, 1), // the earliest allowable
                lastDate: DateTime(2100, 12, 31),
                // the latest allowable
                initialDate: selectedDate,
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
            child: Text(
              picked2 == null
                  ? "Select End Date (Optional)"
                  : "End Date : $endDate",
              style: textStyle(
                  12.sp,
                  FontWeight.bold,
                  widget.themeProvider.isDarkMode ? Colors.white : Colors.black,
                  FontStyle.normal),
            ),
          ),
        ),
        Visibility(
          visible: !isVisible,
          child: ListTile(
            title: TextField(
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
                12.sp, FontWeight.bold, Colors.white, FontStyle.normal),
            maxLines: 1,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: "Lab number & Block",
                hintStyle: textStyle(
                    12.sp, FontWeight.bold, Colors.grey, FontStyle.normal)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: Text(
            "Round Type",
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
                          gropuValue.value = int.parse(changeValue.toString());
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
                          gropuValue.value = int.parse(changeValue.toString());
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
                          gropuValue.value = int.parse(changeValue.toString());
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
                          gropuValue.value = int.parse(changeValue.toString());
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
                      12.sp, FontWeight.bold, Colors.white, FontStyle.normal),
                  maxLines: 1,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "Other",
                      hintStyle: textStyle(12.sp, FontWeight.bold, Colors.grey,
                          FontStyle.normal)),
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
                      firstDate: DateTime(2022, 1, 1), // the earliest allowable
                      lastDate: DateTime(2100, 12, 31),
                      // the latest allowable
                      initialDate: selectedDate,
                    );
                    if (picked != null && picked != selectedDate) {
                      selectedDate != picked;
                    }
                    if (picked != null) {
                      var currentDate =
                          picked.toString().replaceRange(11, 23, "").split("-");
                      roundDate.value =
                          "${currentDate[2]}${months[int.parse(currentDate[1]) - 1]}, ${currentDate[0]} ";
                      log(roundDate.value);
                    }
                  },
                  child: Text(
                    picked == null
                        ? "Select Starting Date"
                        : "Starting Date : ${roundDate.value}",
                    style: textStyle(
                        12.sp,
                        FontWeight.bold,
                        widget.themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        FontStyle.normal),
                  ),
                );
              }),
        ),
        ValueListenableBuilder(
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

  bool isSelected = false;
  var facultyData;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    facultyData = await facultyController.fetchAllFacultyData();
  }

  @override
  Widget build(BuildContext context) {
    return facultyData == null
        ? Container()
        : facultyController.facultyList["user"].length == 0
            ? const Text("Not Found")
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: facultyController.facultyList["user"].length,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                      valueListenable: facultyListData,
                      builder: (context, value, _) {
                        return ListTile(
                            onTap: () {
                              log(facultyController.facultyList["user"][index]
                                  ["_id"]);
                              if (!facultyListData.value.contains(
                                  facultyController.facultyList["user"][index]
                                      ["_id"])) {
                                facultyListData.value.add(facultyController
                                    .facultyList["user"][index]["_id"]);
                              } else {
                                facultyListData.value.remove(facultyController
                                    .facultyList["user"][index]["_id"]);
                              }
                              setState(() {});
                              log(facultyListData.value.toString());
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
                                      ["email"]
                                  .toString(),
                              style: textStyle(
                                  10.sp,
                                  FontWeight.bold,
                                  const Color.fromARGB(255, 92, 89, 89),
                                  FontStyle.normal),
                            ),
                            leading: facultyListData.value.contains(
                                    facultyController.facultyList["user"][index]
                                        ["_id"])
                                ? const Icon(Icons.radio_button_checked)
                                : const Icon(Icons.radio_button_unchecked));
                      });
                });
  }
}
