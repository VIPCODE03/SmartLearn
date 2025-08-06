import 'package:flutter/cupertino.dart';
import 'package:smart_learn/core/router/app_router_mixin.dart';
import 'package:smart_learn/features/games/math_matrix/game_math_screen.dart';

abstract class IGameWidget {}

abstract class IGameRouter {
  void goMathMatrix(BuildContext context);
}

class _GameWidget implements IGameWidget {
  static final _GameWidget _singleton = _GameWidget._internal();
  _GameWidget._internal();
  static _GameWidget get instance => _singleton;
}

class _GameRouter extends IGameRouter with AppRouterMixin {
  static final _GameRouter _singleton = _GameRouter._internal();
  _GameRouter._internal();
  static _GameRouter get instance => _singleton;

  @override
  void goMathMatrix(BuildContext context) => pushScale(context, const SCRGameMathMatrix());
}

class GameProvider {
  static final GameProvider _singleton = GameProvider._internal();
  GameProvider._internal();
  static GameProvider get instance => _singleton;

  IGameWidget get widget => _GameWidget.instance;
  IGameRouter get router => _GameRouter.instance;
}
