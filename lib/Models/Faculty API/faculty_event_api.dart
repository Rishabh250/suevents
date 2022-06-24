import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

closeEvent(eventID) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/closeEvent"),
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

closeRegistration(eventID) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/closeRegistration"),
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

openRegistration(eventID) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/openRegistration"),
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
