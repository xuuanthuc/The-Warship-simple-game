import 'package:flutter/material.dart';

class BounceButton extends StatefulWidget {
  final Function onPressed;
  final Widget child;

  const BounceButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  State<BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton>
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
        child: widget.child,
      ),
    );
  }
}
