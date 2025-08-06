import 'package:flame/game.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/features/games/maze/domain/entities/maze_cell_entity.dart';
import 'package:smart_learn/features/games/maze/domain/logics/maze_generate.dart';
import 'package:smart_learn/features/games/maze/flame/components/maze_world_component.dart';
import 'package:smart_learn/features/games/maze/flame/components/player_component.dart';
import 'package:smart_learn/features/games/maze/presentation/widgets/direction_pad.dart';

class MazeGame extends FlameGame {
  late COMMazeWorld mazeWorld;
  late PlayerComponent player;

  /// Kích cỡ ô
  late double cellSize = 0;

  late Map<String, ENTMazeCell> mazeGrid;

  @override
  Future<void> onLoad() async {
    logDev('onLoad', context: 'MazeGame');
    super.onLoad();
    final logic = LOGMazeGenerate.instance;
    logic.setLevel(LOGMazeGenerateLevel.easy);
    mazeGrid = logic.mazeGenerate();

    // Lấy kích thước thật của màn hình game
    final screenWidth = size.x;
    final screenHeight = size.y;

    // Tính toán cellSize sao cho mê cung chiếm vừa màn hình
    final cellWidth = screenWidth / logic.maxColumn;
    final cellHeight = screenHeight / logic.maxRow;

    // Chọn kích thước nhỏ hơn để giữ tỉ lệ vuông vắn
    cellSize = cellWidth < cellHeight ? cellWidth : cellHeight;

    mazeWorld = COMMazeWorld(
      rows: logic.maxRow,
      cols: logic.maxColumn,
      cellSize: cellSize,
      grid: mazeGrid,
    );
    add(mazeWorld);

    mazeGrid.forEach((key, value) {
      if (value.isStart) {
        player = PlayerComponent(
          cellSize: cellSize,
          initialPosition: Vector2(value.row * cellSize, value.col * cellSize)
        );
      }
    });

    player.setMazeGrid(mazeGrid);
    add(player);

  }

  /// 4. Xử lý khi người chơi bấm nút di chuyển
  void handleDirectionInput(Direction direction) {
    final currentCol = (player.position.x / cellSize).floor();
    final currentRow = (player.position.y / cellSize).floor();
    final currentCell = mazeGrid['$currentRow,$currentCol']!;

    bool canMove = false;
    Vector2 delta = Vector2.zero();

    switch (direction) {
      case Direction.up:
        if (!currentCell.topWall) {
          canMove = true;
          delta = Vector2(0, -cellSize);
        }
        break;
      case Direction.down:
        if (!currentCell.bottomWall) {
          canMove = true;
          delta = Vector2(0, cellSize);
        }
        break;
      case Direction.left:
        if (!currentCell.leftWall) {
          canMove = true;
          delta = Vector2(-cellSize, 0);
        }
        break;
      case Direction.right:
        if (!currentCell.rightWall) {
          canMove = true;
          delta = Vector2(cellSize, 0);
        }
        break;
    }

    if (canMove) {
      player.position += delta;

      final newCol = (player.position.x / cellSize).floor();
      final newRow = (player.position.y / cellSize).floor();

      if (currentCell.isEnd) {
        onPlayerWin();
      }
    }
  }

  void onPlayerWin() {
    overlays.add('win');
    pauseEngine();
  }
}
