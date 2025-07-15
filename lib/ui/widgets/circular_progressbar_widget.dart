import 'dart:math' as math;
import 'package:flutter/material.dart';

class WdgCircularProgressBar extends StatefulWidget {
  final double percentage;
  final double radius;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  const WdgCircularProgressBar({
    super.key,
    required this.percentage,
    this.radius = 100.0,
    this.strokeWidth = 10.0,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
  });

  @override
  State<WdgCircularProgressBar> createState() => _WdgCircularProgressBarState();
}

class _WdgCircularProgressBarState extends State<WdgCircularProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 666),
    );

    _animation = Tween<double>(begin: 0.0, end: widget.percentage).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant WdgCircularProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    //- Cập nhật nếu giá trị thay đổi ---
    if (widget.percentage != oldWidget.percentage) {
      _animation = Tween<double>(begin: oldWidget.percentage, end: widget.percentage).animate(_controller);
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      ///-  Vẽ vòng tròn  -------------------------------------
      painter: _CircularProgressPainter(
        percentage: _animation.value,
        radius: widget.radius,
        strokeWidth: widget.strokeWidth,
        backgroundColor: widget.backgroundColor,
        progressColor: widget.progressColor,
      ),
      size: Size(widget.radius * 2, widget.radius * 2),
      child: Center(
        ///-  Hiển thị phần trăm  ------------------------------
        child: Text(
          '${(_animation.value * 100).toInt()}%',
          style: TextStyle(
            fontSize: widget.radius * 0.3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double percentage;
  final double radius;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _CircularProgressPainter({
    required this.percentage,
    required this.radius,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //- Tâm -
    Offset center = Offset(size.width / 2, size.height / 2);

    //- Vòng tròn nền -
    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    //- Vòng tròn tiến độ   -
    Paint progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Tính toán góc quét (sweepAngle) dựa trên phần trăm
    // 2 * math.pi là 360 độ (một vòng tròn đầy đủ)
    // percentage * 2 * math.pi là góc quét tương ứng với phần trăm
    double sweepAngle = 2 * math.pi * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor;
  }
}