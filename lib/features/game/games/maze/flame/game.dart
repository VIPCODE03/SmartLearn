import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:smart_learn/app/assets/app_assets.dart';
import 'package:smart_learn/features/game/games/maze/domain/logics/maze_generate.dart';
import 'package:smart_learn/features/game/games/maze/flame/components/components.dart';
import 'package:smart_learn/features/game/games/maze/presentation/widgets/direction_pad.dart';

class MazeGame extends FlameGame {
  late COMMazeWorld _mazeWorld;
  late PlayerComponent _player;
  late final SpriteSheet _spriteSheet;

  ValueNotifier<int> remainingTime = ValueNotifier(60);
  late Timer _countdownTimer;

  /// Kích cỡ ô
  late double cellSize;
  /// Mê cung
  late Maze _maze;
  late LOGMazeGenerateLevel _level;
  int keysTaken = 0;
  int get maxKeys => _maze.maxKey;

  MazeGame.easy() {
    _level = LOGMazeGenerateLevel.easy;
  }

  MazeGame.medium() {
    _level = LOGMazeGenerateLevel.medium;
  }

  MazeGame.hard() {
    _level = LOGMazeGenerateLevel.hard;
  }

  MazeGame.expert() {
    _level = LOGMazeGenerateLevel.expert;
  }

  MazeGame.master() {
    _level = LOGMazeGenerateLevel.master;
  }

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    //- Khởi tạo mê cung
    final logic = LOGMazeGenerate.init(size.x, size.y);
    logic.setLevel(_level);
    _maze = logic.mazeGenerate();

    //- Load ảnh game
    final image = await AppAssets.gameLoadImage(AppAssets.path.game.maze.mazeMap);
    _spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(16, 16),
    );

    //- Tìm kích cỡ ô phù hợp
    cellSize = (size.x / _maze.maxColumn).floorToDouble();

    _mazeWorld = COMMazeWorld(
      rows: _maze.maxRow,
      cols: _maze.maxColumn,
      cellSize: cellSize,
      grid: _maze.mazeGrid,
      spriteSheet: _spriteSheet
    );
    await add(_mazeWorld);

    //- Tạo player
    _player = PlayerComponent(
        grid: _maze.mazeGrid,
        cellSize: cellSize,
        initPosition: Vector2(
            (_maze.colStart * cellSize).toDouble(),
            (_maze.rowStart * cellSize).toDouble()
        ),
        spriteSheet: _spriteSheet
    );
    await add(_player);

    remainingTime.value = _maze.maxTime;
    _startTime();
  }

  void _startTime() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value -= 1;
      } else {
        timer.cancel();
        _countdownTimer.cancel();
        onPlayerLose();
      }
    });
  }

  //- Xử lý sự kiện ------------------------------------------------------------
  void handleDirectionInput(Direction direction) {
    final currentPositionPlayer = _player.move(direction);
    final int currentCol = (currentPositionPlayer.x / cellSize).round();
    final int currentRow = (currentPositionPlayer.y / cellSize).round();
    final currentCell = _maze.mazeGrid['$currentRow,$currentCol']!;

    if (currentCell.isGotKey != null && !currentCell.isGotKey!) {
      keysTaken++;
      currentCell.isGotKey = true;
      _mazeWorld.updateKeyAppearance(currentRow, currentCol);
    }

    if(currentCell.isEnd) {
      if(keysTaken == _maze.maxKey) {
        onPlayerWin();
      }
    }
  }

  void onPlayerLose() {
    overlays.add('lose');
    pauseEngine();
  }

  void onPlayerWin() {
    overlays.add('win');
    pauseEngine();
  }
}
