import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

closeEvent(eventID) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents2022.herokuapp.com/closeEvent"),
        body: jsonEncode({"eventID": "$eventID"}),
        headers: {
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
