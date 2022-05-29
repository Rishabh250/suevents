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

createRound(
    token, lab, eventID, roundNumber, type, startDate, lastRound) async {
  log(eventID);
  log(lab);
  log(type);
  log(roundNumber.toString());
  log(startDate);
  log(lastRound.toString());
  try {
    var response = await https.post(
        Uri.parse("https://suevents2022.herokuapp.com/createRound"),
        body: jsonEncode({
          "eventID": "$eventID",
          "roundNumber": roundNumber,
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
// createRound(
//     token, lab, eventID, roundNumber, type, startDate, lastRound) async {
//   try {
//     var response = await https
//         .post(Uri.parse("https://suevents2022.herokuapp.com/createRound"),
//             body: jsonEncode({
//               "eventID": "$eventID",
//               "roundNumber": roundNumber,
//               "lab": "$lab",
//               "testType": "$type",
//               "date": "$startDate",
//               "lastRound": lastRound.toString()
//             }),
//             headers: {"x-access-token": token.toString()});
//     log(jsonDecode(response.body));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     }
//   } catch (e) {
//     debugPrint(e.toString());
//   }
// }
