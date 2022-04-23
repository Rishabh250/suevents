import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as https;
import 'package:suevents/SharedPreferences/token.dart';
import 'package:suevents/providers/global_snackbar.dart';

userLogin(email, pass) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents.herokuapp.com/loginUser"),
        body: jsonEncode(
            {"email": email.toString(), "password": pass.toString()}),
        headers: {"Content-Type": "application/json"});

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      accessToken(jsonDecode(response.body)["token"]);
      EasyLoading.dismiss();
    } else {
      if (body['msg'] == "Password wrong") {
        showError("Invaild Details", "You have entered wrong password");
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

resetPassword(email, pass) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents.herokuapp.com/forgetPassword"),
        body: jsonEncode(
            {"email": email.toString(), "password": pass.toString()}),
        headers: {"Content-Type": "application/json"});

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      showConfirm("Password Reset", "Your password has been reset");
      EasyLoading.dismiss();
    } else {
      if (body['msg'] == "user not found") {
        showError("Invaild Details", "user not found");
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
