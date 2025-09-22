import 'package:flutter/material.dart';
import 'package:smart_learn/features/libraries/painter.dart';

// Class biểu diễn một điểm
class CvsPoint implements CvsDrawable {
  final double x;
  final double y;
  final String? name;

  CvsPoint(this.x, this.y, {this.name});

  CvsPoint operator +(CvsPoint other) {
    return CvsPoint(x + other.x, y + other.y);
  }

  CvsPoint operator -(CvsPoint other) {
    return CvsPoint(x - other.x, y - other.y);
  }
}

// Class trừu tượng cho các đối tượng có thể vẽ
abstract class CvsDrawable {}

// Class biểu diễn một đường thẳng
class CvsLine implements CvsDrawable {
  final CvsPoint startPoint;
  final CvsPoint endPoint;

  CvsLine({required this.startPoint, required this.endPoint});
}

// Class biểu diễn một đường cong Bezier bậc ba
class CvsCurve implements CvsDrawable {
  final CvsPoint startPoint;
  final CvsPoint controlPoint1;
  final CvsPoint controlPoint2;
  final CvsPoint endPoint;

  CvsCurve({
    required this.startPoint,
    required this.controlPoint1,
    required this.controlPoint2,
    required this.endPoint,
  });
}

// Class biểu diễn một đường thẳng nét đứt
class CvsDashedLine implements CvsDrawable {
  final CvsPoint startPoint;
  final CvsPoint endPoint;

  CvsDashedLine({required this.startPoint, required this.endPoint});
}

class CvsCircle implements CvsDrawable {
  final CvsPoint center;
  final double radius;

  CvsCircle({required this.center, required this.radius});
}

// Widget để hiển thị đồ họa
class CoordinateSystem extends StatelessWidget {
  final List<CvsDrawable> drawables;

  const CoordinateSystem({super.key, required this.drawables});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CvsCoordinatePainter(drawables: drawables),
      size: Size(
          MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width
      ),
    );
  }
}
