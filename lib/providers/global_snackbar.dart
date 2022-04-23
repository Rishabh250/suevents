import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

void showError(String error, String errorMsg) {
  Get.snackbar(
    "",
    "",
    titleText: Text(error,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, color: Colors.white)),
    messageText: Text(errorMsg,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white)),
    icon: const Icon(Icons.error, color: Colors.red),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    borderRadius: 20,
    margin: const EdgeInsets.all(15),
    duration: const Duration(seconds: 4),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}

void showConfirm(String confirmText, String confirmMsg) {
  Get.snackbar(
    "",
    "",
    titleText: Text(confirmText,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, color: Colors.white)),
    messageText: Text(confirmMsg,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white)),
    icon: const Icon(Icons.done, color: Color.fromARGB(255, 14, 161, 26)),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    borderRadius: 20,
    margin: const EdgeInsets.all(15),
    duration: const Duration(seconds: 4),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}
