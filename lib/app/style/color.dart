import 'package:flutter/material.dart';

class AppColor {
  final BuildContext _context;
  AppColor(this._context);

  Color get primaryColor => Theme.of(_context).primaryColor;
  Color get iconColor => primaryColor.withAlpha(150);

  static const Color defaultPrimaryColor = Color(0xFF007AFF);
  static const Color defaultSecondaryColor = Color(0xFF34C759);


  static const List<Color> primaryColors = [
    Color(0xFF007AFF), // Xanh dương (iOS Blue)
    Color(0xFFFF3B30), // Đỏ
    Color(0xFF34C759), // Xanh lá
    Color(0xFFFF9500), // Cam
    Color(0xFF5856D6), // Tím

    Color(0xFFFFCC00), // Vàng
    Color(0xFF5AC8FA), // Xanh trời nhạt
    Color(0xFFAF52DE), // Tím hồng
    Color(0xFFFF2D55), // Hồng đậm
    Color(0xFF8E8E93), // Xám trung tính

    Color(0xFF1ABC9C), // Ngọc lam
    Color(0xFF2ECC71), // Xanh lá sáng
    Color(0xFF3498DB), // Xanh biển
    Color(0xFF9B59B6), // Tím đậm
    Color(0xFF34495E), // Xám xanh đậm

    Color(0xFFF1C40F), // Vàng chanh
    Color(0xFFE67E22), // Cam đất
    Color(0xFFE74C3C), // Đỏ đất
    Color(0xFF95A5A6), // Xám bạc
    Color(0xFF7F8C8D), // Xám đậm
  ];
}