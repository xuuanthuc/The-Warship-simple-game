import 'package:flutter/material.dart';
import 'package:template/src/style/app_colors.dart';
import 'package:template/src/style/app_images.dart';

class SecondaryButton extends StatefulWidget {
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
  final String icon;
  final double bottom;
  final double? iconWidth;
  final double? iconHeight;
  final double? width;

  SecondaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.background = AppColors.gray,
    this.underground = AppColors.grayDark,
    this.padding,
    this.opacity = 0.3,
    this.radius = 12,
    this.fontWeight = FontWeight.w700,
    this.fontSize = 24,
    this.fontStroke = 5,
    this.darkSize = 10,
    this.borderWidth = 3,
    this.bottom = 70,
    this.iconWidth = 100,
    this.iconHeight = 100,
    this.width = 180,
  }) : super(key: key);

  SecondaryButton.icon({
    Key? key,
    required this.onPressed,
    this.text = '',
    required this.icon,
    this.background = AppColors.gray,
    this.underground = AppColors.grayDark,
    this.padding,
    this.opacity = 0,
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
  }) : super(key: key);

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1, end: 1.05).animate(_controller),
      child: GestureDetector(
        onTap: () async {
          await Future.delayed(const Duration(milliseconds: 100));
          widget.onPressed();
        },
        onTapUp: (a) async {
          await Future.delayed(const Duration(milliseconds: 100));
          _controller.reverse();
        },
        onTapDown: (a) {
          _controller.forward();
        },
        onTapCancel: () {
          _controller.reverse();
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                border: Border.all(
                  width: widget.borderWidth,
                  color: Colors.black,
                ),
                color: widget.underground,
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: widget.darkSize,
                      ),
                      decoration: BoxDecoration(
                        color: widget.background,
                        borderRadius: BorderRadius.circular(widget.radius - 4),
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
                              color: Colors.white.withOpacity(widget.opacity),
                              borderRadius:
                                  BorderRadius.circular(widget.radius - 4),
                            ),
                            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: widget.padding ??
                        EdgeInsets.fromLTRB(
                          20,
                          60,
                          20,
                          10,
                        ),
                    width: widget.width,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Text(
                          widget.text,
                          style: TextStyle(
                            fontFamily: "Rowdies",
                            fontWeight: widget.fontWeight,
                            fontSize: widget.fontSize,
                            letterSpacing: 2,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = widget.fontStroke
                              ..color = Colors.black,
                          ),
                        ),
                        Text(
                          widget.text,
                          style: TextStyle(
                            fontFamily: "Rowdies",
                            letterSpacing: 2,
                            fontWeight: widget.fontWeight,
                            fontSize: widget.fontSize,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: widget.iconWidth,
                  width: widget.iconHeight,
                  child: Image.asset(widget.icon),
                ),
                SizedBox(
                  height: widget.bottom,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
