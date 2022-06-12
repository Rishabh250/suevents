import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as https;
import 'package:suevents/Controller/SharedPreferences/token.dart';

import '../../Controller/providers/global_snackbar.dart';
import '../../View/Autentication/change_password.dart';
import '../../View/Autentication/login.dart';
import '../../View/Student Portal/Navigation Bar/zoom_drawer.dart';

userLogin(email, pass) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents2022.herokuapp.com/loginUser"),
        body: jsonEncode(
            {"email": email.toString(), "password": pass.toString()}),
        headers: {"Content-Type": "application/json"});
    log(response.body.toString());

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      accessToken(jsonDecode(response.body)["token"]);
      EasyLoading.dismiss();
      loginStatus(true);
      getUser("Student");
      Get.off(const MainScreen(), transition: Transition.fadeIn);
    } else {
      if (body['msg'] == "Password wrong") {
        showError("Invaild Details", "You have entered wrong password");
      }
      if (body['msg'] == "user not found") {
        showError("Invaild Details", "User not found");
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

resetPassword(email, pass) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents2022.herokuapp.com/forgetPassword"),
        body: jsonEncode(
            {"email": email.toString(), "password": pass.toString()}),
        headers: {"Content-Type": "application/json"});

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Get.offAll(() => const LoginPage(),
          transition: Transition.fadeIn, arguments: {"isType": "Student"});
      showConfirm("Password Reset", "Your password has been reset");
      EasyLoading.dismiss();
    } else {
      if (body['msg'] == "user not found") {
        showError("Invaild Details", "User not found");
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

sendOTP(email) async {
  try {
    var response = await https.post(
        Uri.parse("https://suevents2022.herokuapp.com/sendOTP"),
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
        Uri.parse("https://suevents2022.herokuapp.com/verifyOTP"),
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

getUserData(token) async {
  try {
    var response = await https.get(
        Uri.parse("https://suevents2022.herokuapp.com/userInfo"),
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

uploadProfileImage(token, image) async {
  var headers = {
    "Content-Type": "application/json",
    "x-access-token": token.toString()
  };
  try {
    var response = await https.post(
        Uri.parse("https://suevents2022.herokuapp.com/uploadImage"),
        headers: headers,
        body: jsonEncode({"profileImage": image.toString()}));
    log(response.body.toString());
    if (response.statusCode == 200) {
      showConfirm(
          "Profile Updated", "Profile pic has been upload successfully");
    } else {
      showError("Something went wrong", "Please try again later");
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
