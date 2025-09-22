import 'package:flutter/cupertino.dart';

/// Quản lý trạng thái hiển thị của menu popup.
/// Cho phép hiển thị, ẩn hoặc chuyển đổi trạng thái hiển thị của menu.
class PopupMenuController extends ChangeNotifier {
  /// trạng thái hiển thị
  bool menuIsShowing = false;

  //----------------hiển thị menu--------------
  void showMenu() {
    menuIsShowing = true;
    notifyListeners();
  }

  //----------------ẩn menu--------------
  void hideMenu() {
    menuIsShowing = false;
    notifyListeners();
  }

  //----------------lắng nghe thay đổi trạng thái--------------
  void toggleMenu() {
    menuIsShowing = !menuIsShowing;
    notifyListeners();
  }
}
