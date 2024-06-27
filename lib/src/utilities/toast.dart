import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:template/src/style/app_colors.dart';

void appToast({
  required String message,
  ToastGravity? gravity = ToastGravity.BOTTOM,
}) {
  Fluttertoast.showToast(
    msg: message,
    fontSize: 16,
    textColor: Colors.white,
    gravity: gravity,
    timeInSecForIosWeb: 2,
    backgroundColor: AppColors.grayDark,
    webPosition: "center",
    webShowClose: true,
    webBgColor: "linear-gradient(to right, #28323F, #28323F)"
  );
}
