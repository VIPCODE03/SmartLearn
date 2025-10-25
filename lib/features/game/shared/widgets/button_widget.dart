import 'package:flutter/material.dart';

class WIDButtonGame extends StatefulWidget {
  final Widget child;
  final BorderRadiusGeometry? radius;
  final VoidCallback onPressed;
  final Color? color;

  const WIDButtonGame({super.key,
    required this.child,
    required this.onPressed,
    this.radius,
    this.color
  });

  @override
  State<WIDButtonGame> createState() => _WIDButtonGameState();
}

class _WIDButtonGameState extends State<WIDButtonGame> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => Future.delayed(const Duration(milliseconds: 100), () {
        setState(() => _isPressed = false);
      }),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        Future.delayed(const Duration(milliseconds: 100), () {
          widget.onPressed();
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: _isPressed ? 5 : 0),
        decoration: BoxDecoration(
          borderRadius: widget.radius,
          color: (widget.color ?? Colors.grey).withValues(alpha: 0.2),
          border: Border(
            bottom: BorderSide(
              color: widget.color ?? Colors.grey,
              width: _isPressed ? 0.5 : 4,
            ),
            right: BorderSide(
              color: widget.color ?? Colors.grey,
              width: _isPressed ? 0.5 : 2,
            ),
            left: BorderSide(
              color: widget.color ?? Colors.grey,
              width: _isPressed ? 0.5 : 1,
            ),
            top: BorderSide(
              color: widget.color ?? Colors.grey,
              width: _isPressed ? 0.5 : 1,
            ),
          )
        ),
        child: widget.child
      ),
    );
  }
}
