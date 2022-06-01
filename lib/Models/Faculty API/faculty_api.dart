import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;

createEvent(token, title, type, description, startDate, endDate, price) async {
  log(token.toString());
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
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

createRound(token, lab, eventID, type, startDate, lastRound) async {
  log(eventID);
  log(lab);
  log(type);
  log(startDate);
  log(lastRound.toString());
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
    }
  } catch (e) {
    debugPrint(e.toString());
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
    debugPrint(e.toString());
  }
}
