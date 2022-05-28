import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';

import '../../../Controller/providers/theme_service.dart';

TextEditingController eventTitle = TextEditingController();
TextEditingController aboutEvent = TextEditingController();
var eventType;
String finalDate = "", endDate = "", eventPrice = "";
bool isVisible = false;

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
                    children: <Widget>[
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
                              onPressed: () {
                                if (isVisible == true) {
                                  setState(() {
                                    eventPrice = "Free";
                                  });
                                }
                                log("${eventTitle.text}\n${aboutEvent.text}\n$eventType\n$finalDate\n$endDate\n$eventPrice");
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
                  content: const EventCreation(),
                  isActive: _currentStep >= 0,
                  state: StepState.disabled,
                ),
                Step(
                  title: Text('Add Round',
                      style: textStyle(
                          12.sp,
                          FontWeight.bold,
                          themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          FontStyle.normal)),
                  content: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Home Address'),
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Postcode'),
                      ),
                    ],
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
                  content: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Mobile Number'),
                      ),
                    ],
                  ),
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
  const EventCreation({
    Key? key,
  }) : super(key: key);

  @override
  State<EventCreation> createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreation> {
  int? gropuValue;

  DateTime selectedDate = DateTime.now();
  var picked, picked2;
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
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
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
                  themeProvider.isDarkMode ? Colors.white : Colors.black,
                  FontStyle.normal),
            ),
            subtitle: Column(
              children: [
                ListTile(
                  leading: Radio(
                      value: 0,
                      groupValue: gropuValue,
                      onChanged: (value) {
                        setState(() {
                          gropuValue = int.parse(value.toString());
                          eventType = "General Event";
                        });
                      }),
                  title: Text("General Event",
                      style: textStyle(
                          12.sp,
                          FontWeight.bold,
                          themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          FontStyle.normal)),
                ),
                ListTile(
                  leading: Radio(
                      value: 1,
                      groupValue: gropuValue,
                      onChanged: (value) {
                        setState(() {
                          gropuValue = int.parse(value.toString());
                          eventType = "Placement Event";
                        });
                      }),
                  title: Text("Placement Event",
                      style: textStyle(
                          12.sp,
                          FontWeight.bold,
                          themeProvider.isDarkMode
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
                finalDate =
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
                  themeProvider.isDarkMode ? Colors.white : Colors.black,
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
                endDate =
                    "${currentDate2[2]}${months[int.parse(currentDate2[1]) - 1]}, ${currentDate2[0]} ";
              }
            },
            child: Text(
              picked2 == null
                  ? "Select End Date (Optional)"
                  : "Starting Date : $endDate",
              style: textStyle(
                  12.sp,
                  FontWeight.bold,
                  themeProvider.isDarkMode ? Colors.white : Colors.black,
                  FontStyle.normal),
            ),
          ),
        ),
        Visibility(
          visible: !isVisible,
          child: ListTile(
            title: TextField(
              onChanged: ((value) {
                eventPrice = value;
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
                  themeProvider.isDarkMode ? Colors.white : Colors.black,
                  FontStyle.normal)),
        )
      ],
    );
  }
}
