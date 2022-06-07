// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as https;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suevents/Models/Faculty%20API/faculty_api.dart';
import 'package:suevents/Models/Faculty%20API/faculty_auth.dart';

class FacultyController {
  ValueNotifier email = ValueNotifier<String>(""),
      systemID = ValueNotifier<String>(""),
      name = ValueNotifier<String>(""),
      userImage = ValueNotifier<String>(""),
      gender = ValueNotifier<String>(""),
      events = ValueNotifier([]);
  var user, token, facultyList, assignedEvents;

  fetchFacultyData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
    user = await getFacultyData(token);
    name.value = user["user"]["name"];
    systemID.value = user["user"]["systemID"];
    email.value = user["user"]["email"];
    userImage.value = user["user"]["profileImage"];
    gender.value = user["user"]["gender"];
    events.value = user["user"]["eventsCreated"].length;
    return user;
  }

  fetchAllFacultyData() async {
    facultyList = await getAllFaculty();
    return facultyList;
  }

  getFacultyAssignedEvents() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("accessToken");
    assignedEvents = await getAssignedEvents(token);
    return assignedEvents;
  }
}

class GetFacultyList extends GetxController {
  List<FacultyModel> skillModel = [];
  List<MultiSelectItem> dropDownData02 = [];
  List<MultiSelectItem> dropDownData03 = [];
  getAllfaculty() async {
    skillModel.clear();
    dropDownData02.clear();
    var headers = {
      "Content-Type": "application/json",
    };

    var response = await https.get(
        Uri.parse("https://suevents2022.herokuapp.com/facultygetAllUser"),
        headers: headers);

    if (response.statusCode == 201 || response.statusCode == 200) {
      var result = jsonDecode(response.body)["user"];
      List<FacultyModel> tempList = [];
      result.forEach((data) {
        tempList.add(FacultyModel(name: data['name'], email: data['email']));
      });

      skillModel.addAll(tempList);

      dropDownData02 = skillModel.map((facultyData) {
        return MultiSelectItem(facultyData, facultyData.name);
      }).toList();

      update();

      EasyLoading.dismiss();
    } else {}
  }
}

class FacultyModel {
  FacultyModel({
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  factory FacultyModel.fromJson(Map<String, dynamic> json) => FacultyModel(
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
      };
}
