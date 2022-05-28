import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:suevents/Controller/providers/const.dart';

import '../../../Controller/providers/theme_service.dart';

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
                  content: Column(
                    children: const [],
                  ),
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
