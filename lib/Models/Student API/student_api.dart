import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;

getStudentEvents(token) async {
  log(token.toString());
  try {
    var response = await https.get(
        Uri.parse("https://suevents2022.herokuapp.com/studentEvents"),
        headers: {"Content-Type": "application/json", "x-access-token": token});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

getSingleEvents(eventID) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents2022.herokuapp.com/singleEvent"),
        body: jsonEncode({"eventID": "$eventID"}),
        headers: {
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      log(jsonDecode(response.body)["events"]["appliedStudents"].toString());
      return jsonDecode(response.body);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

getSingleRound(eventID, roundID) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents2022.herokuapp.com/getSingleRound"),
        body: jsonEncode({"eventID": "$eventID", "roundID": "$roundID"}),
        headers: {
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      // log(jsonDecode(response.body).toString());
      return jsonDecode(response.body);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

applyForRound(token, eventID, roundID) async {
  log(eventID.toString());
  log(roundID.toString());
  try {
    var response = await https.post(
        Uri.parse("https://suevents2022.herokuapp.com/selectedStudents"),
        body: jsonEncode({"eventID": "$eventID", "roundID": "$roundID"}),
        headers: {
          "Content-Type": "application/json",
          "x-access-token": token.toString()
        });

    if (response.statusCode == 200) {
      log(jsonDecode(response.body).toString());
    } else {
      log(jsonDecode(response.body).toString());
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
