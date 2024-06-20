import 'package:flutter/material.dart';
import 'package:template/src/style/app_colors.dart';

class PrimaryButton extends StatefulWidget {
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
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
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
        child: Container(
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
              Padding(
                padding: widget.padding ??
                    EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Stack(
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
          ),
        ),
      ),
    );
  }
}
