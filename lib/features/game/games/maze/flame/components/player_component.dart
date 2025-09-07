import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/features/game/games/maze/domain/entities/maze_cell_entity.dart';
import '../../presentation/widgets/direction_pad.dart';

class PlayerComponent extends PositionComponent {
  final double cellSize;
  final Map<String, ENTMazeCell> grid;
  final SpriteSheet spriteSheet;
  late final Sprite playerS;

  PlayerComponent({
    required this.grid,
    required this.cellSize,
    required Vector2 initPosition,
    required this.spriteSheet
  }) {
    position = initPosition;
    size = Vector2(cellSize / 2, cellSize / 2);
    playerS = spriteSheet.getSprite(7, 0);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    playerS.render(canvas,
        size: Vector2(size.x, size.y),
        position: Vector2(size.x / 2, size.y / 2)
    );
  }

  // Di chuyển theo hướng, nếu không bị tường chặn  ----------------------------
  Vector2 move(Direction direction) {
    int currentCol = (position.x / cellSize).round();
    int currentRow = (position.y / cellSize).round();
    final currentCell = grid['$currentRow,$currentCol']!;

    int newRow = currentRow;
    int newCol = currentCol;

    switch (direction) {
      case Direction.up:
        if (!currentCell.topWall) newRow--;
        break;
      case Direction.down:
        if (!currentCell.bottomWall) newRow++;
        break;
      case Direction.left:
        if (!currentCell.leftWall) newCol--;
        break;
      case Direction.right:
        if (!currentCell.rightWall) newCol++;
        break;
    }

    if ((newRow != currentRow || newCol != currentCol) && grid.containsKey('$newRow,$newCol')) {
      final targetPosition = Vector2(
        (newCol * cellSize).roundToDouble(),
        (newRow * cellSize).roundToDouble(),
      );

      add(
        MoveEffect.to(
          targetPosition,
          EffectController(duration: 0.1, curve: Curves.easeInOut),
        ),
      );
      return targetPosition;
    } else {
      logDev('⛔ Player hit a wall at: $position');
      return position;
    }
  }
}
