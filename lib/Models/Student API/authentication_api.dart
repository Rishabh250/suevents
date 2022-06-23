import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as https;
import 'package:suevents/Controller/SharedPreferences/token.dart';
import 'package:suevents/View/Autentication/verify_email.dart';
import 'package:suevents/View/Student%20Portal/Navigation%20Bar/navigation_bar.dart';

import '../../Controller/providers/global_snackbar.dart';
import '../../View/Autentication/login.dart';

userLogin(email, pass, deviceID) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/loginUser"),
        body: jsonEncode({
          "email": email.toString(),
          "password": pass.toString(),
          "deviceInfo": "$deviceID"
        }),
        headers: {"Content-Type": "application/json"});
    print(response.body);

    var body = jsonDecode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      if (body['verified'] == true) {
        accessToken(jsonDecode(response.body)["token"]);

        loginStatus(true);
        getUser("Student");
        Get.offAll(const NavigationBarPage(), transition: Transition.fadeIn);
      } else {
        await sendOTP(email);
        EasyLoading.dismiss();

        Get.to(() => const EmailVerify(),
            arguments: {"isType": "Student", "email": email},
            transition: Transition.fadeIn);
      }
    } else {
      if (body['msg'] == "Password wrong") {
        showError("Invaild Details", "You have entered wrong password");
      }
      if (body['msg'] == "user not found") {
        showError("Invaild Details", "User not found");
      }
      if (body['msg'] == "Device Model not same") {
        showError(
            "Device Error", "You are trying to login with different device");
      }
      if (body['msg'] == "Device Already in use") {
        showError("Device Error", "Device Already in use");
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

createStudent(
    email, pass, name, sysID, course, year, semester, gender, deviceID) async {
  try {
    print(deviceID);
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/createUser"),
        body: jsonEncode({
          "email": email.toString(),
          "password": pass.toString(),
          "name": name.toString(),
          "systemID": sysID.toString(),
          "course": course.toString(),
          "year": year,
          "semester": semester,
          "gender": gender.toString(),
          "deviceInfo": "$deviceID",
          "type": "Student"
        }),
        headers: {"Content-Type": "application/json"});

    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

resetPassword(email, pass) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/forgetPassword"),
        body: jsonEncode({"email": email.toString(), "password": pass.toString()}),
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
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/sendOTP"),
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

verifyOTP(email, otp) async {
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/verifyOTP"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.toString(), "otp": int.parse(otp)}));
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

getUserData(token) async {
  try {
    var response = await https.get(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/userInfo"),
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
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/uploadImage"),
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

checkDevice(deviceID) async {
  var headers = {
    "Content-Type": "application/json",
  };
  try {
    var response = await https.post(
        Uri.parse(
            "http://shardaevents-env.eba-nddxcy3c.ap-south-1.elasticbeanstalk.com/checkDevice"),
        headers: headers,
        body: jsonEncode({"deviceID": "$deviceID"}));

    if (response.statusCode == 200) {
      return true;
    } else {
      showError("Device in use...",
          "Another account is already connected with this device....");
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
