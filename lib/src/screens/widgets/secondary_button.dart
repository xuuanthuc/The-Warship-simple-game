import 'package:flutter/material.dart';
import 'package:template/src/style/app_colors.dart';

class SecondaryButton extends StatefulWidget {
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
        child: SizedBox(
          width: widget.width,
          child: Stack(
            alignment: widget.alignment,
            children: [
              Container(
                height: (widget.iconHeight ?? 1) * 1.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.radius),
                  border: Border.all(
                    width: widget.borderWidth,
                    color: Colors.black,
                  ),
                  color: widget.underground,
                ),
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: widget.darkSize,
                  ),
                  decoration: BoxDecoration(
                    color: widget.background,
                    borderRadius: BorderRadius.circular(widget.radius - 4),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: widget.iconWidth,
                    width: widget.iconHeight,
                    child: Image.asset(widget.icon),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: widget.fontSize == 0 ? 0 : 5,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Text(
                          widget.text,
                          style: TextStyle(
                            fontFamily: "Mitr",
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
                            fontFamily: "Mitr",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
