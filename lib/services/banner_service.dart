import 'package:flutter/cupertino.dart';

class BannerService with ChangeNotifier {
  static final BannerService _instance = BannerService._();
  factory BannerService() => _instance;
  BannerService._();

  Widget? _currentBanner;
  Widget? get currentBanner => _currentBanner;

  void showBanner(Widget banner) {
    _currentBanner = banner;
    notifyListeners();
  }

  void removeBanner() {
    _currentBanner = null;
    notifyListeners();
  }
}
