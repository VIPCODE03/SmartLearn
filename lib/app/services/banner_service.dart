import 'package:flutter/cupertino.dart';

class AppBannerService with ChangeNotifier {
  static final AppBannerService _instance = AppBannerService._();
  factory AppBannerService() => _instance;
  AppBannerService._();

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
