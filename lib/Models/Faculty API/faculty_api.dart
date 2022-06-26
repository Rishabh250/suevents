import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as https;
import 'package:suevents/Controller/providers/global_snackbar.dart';

createEvent(token, title, type, description, startDate, endDate, price) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/createEvent"),
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

    if (jsonDecode(response.body)['msg']
        .toString()
        .contains("Invalid Event Date")) {
      EasyLoading.dismiss();
      showError("Invalid Date", "Please Select future date");
      return false;
    } else {
      EasyLoading.dismiss();

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
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/facultyAssigned"),
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

createRound(token, lab, eventID, type, startDate, time, lastRound) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/createRound"),
        body: jsonEncode({
          "eventID": "$eventID",
          "lab": "$lab",
          "testType": "$type",
          "date": "$startDate",
          "time": "$time",
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
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/facultygetAllUser"),
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

getAssignedFaculty(eventID) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/singleEventFaculty"),
        body: jsonEncode({"eventID": "$eventID"}),
        headers: {
          "Content-Type": "application/json",
        });
    // log((response.body.toString()));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (e) {
    showError("Something went wrong", "Please try again");

    debugPrint(e.toString());
  }
}

getAssignedEvents(token) async {
  try {
    var response = await https.get(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/getAssignedEvents"),
        headers: {
          "Content-Type": "application/json",
          "x-access-token": "$token"
        });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (e) {
    showError("Something went wrong", "Please try again");

    debugPrint(e.toString());
  }
}

getSingleEvent(eventID) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/getEventRound"),
        body: jsonEncode({"eventID": "$eventID"}),
        headers: {
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (e) {
    // showError("Something went wrong", "Please try again");

    debugPrint(e.toString());
  }
}

getSelectedEvents(roundType) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/getSelectedEvents"),
        body: jsonEncode({"roundType": "$roundType"}),
        headers: {
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (e) {
    showError("Something went wrong", "Please try again");

    debugPrint(e.toString());
  }
}

getUnselectedStudents(roundType, eventList) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/getUnselectedStudents"),
        body: jsonEncode({"eventList": eventList, "roundType": "$roundType"}),
        headers: {
          "Content-Type": "application/json",
        });
    // log(response.body.toString());
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (e) {
    showError("Something went wrong", "Please try again");

    debugPrint(e.toString());
  }
}
