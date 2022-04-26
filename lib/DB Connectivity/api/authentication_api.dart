import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as https;
import 'package:suevents/Screens/Autentication/change_password.dart';
import 'package:suevents/Screens/Autentication/login.dart';
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
      Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
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

sendOTP(email) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents.herokuapp.com/sendOTP"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.toString()}));
    if (response.statusCode == 200) {
      showConfirm("OTP Send", "OTP has been sent at $email");
      return true;
    } else {
      showError("Something went wrong", "Can't send OTP at $email");
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

verifyOTP(email, opt) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents.herokuapp.com/verifyOTP"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.toString(), "otp": int.parse(opt)}));
    if (response.statusCode == 200) {
      Get.to(() => const ChangePassword(),
          transition: Transition.fadeIn,
          arguments: [
            {"email": email}
          ]);
      return true;
    } else {
      showError("Invalid OTP", "Enter a vaild otp");
      return false;
    }
  } catch (e) {
    showError("Something went wrong", "Can't send OTP at $email");

    debugPrint(e.toString());
  }
}
