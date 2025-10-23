import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flutter/services.dart';

class AppAssets {
  static const path = _AssetsPath();

  static final Map<String, Image> _imageCache = {};
  static Future<Image> gameLoadImage(String path) async {
    if (_imageCache.containsKey(path)) {
      return _imageCache[path]!;
    }

    try {
      Flame.images.prefix = '';
      final image = await Flame.images.load(path);
      _imageCache[path] = image;
      return image;
    } catch (e) {
      throw Exception("UtilAssets: Error load image: $path\nError: $e");
    }
  }

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

  final game = const _GameAssets();
}

class _GameAssets {
  const _GameAssets();

  final maze = const _Maze();
}

class _Maze {
  const _Maze();
  final String mazeMap = "assets/game/maze/maze_map.png";
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
  final String bgUser = "assets/images/bg_user.png";
  final String loadingGif = "assets/images/loading.gif";
  final String splashGif = "assets/images/splash.gif";
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
  final String flashcard = "assets/train/flashcard";
  final String translate = "assets/train/translate";
  final String testJson = "assets/train/test_json";
  final String analysis = "assets/train/personalization";
}