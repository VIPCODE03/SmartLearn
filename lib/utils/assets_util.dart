import 'package:flutter/services.dart';

class UTIAssets {
  static const path = _AssetsPath();

  static Future<String> loadString(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      throw Exception("UtilAssets: Error load assets: $path\nError: $e");
    }
  }
}

class _AssetsPath {
  const _AssetsPath();

  final languages = const _LanguagesAssets();

  final images = const _ImageAssets();

  final icons = const _IconAssets();

  final train = const _TrainAssets();
}

// 📂 Language files
class _LanguagesAssets {
  const _LanguagesAssets();

  final String en = "assets/languages/en";
  final String vi = "assets/languages/vi";
}

// 📂 Hình ảnh
class _ImageAssets {
  const _ImageAssets();

  final String logo = "assets/images/logo.png";
  final String backgroundAI = "assets/images/background_ai.png";
  final String loadingGif = "assets/images/loading.gif";
}

// 📂 Icon
class _IconAssets {
  const _IconAssets();

  final String home = "assets/icons/home.png";
  final String settings = "assets/icons/settings.png";
}

class _TrainAssets {
  const _TrainAssets();

  final String format = "assets/train/format";
  final String mission = "assets/train/mission";
  final String quiz = "assets/train/quiz";
  final String translate = "assets/train/translate";
  final String testJson = "assets/train/test_json";
}
