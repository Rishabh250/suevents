import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;

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
