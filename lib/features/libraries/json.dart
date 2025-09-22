import 'dart:convert';

import 'drawable.dart';

List<CvsDrawable> parseJsonDrawables(String jsonString) {
  final List<dynamic> jsonData = jsonDecode(jsonString);
  final List<CvsDrawable> drawables = [];

  for (final dynamic item in jsonData) {
    final String type = item['type'];
    switch (type) {
      case 'CvsPoint':
        drawables.add(CvsPoint(
          (item['x'] as num).toDouble(),
          (item['y'] as num).toDouble(),
          name: item['name'] as String?,
        ));
        break;
      case 'CvsLine':
        drawables.add(CvsLine(
          startPoint: CvsPoint(
            (item['startPoint']['x'] as num).toDouble(),
            (item['startPoint']['y'] as num).toDouble(),
          ),
          endPoint: CvsPoint(
            (item['endPoint']['x'] as num).toDouble(),
            (item['endPoint']['y'] as num).toDouble(),
          ),
        ));
        break;
      case 'CvsCurve':
        drawables.add(CvsCurve(
          startPoint: CvsPoint(
            (item['startPoint']['x'] as num).toDouble(),
            (item['startPoint']['y'] as num).toDouble(),
          ),
          controlPoint1: CvsPoint(
            (item['controlPoint1']['x'] as num).toDouble(),
            (item['controlPoint1']['y'] as num).toDouble(),
          ),
          controlPoint2: CvsPoint(
            (item['controlPoint2']['x'] as num).toDouble(),
            (item['controlPoint2']['y'] as num).toDouble(),
          ),
          endPoint: CvsPoint(
            (item['endPoint']['x'] as num).toDouble(),
            (item['endPoint']['y'] as num).toDouble(),
          ),
        ));
        break;
      case 'CvsDashedLine':
        drawables.add(CvsDashedLine(
          startPoint: CvsPoint(
            (item['startPoint']['x'] as num).toDouble(),
            (item['startPoint']['y'] as num).toDouble(),
          ),
          endPoint: CvsPoint(
            (item['endPoint']['x'] as num).toDouble(),
            (item['endPoint']['y'] as num).toDouble(),
          ),
        ));
        break;
      case 'CvsCircle':
        drawables.add(CvsCircle(
          center: CvsPoint(
            (item['center']['x'] as num).toDouble(),
            (item['center']['y'] as num).toDouble(),
          ),
          radius: (item['radius'] as num).toDouble(),
        ));
        break;
      default:
        print('Unknown drawable type: $type');
    }
  }
  return drawables;
}