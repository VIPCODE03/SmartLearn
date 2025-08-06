import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:smart_learn/features/games/maze/domain/entities/maze_cell_entity.dart';

import '../../presentation/widgets/direction_pad.dart';

class PlayerComponent extends PositionComponent {
  final double cellSize;
  late Map<String, ENTMazeCell> grid;

  PlayerComponent({
    required this.cellSize,
    required Vector2 initialPosition,
  }) {
    position = initialPosition;
    size = Vector2(cellSize / 1.5, cellSize / 1.5);
  }

  final Paint _paint = Paint()..color = Colors.red;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      Offset(size.x * 0.75, size.y * 0.75),
      size.x / 3,
      _paint,
    );
  }

  /// Gán grid từ ngoài vào sau khi tạo player
  void setMazeGrid(Map<String, ENTMazeCell> mazeGrid) {
    grid = mazeGrid;
  }

  /// Di chuyển theo hướng, nếu không bị tường chặn
  void move(Direction direction) {
    final currentCol = (position.x / cellSize).floor();
    final currentRow = (position.y / cellSize).floor();
    final currentCell = grid['$currentRow,$currentCol']!;

    Vector2 delta = Vector2.zero();
    bool canMove = false;

    switch (direction) {
      case Direction.up:
        if (!currentCell.topWall) {
          delta = Vector2(0, -cellSize);
          canMove = true;
        }
        break;
      case Direction.down:
        if (!currentCell.bottomWall) {
          delta = Vector2(0, cellSize);
          canMove = true;
        }
        break;
      case Direction.left:
        if (!currentCell.leftWall) {
          delta = Vector2(-cellSize, 0);
          canMove = true;
        }
        break;
      case Direction.right:
        if (!currentCell.rightWall) {
          delta = Vector2(cellSize, 0);
          canMove = true;
        }
        break;
    }

    if (canMove) {
      position += delta;
    }
  }
}
