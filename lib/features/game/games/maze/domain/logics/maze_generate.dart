import 'dart:math';
import 'package:smart_learn/features/game/games/maze/domain/entities/maze_cell_entity.dart';

enum LOGMazeGenerateLevel {
  easy, medium, hard, expert, master
}

class Maze {
  final int maxKey;
  final int maxRow;
  final int maxColumn;
  final int rowStart;
  final int colStart;
  final int maxTime;
  Map<String, ENTMazeCell> mazeGrid;

  Maze({
    required this.maxKey,
    required this.maxRow,
    required this.maxColumn,
    required this.rowStart,
    required this.colStart,
    required this.mazeGrid,
    required this.maxTime,
  });
}

class LOGMazeGenerate {
  static LOGMazeGenerate init(double maxWitdh, double maxHeight)
  => LOGMazeGenerate._private(maxWitdh, maxHeight);
  LOGMazeGenerate._private(this.maxWitdh, this.maxHeight) {
    setLevel(LOGMazeGenerateLevel.easy);
  }

  final random = Random();

  late int maxRow;
  late int maxColumn;
  late double maxWitdh;
  late double maxHeight;
  late LOGMazeGenerateLevel level;
  late int maxKey;
  late int maxTime;

  void setLevel(LOGMazeGenerateLevel level) {
    this.level = level;
    switch (level) {
      case LOGMazeGenerateLevel.easy:
        maxColumn = random.nextInt(3) + 9;
        maxTime = 45;
        break;
      case LOGMazeGenerateLevel.medium:
        maxColumn = random.nextInt(4) + 12;
        maxTime = 60;
        break;
      case LOGMazeGenerateLevel.hard:
        maxColumn = random.nextInt(5) + 15;
        maxTime = 90;
        break;
      case LOGMazeGenerateLevel.expert:
        maxColumn = random.nextInt(6) + 18;
        maxTime = 150;
        break;
      case LOGMazeGenerateLevel.master:
        maxColumn = random.nextInt(7) + 21;
        maxTime = 200;
        break;
    }
    maxRow = (maxHeight / (maxWitdh / maxColumn)).floor();
  }

  //- Hàm tạo ------------------------------------------------------------------
  Maze mazeGenerate() {
    final Map<String, ENTMazeCell> mapMaze = _init();
    final Set<String> keysVisited = {};

    //- Cho điểm bắt đầu ngẫu nhiên -
    final int startRow = random.nextInt(maxRow);
    final int startColumn = random.nextInt(maxColumn);

    final startCell = mapMaze['$startRow,$startColumn']!;
    startCell.isStart = true;

    //- Cho điểm ra ngẫu nhiên  -
    int end = random.nextInt(4);
    if(end == 0) {
      mapMaze['0,0']!.isEnd = true;
    }
    else if(end == 1) {
      mapMaze['0,${maxColumn - 1}']!.isEnd = true;
    }
    else if(end == 2) {
      mapMaze['${maxRow - 1},0']!.isEnd = true;
    }
    else {
      mapMaze['${maxRow - 1},${maxColumn - 1}']!.isEnd = true;
    }

    //- Tạo số lượng khóa ngẫu nhiên -
    switch(level) {
      case LOGMazeGenerateLevel.easy:
        maxKey = random.nextInt(2) + 1;
        break;
      case LOGMazeGenerateLevel.medium:
        maxKey = random.nextInt(2) + 2;
        break;
      case LOGMazeGenerateLevel.hard:
        maxKey = random.nextInt(3) + 3;
        break;
      case LOGMazeGenerateLevel.expert:
        maxKey = random.nextInt(3) + 4;
        break;
      case LOGMazeGenerateLevel.master:
        maxKey = random.nextInt(4) + 5;
        break;
    }
    for(int i = 0; i < maxKey; i) {
      int row = random.nextInt(maxRow - 3) + 1;
      int col = random.nextInt(maxColumn - 3) + 1;
      var cell = mapMaze['$row,$col']!;
      if(cell.questionGetKey == null) {
        cell.questionGetKey = 'key$i';
        cell.isGotKey = false;
        i++;
      }
    }

    _visitCell(mapMaze, keysVisited, startCell);
    return Maze(maxTime: maxTime, maxKey: maxKey, rowStart: startRow, colStart: startColumn, maxRow: maxRow, maxColumn: maxColumn, mazeGrid: mapMaze);
  }

  //- Khởi tạo  ----------------------------------------------------------------
  Map<String, ENTMazeCell> _init() {
    final Map<String, ENTMazeCell> mapInit = {};
    for(int x = 0; x < maxRow; x++) {
      for(int y = 0; y < maxColumn; y++) {
        final newCell = ENTMazeCell(row: x, col: y);
        mapInit[newCell.keyMatrix] = newCell;
      }
    }
    return mapInit;
  }

