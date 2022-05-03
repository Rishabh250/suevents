import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:suevents/providers/global_snackbar.dart';

getAllEvents() async {
  try {
    var response = await https.get(
        Uri.parse("https://suevents.herokuapp.com/getAllEvents"),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

applyEvent(token, eventID, event) async {
  try {
    var headers = {
      "Content-Type": "application/json",
      "x-access-token": token.toString()
    };

    var response = await https.post(
        Uri.parse("https://suevents.herokuapp.com/applyEvent"),
        body: jsonEncode({"eventID": eventID}),
        headers: headers);

    log(response.body.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      showConfirm("Applied", "You have applied for $event");
    } else if (jsonDecode(response.body)["msg"] == "Already Registered") {
      showError("Already Registered", "Can't register multiple times");
    } else {
      showError("Something went wrong", "Please try again later");
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
