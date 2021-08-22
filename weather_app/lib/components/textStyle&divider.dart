import 'package:flutter/material.dart';

TextStyle hourlyDataTextStyle(double fsize) =>
    TextStyle(color: Colors.white, fontSize: fsize);

TextStyle todayWeatherTextStyle(
    {required double fsize, FontWeight? fweight, Color? fcolour}) {
  // null safety used to give function arumental calls acc to need
  return TextStyle(
    fontSize: fsize,
    fontWeight: fweight,
    color: fcolour,
  );
}

Divider divider() {
  return Divider(
    color: Colors.greenAccent,
    thickness: 1.5,
  );
}

TextStyle currentWeatherTextStyle(
        {required double fsize,
        Color? fcolour,
        FontWeight? fweight,
        double? fheight}) =>
    TextStyle(
        color: fcolour, fontSize: fsize, fontWeight: fweight, height: fheight);
