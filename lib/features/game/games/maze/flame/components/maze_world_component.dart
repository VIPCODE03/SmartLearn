import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:smart_learn/features/game/games/maze/domain/entities/maze_cell_entity.dart';

class COMMazeWorld extends Component {
  final int rows;
  final int cols;
  final double cellSize;
  final Map<String, ENTMazeCell> grid;
  final SpriteSheet spriteSheet;

  late final Sprite wall;
  late final Sprite getKey;
  late final Sprite gotKey;
  late final Sprite end;
  late final List<Sprite> groundVariants;
  final Map<String, MazeKeyComponent> _keyComponents = {};

  late final Picture _mazePicture;
  late final Picture _horizontalWall;
  late final Picture _verticalWall;
  late final double _wallThickness;

  COMMazeWorld({
    required this.rows,
    required this.cols,
    required this.cellSize,
    required this.grid,
    required this.spriteSheet,
  });

  @override
  Future<void> onLoad() async {
    wall = spriteSheet.getSprite(3, 4);
    getKey = spriteSheet.getSprite(7, 5);
    gotKey = spriteSheet.getSprite(7, 6);
    end = spriteSheet.getSprite(8, 3);
    groundVariants = [
      spriteSheet.getSprite(4, 0),
      spriteSheet.getSprite(4, 1),
    ];

    final max = rows > cols ? rows : cols;
    if(max > 9 && max <= 13) {
      _wallThickness = 8.0;
    } else if(max > 13 && max <= 17) {
      _wallThickness = 6.0;
    } else if(max > 17) {
      _wallThickness = 4.0;
    }
    else {
      _wallThickness = 10.0;
    }

    _horizontalWall = _buildWallTile(Vector2(1, 0), cellSize, _wallThickness);
    _verticalWall = _buildWallTile(Vector2(0, 1), cellSize, _wallThickness);
    _mazePicture = _renderMazeToPicture();

    ///-  Nếu là khóa ------------------------------------------------------
    _keyComponents.clear();
    for (final cell in grid.values) {
      if (cell.isGotKey != null) {
        final keyComponent = MazeKeyComponent(
          cell: cell,
          spriteGotKey: gotKey,
          spriteGetKey: getKey,
          cellSize: cellSize,
        );
        _keyComponents['${cell.row},${cell.col}'] = keyComponent;
        add(keyComponent);
      }
    }
  }

  ///-  Vẽ tường, đường, điểm end ----------------------------------------------
  Picture _renderMazeToPicture() {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    final random = Random();
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final cell = grid['$row,$col']!;
        final x = col * cellSize;
        final y = row * cellSize;

        ///-  Background đường  ------------------------------------------------
        final ground = groundVariants[random.nextInt(groundVariants.length)];
        ground.render(canvas, position: Vector2(x, y), size: Vector2(cellSize, cellSize));

        ///-  Nếu là end  ------------------------------------------------------
        if (cell.isEnd) {
          end.render(canvas,
              position: Vector2(x + cellSize / 6, y + cellSize / 6),
              size: Vector2(cellSize / 1.5, cellSize / 1.5));
        }

        ///-  Vẽ các tường  ----------------------------------------------------
        if (cell.topWall) {
          canvas.save();
          canvas.translate(x, y);
          canvas.drawPicture(_horizontalWall);
          canvas.restore();
        }

        if (cell.leftWall) {
          canvas.save();
          canvas.translate(x, y);
          canvas.drawPicture(_verticalWall);
          canvas.restore();
        }

        if (cell.bottomWall) {
          canvas.save();
          canvas.translate(x, y + cellSize - _wallThickness);
          canvas.drawPicture(_horizontalWall);
          canvas.restore();
        }

        if (cell.rightWall) {
          canvas.save();
          canvas.translate(x + cellSize - _wallThickness, y);
          canvas.drawPicture(_verticalWall);
          canvas.restore();
        }
      }
    }

    return recorder.endRecording();
  }

  ///-  Tạo ảnh tường ----------------------------------------------------------
  Picture _buildWallTile(Vector2 direction, double length, double thickness) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    final tileSize = wall.srcSize;
    final tileWidth = direction.x == 1 ? tileSize.x : thickness;
    final tileHeight = direction.y == 1 ? tileSize.y : thickness;

    final count = (length / (direction.x == 1 ? tileWidth : tileHeight)).ceil();

    for (int i = 0; i < count; i++) {
      final dx = direction.x * tileWidth * i;
      final dy = direction.y * tileHeight * i;

      wall.render(
        canvas,
        position: Vector2(dx, dy),
        size: Vector2(tileWidth, tileHeight),
      );
    }

    return recorder.endRecording();
  }

  //- Cập nhật trạng thái key --------------------------------------------------
  void updateKeyAppearance(int row, int col) {
    final keyId = '$row,$col';
    _keyComponents[keyId]?.updateState();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawPicture(_mazePicture);
  }
}

///-  Các rương key ------------------------------------------------------------
class MazeKeyComponent extends SpriteComponent {
  final ENTMazeCell cell;
  final Sprite spriteGotKey;
  final Sprite spriteGetKey;

  MazeKeyComponent({
    required this.cell,
    required this.spriteGotKey,
    required this.spriteGetKey,
    required double cellSize,
  }) : super(
    size: Vector2(cellSize / 1.5, cellSize / 1.5),
    position: Vector2(
      cell.col * cellSize + cellSize / 6,
      cell.row * cellSize + cellSize / 6,
    ),
  ) {
    sprite = _resolveSprite();
  }

  Sprite _resolveSprite() {
    if (cell.isGotKey == true) return spriteGotKey;
    return spriteGetKey;
  }

  void updateState() {
    sprite = _resolveSprite();
  }
}