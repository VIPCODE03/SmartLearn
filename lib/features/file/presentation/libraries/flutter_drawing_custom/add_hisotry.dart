import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:smart_learn/features/file/presentation/libraries/flutter_drawing_custom/triangle.dart';

extension DrawingControllerExtension on DrawingController {
  void addContentsDecode(String json) {
    try {
      final List<dynamic> list = jsonDecode(json);

      for (var map in list) {
        final Map<String, dynamic> mapJson = map as Map<String, dynamic>;
        switch(mapJson['type']) {
          case "SimpleLine": addContent(SimpleLine.fromJson(mapJson));
          case "SmoothLine": addContent(SmoothLine.fromJson(mapJson));
          case "StraightLine": addContent(StraightLine.fromJson(mapJson));
          case "Rectangle": addContent(Rectangle.fromJson(mapJson));
          case "Circle": addContent(Circle.fromJson(mapJson));
          case "Eraser": addContent(Eraser.fromJson(mapJson));
          case "Triangle": addContent(Triangle.fromJson(mapJson));
        }
      }
    }
    catch(e) {
      debugPrint('Error convert data draw $e');
    }
  }
}
