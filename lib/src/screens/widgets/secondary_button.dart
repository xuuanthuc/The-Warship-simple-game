import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/src/style/app_colors.dart';

import 'bounce_button.dart';

class SecondaryButton extends StatelessWidget {
  final Function onPressed;
  final Color? background;
  final Color? underground;
  final double radius;
  final EdgeInsets? padding;
  final FontWeight fontWeight;
  final double fontSize;
  final double fontStroke;
  final double darkSize;
  final double borderWidth;
  final String text;
  final String icon;
  final double bottom;
  final double? iconWidth;
  final double? iconHeight;
  final double? width;
  final AlignmentDirectional alignment;

  const SecondaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.background = AppColors.gray,
    this.underground = AppColors.grayDark,
    this.padding,
    this.radius = 12,
    this.fontWeight = FontWeight.w700,
    this.fontSize = 18,
    this.fontStroke = 5,
    this.darkSize = 10,
    this.borderWidth = 3,
    this.bottom = 50,
    this.iconWidth = 60,
    this.iconHeight = 60,
    this.width = 110,
    this.alignment = AlignmentDirectional.bottomCenter,
  }) : super(key: key);

  const SecondaryButton.icon({
    Key? key,
    required this.onPressed,
    this.text = '',
    required this.icon,
    this.background = AppColors.gray,
    this.underground = AppColors.grayDark,
    this.padding,
    this.radius = 12,
    this.fontWeight = FontWeight.w100,
    this.fontSize = 0,
    this.fontStroke = 0,
    this.darkSize = 10,
    this.borderWidth = 3,
    this.bottom = 0,
    this.iconWidth = 80,
    this.iconHeight = 50,
    this.width = 90,
    this.alignment = AlignmentDirectional.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      child: SizedBox(
        width: width?.w,
        child: Stack(
          alignment: alignment,
          children: [
            Container(
              height: (iconHeight?.w ?? 0) * 1.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  width: borderWidth.w,
                  color: Colors.black,
                ),
                color: underground,
              ),
              child: Container(
                margin: EdgeInsets.only(
                  bottom: darkSize.w,
                ),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(radius - 4),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: iconWidth?.w,
                  width: iconHeight?.h,
                  child: Image.asset(icon),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: fontSize == 0 ? 0 : 5,
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
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
            )
          ],
        ),
      ),
      onPressed: () => onPressed(),
    );
  }
}
