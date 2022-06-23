import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as https;
import 'package:suevents/Controller/SharedPreferences/token.dart';
import 'package:suevents/View/Faculty%20Portal/Navigation%20Bar/navigation_bar.dart';

import '../../Controller/providers/global_snackbar.dart';
import '../../View/Autentication/login.dart';
import '../../View/Autentication/verify_email.dart';

facultyLogin(email, pass) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/facultyloginUser"),
        body: jsonEncode({"email": email.toString(), "password": pass.toString()}),
        headers: {"Content-Type": "application/json"});
    log(response.body.toString());

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (body['verified'] == true) {
        accessToken(jsonDecode(response.body)["token"]);
        loginStatus(true);
        getUser("Faculty");
        Get.off(const FacultyNavigationBarPage(),
            transition: Transition.fadeIn);
      } else {
        await facultysendOTP(email);
        EasyLoading.dismiss();

        Get.to(() => const EmailVerify(),
            arguments: {"isType": "Faculty", "email": email},
            transition: Transition.fadeIn);
      }
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

createFaculty(email, pass, name, sysID, gender) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/createFaculty"),
        body: jsonEncode({
          "email": email.toString(),
          "password": pass.toString(),
          "name": name.toString(),
          "systemID": sysID.toString(),
          "gender": gender.toString(),
          "type": "Faculty"
        }),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.dismiss();

      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

facultyResetPassword(email, pass) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/facultyforgetPassword"),
        body: jsonEncode({"email": email.toString(), "password": pass.toString()}),
        headers: {"Content-Type": "application/json"});

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Get.offAll(() => const LoginPage(),
          transition: Transition.fadeIn, arguments: {"isType": "Faculty"});
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

facultysendOTP(email) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/facultysendOTP"),
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

facultyverifyOTP(email, opt) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/facultyverifyOTP"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.toString(), "otp": int.parse(opt)}));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    showError("Something went wrong", "Can't send OTP at $email");
    debugPrint(e.toString());
  }
}

getFacultyData(token) async {
  try {
    var response = await https.get(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/facultygetSingleUser"),
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

facultyUploadImage(token, image) async {
  log("$image");
  log("$token");
  var headers = {
    "Content-Type": "application/json",
    "x-access-token": token.toString()
  };
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/facultyUploadImage"),
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
