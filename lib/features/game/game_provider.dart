import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/features/game/games/math_matrix/game_math_screen.dart';
import 'package:smart_learn/features/game/games/maze/presentation/maze_game_screen.dart';
import 'package:smart_learn/features/game/main/presentation/screens/game_screen.dart';
import 'package:smart_learn/features/game/shared/widgets/button_widget.dart';

abstract class IGameWidget {
  Widget buttonGame(BuildContext context);
}

abstract class IGameRouter {
  void goGameScreen(BuildContext context);
  void goMathMatrix(BuildContext context);
  void goMaze(BuildContext context);
}

class _GameWidget extends IGameWidget with AppRouterMixin {
  static final _GameWidget _singleton = _GameWidget._internal();
  _GameWidget._internal();
  static _GameWidget get instance => _singleton;

  @override
  Widget buttonGame(BuildContext context) {
    return WIDButtonGame(
      onPressed: () => pushFade(context, const SCRGame()),
      radius: BorderRadius.circular(12),
      color: context.style.color.primaryColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(
          globalLanguage.play,
          style: GoogleFonts.pressStart2p(
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class _GameRouter extends IGameRouter with AppRouterMixin {
  static final _GameRouter _singleton = _GameRouter._internal();
  _GameRouter._internal();
  static _GameRouter get instance => _singleton;

  @override
  void goGameScreen(BuildContext context) => pushScale(context, const SCRGame());

  @override
  void goMathMatrix(BuildContext context) => pushScale(context, const SCRGameMathMatrix());

  @override
  void goMaze(BuildContext context) => pushScale(context, const SCRMazeGame());
}

class GameProvider {
  static final GameProvider _singleton = GameProvider._internal();
  GameProvider._internal();
  static GameProvider get instance => _singleton;

  IGameWidget get widget => _GameWidget.instance;
  IGameRouter get router => _GameRouter.instance;
}
