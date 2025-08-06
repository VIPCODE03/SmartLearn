import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:smart_learn/features/games/maze/domain/entities/maze_cell_entity.dart';

class COMMazeWorld extends Component {
  final int rows;
  final int cols;
  final double cellSize;
  final Map<String, ENTMazeCell> grid;

  COMMazeWorld({
    required this.rows,
    required this.cols,
    required this.cellSize,
    required this.grid,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        add(_MazeCellComponent(
          cell: grid['$row,$col']!,
          cellSize: cellSize,
        ));
      }
    }
  }
}

///-  Thành phần mỗi ô  --------------------------------------------------------
class _MazeCellComponent extends PositionComponent {
  final ENTMazeCell cell;
  final double cellSize;
  final Paint wallPaint = Paint()..color = Colors.black;
  final Paint backgroundPaint = Paint()..color = Colors.white;

  _MazeCellComponent({
    required this.cell,
    required this.cellSize,
  }) {
    position = Vector2(cell.col * cellSize, cell.row * cellSize);
    size = Vector2(cellSize, cellSize);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Nền trắng
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      backgroundPaint,
    );

    const double x = 0;
    const double y = 0;
    final double s = cellSize;

    // Tường trên
    if (cell.topWall) {
      canvas.drawLine(const Offset(x, y), Offset(x + s, y), wallPaint);
    }

    // Tường phải
    if (cell.rightWall) {
      canvas.drawLine(Offset(x + s, y), Offset(x + s, y + s), wallPaint);
    }

    // Tường dưới
    if (cell.bottomWall) {
      canvas.drawLine(Offset(x, y + s), Offset(x + s, y + s), wallPaint);
    }

    // Tường trái
    if (cell.leftWall) {
      canvas.drawLine(const Offset(x, y), Offset(x, y + s), wallPaint);
    }

    if(cell.isEnd) {
      const textSpan = TextSpan(
        text: 'end',
        style: TextStyle(color: Colors.black, fontSize: 10),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final offset = Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      );

      textPainter.paint(canvas, offset);
    }
  }
}

