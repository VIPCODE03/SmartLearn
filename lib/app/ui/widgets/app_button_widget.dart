import 'package:flutter/material.dart';

class WdgBounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Duration duration;
  final double scaleFactor;
  final Function(DragStartDetails)? onPanStart;
  final Function(DragUpdateDetails)? onPanUpdate;
  final Function(DragEndDetails)? onPanEnd;

  const WdgBounceButton({
    super.key,
    required this.child,
    required this.onTap,
    this.duration = const Duration(milliseconds: 75),
    this.scaleFactor = 0.9,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
  });

  @override
  State<WdgBounceButton> createState() => _WdgBounceButtonState();
}

class _WdgBounceButtonState extends State<WdgBounceButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = widget.scaleFactor);
  }

  void _onTapUp(TapUpDetails details) {
    Future.delayed(widget.duration, () {
      setState(() => _scale = 1.0);
    });
    Future.delayed(widget.duration + widget.duration, () {
      widget.onTap();
    });
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: widget.onPanStart,
      onPanUpdate: widget.onPanUpdate,
      onPanEnd: widget.onPanEnd,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: widget.duration,
        curve: Curves.bounceInOut,
        child: widget.child,
      ),
    );
  }
}
