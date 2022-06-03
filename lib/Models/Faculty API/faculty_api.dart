import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:suevents/Controller/providers/global_snackbar.dart';

createEvent(token, title, type, description, startDate, endDate, price) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents2022.herokuapp.com/createEvent"),
        body: jsonEncode({
          "title": "$title",
          "type": "$type",
          "status": "open",
          "description": "$description",
          "startDate": "$startDate",
          "endDate": "$endDate",
          "eventPrice": "$price"
        }),
        headers: {
          "Content-Type": "application/json",
          "x-access-token": token.toString()
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return false;
    }
  } catch (e) {
    showError("Something went wrong", "Please try again");
    debugPrint(e.toString());
    return false;
  }
}

assignFaculty(eventID, facultyList) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents2022.herokuapp.com/facultyAssigned"),
        body: jsonEncode({"eventID": eventID, "facultyID": facultyList}),
        headers: {"Content-Type": "application/json"});
    facultyList.clear();
    log(response.body.toString());
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showError("Something went wrong", "Please try again");
      return false;
    }
  } catch (e) {
    showError("Something went wrong", "Please try again");
    debugPrint(e.toString());
    return false;
  }
}

createRound(token, lab, eventID, type, startDate, lastRound) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents2022.herokuapp.com/createRound"),
        body: jsonEncode({
          "eventID": "$eventID",
          "lab": "$lab",
          "testType": "$type",
          "date": "$startDate",
          "lastRound": lastRound
        }),
        headers: {
          "Content-Type": "application/json",
          "x-access-token": token.toString()
        });
    log((response.body.toString()));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showError("Something went wrong", "Please try again");

      return false;
    }
  } catch (e) {
    showError("Something went wrong", "Please try again");
    debugPrint(e.toString());
    return false;
  }
}

getAllFaculty() async {
  try {
    var response = await https.get(
        Uri.parse("https://suevents2022.herokuapp.com/facultygetAllUser"),
        headers: {
          "Content-Type": "application/json",
        });
    log((response.body.toString()));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (e) {
    showError("Something went wrong", "Please try again");

    debugPrint(e.toString());
  }
}
