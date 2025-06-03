// Trong file painter.dart (hoặc nơi bạn định nghĩa CvsCoordinatePainter)

import 'dart:math';

import 'package:flutter/material.dart';
import 'drawable.dart';

// Giả sử các class CvsPoint, CvsLine, CvsCurve, CvsDashedLine, CvsDrawable đã được định nghĩa ở file khác

class CvsCoordinatePainter extends CustomPainter {
  final List<CvsDrawable> drawables;

  CvsCoordinatePainter({required this.drawables});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var drawable in drawables) {
      if (drawable is CvsLine) {
        canvas.drawLine(
          Offset(drawable.startPoint.x, drawable.startPoint.y),
          Offset(drawable.endPoint.x, drawable.endPoint.y),
          paint,
        );
      } else if (drawable is CvsCurve) {
        final path = Path();
        path.moveTo(drawable.startPoint.x, drawable.startPoint.y);
        path.cubicTo(
          drawable.controlPoint1.x,
          drawable.controlPoint1.y,
          drawable.controlPoint2.x,
          drawable.controlPoint2.y,
          drawable.endPoint.x,
          drawable.endPoint.y,
        );
        canvas.drawPath(path, paint);
      } else if (drawable is CvsDashedLine) {
        final dashPaint = Paint()
          ..color = Colors.green
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

        final path = Path();
        double dashLength = 2.0;
        double gapLength = 3.0;
        double totalLength = sqrt(
          pow(drawable.endPoint.x - drawable.startPoint.x, 2) +
              pow(drawable.endPoint.y - drawable.startPoint.y, 2),
        );
        double currentDistance = 0.0;
        bool draw = true;

        while (currentDistance < totalLength) {
          double segmentLength = draw ? dashLength : gapLength;
          if (currentDistance + segmentLength > totalLength) {
            segmentLength = totalLength - currentDistance;
          }

          if (segmentLength > 0) {
            double startX = drawable.startPoint.x +
                (drawable.endPoint.x - drawable.startPoint.x) *
                    currentDistance /
                    totalLength;
            double startY = drawable.startPoint.y +
                (drawable.endPoint.y - drawable.startPoint.y) *
                    currentDistance /
                    totalLength;
            double endX = drawable.startPoint.x +
                (drawable.endPoint.x - drawable.startPoint.x) *
                    (currentDistance + segmentLength) /
                    totalLength;
            double endY = drawable.startPoint.y +
                (drawable.endPoint.y - drawable.startPoint.y) *
                    (currentDistance + segmentLength) /
                    totalLength;

            if (draw) {
              path.moveTo(startX, startY);
              path.lineTo(endX, endY);
            }

            currentDistance += segmentLength;
            draw = !draw;
          } else {
            break;
          }
        }
        canvas.drawPath(path, dashPaint);
      } else if (drawable is CvsPoint && drawable.name != null) {
        canvas.drawCircle(Offset(drawable.x, drawable.y), 2.0, pointPaint);
        textPainter.text = TextSpan(
          text: drawable.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14.0,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(drawable.x , drawable.y ),
        );
      } else if (drawable is CvsPoint) {
        canvas.drawCircle(Offset(drawable.x - 5, drawable.y - 10), 0.0, pointPaint);
      } else if (drawable is CvsCircle) {
        final circlePaint = Paint()
          ..color = Colors.green
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(
          Offset(drawable.center.x, drawable.center.y),
          drawable.radius,
          circlePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CvsCoordinatePainter oldDelegate) {
    return oldDelegate.drawables != drawables;
  }
}
