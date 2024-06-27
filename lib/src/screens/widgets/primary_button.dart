import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/src/style/app_colors.dart';

import 'bounce_button.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPressed;
  final Color? background;
  final Color? underground;
  final double opacity;
  final double radius;
  final EdgeInsets? padding;
  final FontWeight fontWeight;
  final double fontSize;
  final double fontStroke;
  final double darkSize;
  final double borderWidth;
  final String text;

  const PrimaryButton.primary({
    Key? key,
    required this.onPressed,
    required this.text,
    this.background = AppColors.primary,
    this.underground = AppColors.primaryDark,
    this.padding,
    this.opacity = 0.3,
    this.radius = 12,
    this.fontWeight = FontWeight.w700,
    this.fontSize = 20,
    this.fontStroke = 5,
    this.darkSize = 10,
    this.borderWidth = 3,
  }) : super(key: key);

  const PrimaryButton.secondary({
    Key? key,
    required this.onPressed,
    required this.text,
    this.background = AppColors.secondary,
    this.underground = AppColors.secondaryDark,
    this.padding,
    this.opacity = 0.3,
    this.radius = 12,
    this.fontWeight = FontWeight.w700,
    this.fontSize = 20,
    this.fontStroke = 5,
    this.darkSize = 10,
    this.borderWidth = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            width: borderWidth.w,
            color: Colors.black,
          ),
          color: underground,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: EdgeInsets.only(
                  bottom: darkSize.h,
                ),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(radius - 4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [],
                ),
              ),
            ),
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(opacity),
                        borderRadius: BorderRadius.circular(radius - 4),
                      ),
                      margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: padding ??
                  EdgeInsets.symmetric(horizontal: 50.w, vertical: 20.h),
              child: Stack(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: "Mitr",
                      fontWeight: fontWeight,
                      fontSize: fontSize.sp,
                      letterSpacing: 2,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = fontStroke.w
                        ..color = Colors.black,
                    ),
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: "Mitr",
                      letterSpacing: 2,
                      fontWeight: fontWeight,
                      fontSize: fontSize.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onPressed: () => onPressed(),
    );
  }
}
