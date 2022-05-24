import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

var primaryTextColor = const Color.fromRGBO(205, 206, 209, 1);
var secondaryTextColor = const Color.fromRGBO(112, 116, 119, 1);
var titleText = GoogleFonts.montserrat(
    fontSize: 23.sp,
    fontWeight: FontWeight.w600,
    color: primaryTextColor,
    fontStyle: FontStyle.normal);

textStyle(fontSize, fontWeight, fontColor, fontStyle) {
  return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: fontColor,
      fontStyle: fontStyle);
}

textStyleGradient(fontSize, fontWeight, fontStyle) {
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[
      Color.fromRGBO(20, 168, 0, 1),
      Color.fromRGBO(26, 108, 14, 1)
    ],
  ).createShader(const Rect.fromLTRB(0.0, 10.0, 0.0, 10.0));
  return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      foreground: Paint()..shader = linearGradient,
      fontStyle: fontStyle);
}