  //- Thuật toán tìm kiếm theo chiều sâu DFS -----------------------------------
  /// Ý tưởng: Callback
  //- Duyệt từng ô tìm tất cả hướng đi
  ///-  Bước 1:
  //- Duyệt 1 ô cha A đệ quy với cả 4 hướng đi - nếu ô đã được duyệt thì bỏ qua
  ///-Bước 2:
  //- Chuyển qua ô con B, C... tiếp theo (vòng lặp ô cũ vẫn còn) và duyệt tiếp
  ///- Bước 3:
  //- Sau khi duyệt tìm đến điểm cuối -> vòng lặp quay lại ô cha A duyệt tiếp
  void _visitCell(Map<String, ENTMazeCell> mapMaze, Set<String> keysVisited, ENTMazeCell cell) {
    keysVisited.add(cell.keyMatrix);

    //- Đi qua 4 hướng ngẫu nhiên -
    final directions = <String>['top', 'right', 'bottom', 'left']..shuffle();
    for (final dir in directions) {
      final nextRow = dir == 'top'
          ? cell.row - 1
          : dir == 'bottom'
          ? cell.row + 1
          : cell.row;
      final nextCol = dir == 'left'
          ? cell.col - 1
          : dir == 'right'
          ? cell.col + 1
          : cell.col;

      if (nextRow < 0 || nextRow >= maxRow || nextCol < 0 || nextCol >= maxColumn) {
        continue;
      }

      final neighbor = mapMaze['$nextRow,$nextCol'];

      if (keysVisited.contains(neighbor!.keyMatrix)) {
        continue;
      }

      //- Phá tường -
      if (dir == 'top') {
        cell.topWall = false;
        neighbor.bottomWall = false;
      } else if (dir == 'right') {
        cell.rightWall = false;
        neighbor.leftWall = false;
      } else if (dir == 'bottom') {
        cell.bottomWall = false;
        neighbor.topWall = false;
      } else if (dir == 'left') {
        cell.leftWall = false;
        neighbor.rightWall = false;
      }

      //-  Duyệt ô đã đi qua -
      _visitCell(mapMaze, keysVisited, neighbor);
    }
  }

  List<List<ENTMazeCell>> findAllPathsFromRoot(Map<String, ENTMazeCell> maze) {
    final List<List<ENTMazeCell>> allPaths = [];

    // Tìm ô root
    final root = maze.values.firstWhere((cell) => cell.isStart, orElse: () => throw Exception("No root found"));

    void dfs(ENTMazeCell cell, Set<String> visited, List<ENTMazeCell> path) {
      visited.add(cell.keyMatrix);
      path.add(cell);

      // Nếu là ô cuối cùng (tức là không còn đường nào đi tiếp), lưu đường đi
      final neighbors = _getWalkableNeighbors(cell, maze);
      final unvisited = neighbors.where((n) => !visited.contains(n.keyMatrix)).toList();

      if (unvisited.isEmpty) {
        allPaths.add(List.of(path));
      } else {
        for (final neighbor in unvisited) {
          dfs(neighbor, visited, path);
        }
      }

      // Quay lui
      visited.remove(cell.keyMatrix);
      path.removeLast();
    }

    dfs(root, <String>{}, []);

    return allPaths;
  }

  List<ENTMazeCell> _getWalkableNeighbors(ENTMazeCell cell, Map<String, ENTMazeCell> maze) {
    final List<ENTMazeCell> neighbors = [];

    void tryAdd(int row, int col, bool wallFromThis, bool wallFromNeighbor) {
      final neighbor = maze['$row,$col'];
      if (neighbor != null && !wallFromThis && !wallFromNeighbor) {
        neighbors.add(neighbor);
      }
    }

    if (cell.row > 0) {
      tryAdd(cell.row - 1, cell.col, cell.topWall, maze['${cell.row - 1},${cell.col}']!.bottomWall);
    }
    if (cell.col < maxColumn - 1) {
      tryAdd(cell.row, cell.col + 1, cell.rightWall, maze['${cell.row},${cell.col + 1}']!.leftWall);
    }
    if (cell.row < maxRow - 1) {
      tryAdd(cell.row + 1, cell.col, cell.bottomWall, maze['${cell.row + 1},${cell.col}']!.topWall);
    }
    if (cell.col > 0) {
      tryAdd(cell.row, cell.col - 1, cell.leftWall, maze['${cell.row},${cell.col - 1}']!.rightWall);
    }

    return neighbors;
  }

}