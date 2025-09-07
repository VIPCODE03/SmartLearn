class ENTMazeCell {
  final int row;
  final int col;
  bool topWall;
  bool rightWall;
  bool bottomWall;
  bool leftWall;
  String? questionGetKey;
  bool? isGotKey;
  bool isStart;
  bool isEnd;

  String get keyMatrix => '$row,$col';

  ENTMazeCell({
    required this.row,
    required this.col,
    this.topWall = true,
    this.rightWall = true,
    this.bottomWall = true,
    this.leftWall = true,
    this.questionGetKey,
    this.isGotKey,
    this.isStart = false,
    this.isEnd = false,
  });

  @override
  String toString() {
    return ''
        '$keyMatrix'
        '\nwall: top-$topWall, right-$rightWall, bottom-$bottomWall, left-$leftWall';
  }
}
