import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/Student API/authentication_api.dart';

class EventController {
  ValueNotifier<String> email = ValueNotifier<String>(""),
      systemID = ValueNotifier<String>("Fetching Details..."),
      name = ValueNotifier<String>(""),
      attendence = ValueNotifier("");

  fetchUserData(getEvent) async {
    await userData();
    log(email.value.toString());
    await checkAttendence(getEvent, email.value);
  }

  userData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("accessToken");
    var user = await getUserData(token);
    email.value = user["user"]["email"];
    systemID.value = user["user"]["systemID"];
    name.value = user["user"]["name"];
  }

  checkAttendence(eventData, email) {
    if (eventData.length > 0) {
      for (int i = 0; i < eventData.length; i++) {
        if (eventData[i]["email"].toString().contains(email)) {
          log(eventData.toString());
          attendence.value = "Present";
        }
      }
    }
    if (eventData.length == 0) {
      attendence.value = "Not Taken";
    }
  }
}
