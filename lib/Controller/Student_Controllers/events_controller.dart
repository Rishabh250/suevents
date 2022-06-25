import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/Student API/authentication_api.dart';

class EventController {
  ValueNotifier<String> email = ValueNotifier<String>(""),
      systemID = ValueNotifier<String>("Fetching Details..."),
      name = ValueNotifier<String>(""),
      attendence = ValueNotifier("");

  fetchUserData(getEvent) async {
    await userData();
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
          attendence.value = "Present";
          EasyLoading.dismiss();
          return;
        } else {
          attendence.value = "Not Selected";
          EasyLoading.dismiss();
        }
      }
    }
    if (eventData.length == 0) {
      attendence.value = "Absent";
      EasyLoading.dismiss();
      return;
    }
  }
}

class UserDetailsController {
  ValueNotifier email = ValueNotifier<String>(""),
      systemID = ValueNotifier<String>(""),
      id = ValueNotifier<String>(""),
      name = ValueNotifier<String>(""),
      userImage = ValueNotifier<String>(""),
      course = ValueNotifier<String>(""),
      year = ValueNotifier<int>(0),
      semester = ValueNotifier<int>(0),
      gender = ValueNotifier<String>(""),
      events = ValueNotifier([]),
      allEvents = ValueNotifier([]);
  var user, token;

  fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
    user = await getUserData(token);
    id.value = user["user"]["_id"];
    name.value = user["user"]["name"];
    systemID.value = user["user"]["systemID"];
    email.value = user["user"]["email"];
    userImage.value = user["user"]["profileImage"];
    course.value = user["user"]["course"];
    year.value = int.parse(user["user"]["year"].toString());
    semester.value = int.parse(user["user"]["semester"].toString());
    gender.value = user["user"]["gender"];
    events.value = user["user"]["events"].length;
    allEvents.value = user["user"]["events"];
    return user;
  }
}
