import 'package:flutter/cupertino.dart';

abstract class AppColors {
  const AppColors();

  static const primary = Color(0xFFFBB501);
  static const primaryDark = Color(0xFFE59001);
  static const secondary = Color(0xFF0072FF);
  static const secondaryDark = Color(0xFF0151F5);
  static const gray = Color(0xFF323C51);
  static const grayDark = Color(0xFF28323F);

  static const backgroundYellow = RadialGradient(
    colors: [
      Color(0xffF5F47E),
      Color(0xffF4E55B),
      Color(0xffF4C73D),
      Color(0xffF3B233),
      Color(0xffF3842D),
    ],
    radius: 1,
    stops: [
      0,
      0.24,
      0.52,
      0.71,
      1,
    ],
  );
  static const backgroundBlue = RadialGradient(
    colors: [
      Color(0xff89f2f3),
      Color(0xff37E7F4),
      Color(0xff07C8F4),
      Color(0xff08A4F4),
      Color(0xff0387F5),
    ],
    radius: 1,
    stops: [
      0.08,
      0.28,
      0.51,
      0.8,
      1,
    ],
  );

  static const backgroundGreen = RadialGradient(
    colors: [
      Color(0xff9BF2A9),
      Color(0xff8EF09D),
      Color(0xff42EA84),
      Color(0xff00BDAA),
      Color(0xff00A5B6),
    ],
    radius: 1,
    stops: [
      0.13,
      0.22,
      0.44,
      0.79,
      1,
    ],
  );
}
