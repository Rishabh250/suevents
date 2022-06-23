import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/Student API/authentication_api.dart';

class GetUserData {
  ValueNotifier deviceID = ValueNotifier("");

  fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("accessToken");
    var user = await getUserData(token);
    return user;
  }

  Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceID.value = androidInfo.androidId.toString();
      log(deviceID.value.toString());
    }
    // if (Platform.isIOS) {
    //   IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    //   iosDeviceInfo.androidId.toString();
    // }
    return deviceID.value;
  }
}
