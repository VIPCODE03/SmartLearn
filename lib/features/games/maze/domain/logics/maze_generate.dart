import 'dart:math';
import 'package:smart_learn/features/games/maze/domain/entities/maze_cell_entity.dart';

enum LOGMazeGenerateLevel {
  easy, medium, hard, expert
}

class LOGMazeGenerate {
  static LOGMazeGenerate get instance => _singleton;
  static final LOGMazeGenerate _singleton = LOGMazeGenerate._private();
  LOGMazeGenerate._private() {
    maxRow = 7;
    maxColumn = 7;
  }

  final random = Random();

  late int maxRow;
  late int maxColumn;

  void setLevel(LOGMazeGenerateLevel level) {
    switch (level) {
      case LOGMazeGenerateLevel.easy:
        maxRow = random.nextInt(3) + 6;
        maxColumn = random.nextInt(3) + 6;
        break;
      case LOGMazeGenerateLevel.medium:
        maxRow = random.nextInt(3) + 9;
        maxColumn = random.nextInt(3) + 9;
        break;
      case LOGMazeGenerateLevel.hard:
        maxRow = random.nextInt(3) + 12;
        maxColumn = random.nextInt(3) + 12;
        break;
      case LOGMazeGenerateLevel.expert:
        maxRow = random.nextInt(3) + 15;
        maxColumn = random.nextInt(3) + 15;
        break;
    }
  }

  //- Hàm tạo ------------------------------------------------------------------
  Map<String, ENTMazeCell> mazeGenerate() {
    final Map<String, ENTMazeCell> mapMaze = _init();
    final Set<String> keysVisited = {};
    final startRow = random.nextInt(maxRow);
    final startColumn = random.nextInt(maxColumn);
    final startCell = mapMaze['$startRow,$startColumn']!;
    startCell.isStart = true;
    _visitCell(mapMaze, keysVisited, startCell);

    //- Tìm đường dài nhất  -
    final allPaths = findAllPathsFromRoot(mapMaze);
    final maxLen = allPaths.map((p) => p.length).reduce(max);
    final longestPaths = allPaths.where((p) => p.length == maxLen);

    for (final path in longestPaths) {
      path.last.isEnd = true;
    }

    return mapMaze;
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
        allPaths.add(List.of(path)); // Sao chép để không bị thay đổi sau này
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