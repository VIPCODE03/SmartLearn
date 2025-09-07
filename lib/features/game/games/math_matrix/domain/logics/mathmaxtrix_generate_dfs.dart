import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:smart_learn/features/game/games/math_matrix/domain/entities/matrixsquare_entity.dart';

enum LOGMathMatrixLevel {
  easy, medium, hard
}

class LOGMathMatrixGenerateDFS {
  static LOGMathMatrixGenerateDFS get instance => _singleton;
  static final LOGMathMatrixGenerateDFS _singleton = LOGMathMatrixGenerateDFS._private();
  LOGMathMatrixGenerateDFS._private() {
    _opeator = _opeatorEasy;
    _num = _numEasy;
    row = 6;
    column = 6;
  }

  final random = Random();

  List<String> get _opeatorEasy => [
    '+', '-'
  ];

  List<String> get _opeatorMedium => [
    '+', '-', '*', '/'
  ];

  int get _numEasy => 10;

  int get _numMedium => 20;

  int get _numHard => 30;

  late List<String> _opeator;
  late int _num;

  late int row;
  late int column;

  final Map<String, String> _answers = {};
  Map<String, String> get getAnswers => _answers;

  void setLevel(LOGMathMatrixLevel level) {
    switch(level) {
      case LOGMathMatrixLevel.easy:
        _opeator = _opeatorEasy;
        _num = _numEasy;
        row = random.nextInt(3) + 6;
        column = random.nextInt(3) + 6;
        break;
      case LOGMathMatrixLevel.medium:
        _opeator = _opeatorMedium;
        _num = _numMedium;
        row = random.nextInt(3) + 9;
        column = random.nextInt(3) + 9;
        break;
      case LOGMathMatrixLevel.hard:
        _opeator = _opeatorMedium;
        _num = _numHard;
        row = random.nextInt(3) + 14;
        column = random.nextInt(3) + 14;
        break;
    }
  }

  //- Hàm tạo ma trận math  ------------------------------------------------------
  Map<String, ENTMatrixSquare?> mathGenerate() {
    final Map<String, ENTMatrixSquare?> mapMathMatrix = {};
    final mapMath = _mathGenerateDFS();

    _answers.clear();
    mapMath.forEach((key, value) {
      if(value != null && value.startsWith('_')) {
        final entity = ENTMatrixSquare(
          value: value.replaceFirst('_', ''),
          type: 'num',
          isHide: true,
        );
        mapMathMatrix[key] = entity;
        _answers[key] = entity.value;
      } else if(value != null && _isNum(value)) {
        mapMathMatrix[key] = ENTMatrixSquare(
          value: value,
          type: 'num',
          isHide: false,
        );
      }
      else if(value != null && _isOperatorWithEqual(value)) {
        mapMathMatrix[key] = ENTMatrixSquare(
          value: value,
          type: 'op',
          isHide: false,
        );
      }
      else {
        mapMathMatrix[key] = null;
      }
    });

    return mapMathMatrix;
  }

  Map<String, String?> _mathGenerateDFS() {
    final Map<String, String?> mathMap = _initMap(row, column);

    for(int i = 0; i < row; i++) {
      for(int j = 0; j < column; j++) {
        if(random.nextInt(100) / 100 < (i % 2 == 0 ? 0.95 : 0.7)) {
          _findEquations(mathMap, i, j, 'horizontal');
        }
        else if(random.nextInt(100) / 100 < (i % 2 != 0 ? 0.4 : 0.2)) {
          _findEquations(mathMap, i, j, 'vertical');
        }
      }
    }

    return mathMap;
  }

//- Khởi tạo  ------------------------------------------------------------------
  Map<String, String?> _initMap(int xMax, int yMax) {
    final Map<String, String?> mapInit = {};
    for (int x = 0; x < xMax; x++) {
      for (int y = 0; y < yMax; y++) {
        mapInit['$x,$y'] = '';
      }
    }
    return mapInit;
  }

//- Các hàm tìm theo chiều  ----------------------------------------------------
  void _findEquations(Map<String, String?> mathMap, int startRow, int startCol, String direction) {
    final List<int> indexs = [4, -4];

    for(var index in indexs) {
      if(direction == 'horizontal') {
        final resultRow = _findRow(mathMap, startRow, startCol, startCol + index);
        if (resultRow != null) {
          _setRowEquation(mathMap, startRow, index > 0 ? startCol : startCol - 4, resultRow);

          List<int> numIndex = [startCol, startCol + 2, startCol + 4];
          for (var index in numIndex) {
            _findEquations(mathMap, startRow, index, 'vertical');
          }
        }
      }
      else {
        final resultCol = _findCol(mathMap, startRow, startCol, startRow + index);
        if (resultCol != null) {
          _setColumnEquation(mathMap, index > 0 ? startRow : startRow - 4, startCol, resultCol);

          List<int> numIndex = [startRow, startRow + 2, startRow + 4];
          for (var index in numIndex) {
            _findEquations(mathMap, index, startCol, 'horizontal');
          }
        }
      }
    }
  }

  List<String>? _findRow(Map<String, String?> mapMath, int fromRow, int fromCol, int toCol) {
    if(fromRow < 0 || fromCol < 0 || toCol < 0
        || fromCol > column - 1 || toCol > column - 1 || fromRow > row - 1
    ) {
      return null;
    }

    final int x = fromRow;
    final int startY = fromCol < toCol ? fromCol : toCol;
    final int endY = fromCol < toCol ? toCol : fromCol;

    var pre = mapMath['$fromRow,${startY - 1}'];
    var next = mapMath['$fromRow,${endY + 1}'];
    if((pre != null && pre != '') || (next != null && next != '')) {
      return null;
    }

    //- Kiểm tra xem có đủ 5 ô hợp lệ không  -
    bool isFind = true;
    for(int k = startY; k <= endY; k++) {
      if(mapMath['$x,$k'] == null) {
        isFind = false;
        break;
      }
    }

    //- Nếu hợp lệ  -
    if(isFind) {
      var o1 = mapMath['$x,$startY'];
      var o2 = mapMath['$x,${startY+1}'];
      var o3 = mapMath['$x,${startY+2}'];
      var o4 = mapMath['$x,${startY+3}'];
      var o5 = mapMath['$x,${startY+4}'];
      final list = _findEquation(o1!, o2!, o3!, o4!, o5!);
      if(list != null) {
        return list;
      }
    }
    return null;
  }

  List<String>? _findCol(Map<String, String?> mapMath, int fromRow, int fromCol, int toRow) {
    if(fromRow < 0 || fromCol < 0 || toRow < 0
        || fromRow > row - 1 || fromCol > column - 1 || toRow > row - 1
    ) {
      return null;
    }

    final int y = fromCol;
    final int startX = fromRow < toRow ? fromRow : toRow;
    final int endX = fromRow < toRow ? toRow : fromRow;

    var pre = mapMath['${startX - 1},$y'];
    var next = mapMath['${endX + 1},$y'];
    if((pre != null && pre != '') || (next != null && next != '')) {
      return null;
    }

    //- Kiểm tra xem có đủ 5 ô hợp lệ không  -
    bool isFind = true;
    for(int k = startX; k <= endX; k++) {
      if(mapMath['$k,$y'] == null) {
        isFind = false;
        break;
      }
    }

    //- Nếu hợp lệ  -
    if(isFind) {
      var o1 = mapMath['$startX,$y'];
      var o2 = mapMath['${startX+1},$y'];
      var o3 = mapMath['${startX+2},$y'];
      var o4 = mapMath['${startX+3},$y'];
      var o5 = mapMath['${startX+4},$y'];
      final list = _findEquation(o1!, o2!, o3!, o4!, o5!);
      if(list != null) {
        return list;
      }
    }
    return null;
  }

//- Tìm phép tính phù hợp ------------------------------------------------------
  List<String>? _findEquation(String o1, String o2, String o3, String o4, String o5) {
    if((_isNum(o1) || o1 == '')
        && (_isOperatorWithEqual(o2) || o2 == '')
        && (_isNum(o3) || o3 == '')
        && (_isOperatorWithEqual(o4) || o4 == '')
        && (_isNum(o5) || o5 == ''))
    {
      /// 5 ẩn
      //- ? ? ? ? ?
      if(o1 == '' && o2 == '' && o3 == '' && o4 == '' && o5 == '') {
        _log('? ? ? ? ?', 'info');
        var a = _getNum();
        var b = _getNum();
        var op = _getOpeator();
        var c = _calculate(a, b, op);
        if(c != null) {
          _log('$a $op $b = $c', 'result');
          return [a, op, b, '=', c];
        }
      }

      //- Thuận chiều ----------------

      ///1-ẩn
      //- ? op B = C
      else if (o1 == '' && _isBasicOperator(o2) && _isNum(o3) && o4 == '=' && _isNum(o5)) {
        _log('? op B = C', 'info');
        var o1 = _findX(o5, o3, o2);
        if(o1 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- A op ? = C
      else if (_isNum(o1) && _isBasicOperator(o2) && o3 == '' && o4 == '=' && _isNum(o5)) {
        _log('A op ? = C', 'info');
        var o3 = _findX(o5, o1, o2);
        if(o3 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- A op B = ?
      else if (_isNum(o1) && _isBasicOperator(o2) && _isNum(o3) && o4 == '=' && o5 == '') {
        _log('A op B = ?', 'info');
        var o5 = _calculate(o1, o3, o2);
        if(o5 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- A ? B = C
      else if (_isNum(o1) && o2 == '' && _isNum(o3) && o4 == '=' && _isNum(o5)) {
        _log('A ? B = C', 'info');
        return null;
      }

      //- A op B ? C
      else if (_isNum(o1) && _isBasicOperator(o2) && _isNum(o3) && o4 == '' && _isNum(o5)) {
        _log('A op B ? C', 'info');
        var o4 = '=';
        var c = _calculate(o1, o3, o2);
        if(c == o5) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      ///2-ẩn
      //- ? ? B = C
      else if (o1 == '' && o2 == '' && _isNum(o3) && o4 == '=' && _isNum(o5)) {
        _log('? ? B = C', 'info');
        var o2 = _getOpeator();
        var o1 = _findX(o5, o3, o2);
        if(o1 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- ? op ? = C
      else if (o1 == '' && _isBasicOperator(o2) && o3 == '' && o4 == '' && _isNum(o5)) {
        _log('? op ? = C', 'info');
        var o3 = _getNum();
        var o1 = _findX(o5, o3, o2);
        if(o1 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- ? op B ? C
      else if (o1 == '' && _isBasicOperator(o2) && _isNum(o3) && o4 == '' && _isNum(o5)) {
        _log('? op B ? C', 'info');
        return null;
      }

      //- ? op B = ?
      else if (o1 == '' && _isBasicOperator(o2) && _isNum(o3) && o4 == '=' && o5 == '') {
        _log('? op B = ?', 'info');
        return null;
      }

      //- A ? ? = C
      else if (_isNum(o1) && o2 == '' && o3 == '' && o4 == '=' && _isNum(o5)) {
        _log('A ? ? = C', 'info');
        var o2 = _getOpeator(ignore: true);
        var o3 = _findX(o5, o1, o2);
        if(o3 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- A ? B ? C
      else if (_isNum(o1) && o2 == '' && _isNum(o3) && o4 == '' && _isNum(o5)) {
        _log('A ? B ? C', 'info');
        var o4 = '=';
        var o2 = _findOperator(o1, o3, o5);
        if(o2 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- A ? B = ?
      else if (_isNum(o1) && o2 == '' && _isNum(o3) && o4 == '=' && o5 == '') {
        _log('A ? B = ?', 'info');
        var o2 = _getOpeator();
        var o5 = _calculate(o1, o3, o2);
        if(o5 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- A op ? ? C
      else if (_isNum(o1) && _isBasicOperator(o2) && o3 == '' && o4 == '' && _isNum(o5)) {
        _log('A op ? ? C', 'info');
        var o4 = '=';
        var o3 = _findX(o5, o1, o2);
        if(o3 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- A op ? = ?
      else if (_isNum(o1) && _isBasicOperator(o2) && o3 == '' && o4 == '=' && o5 == '') {
        _log('A op ? = ?', 'info');
        var o3 = _getNum();
        var o5 = _calculate(o1, o3, o2);
        if(o5 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      /// 3 ẩn
      //- ? ? ? = C
      else if (o1 == '' && o2 == '' && o3 == '' && o4 == '=' && _isNum(o5)) {
        _log('? ? ? = C', 'info');
        var o3 = _getNum();
        var o2 = _getOpeator();
        var o1 = _findX(o5, o3, o2);
        if(o1 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- ? ? B ? C
      else if (o1 == '' && o2 == '' && _isNum(o3) && o4 == '' && _isNum(o5)) {
        _log('? ? B ? C', 'info');
        var o2 = _getOpeator();
        var o4 = '=';
        var o1 = _findX(o5, o3, o2);
        if(o1 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- ? ? B = ?
      else if (o1 == '' && o2 == '' && _isNum(o3) && o4 == '=' && o5 == '') {
        _log('? ? B = ?', 'info');
        var o1 = _getNum();
        var o2 = _getOpeator();
        var o5 = _calculate(o1, o3, o2);
        if(o5 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- ? op ? ? C
      else if (o1 == '' && _isBasicOperator(o2) && o3 == '' && o4 == '' && _isNum(o5)) {
        _log('? op ? ? C', 'info');
        return null;
      }

      //- ? op B ? ?
      else if (o1 == '' && _isBasicOperator(o2) && _isNum(o3) && o4 == '' && o5 == '') {
        _log('? op B ? ?', 'info');
        var o1 = _getNum();
        var o4 = '=';
        var o5 = _calculate(o1, o3, o2);
        if(o5 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- A ? ? ? C
      else if (_isNum(o1) && o2 == '' && o3 == '' && o4 == '' && _isNum(o5)) {
        _log('A ? ? ? C', 'info');
        var o4 = '=';
        var o2 = _getOpeator(ignore: true);
        var o3 = _findX(o5, o1, o2);
        if(o3 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- A ? ? = ?
      else if (_isNum(o1) && o2 == '' && o3 == '' && o4 == '=' && o5 == '') {
        _log('A ? ? = ?', 'info');
        var o2 = _getOpeator();
        var o3 = _getNum();
        var o5 = _calculate(o1, o3, o2);
        if(o5 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- A ? B ? ?
      else if (_isNum(o1) && o2 == '' && _isNum(o3) && o4 == '' && o5 == '') {
        _log('A ? B ? ?', 'info');
        var o4 = '=';
        var o2 = _getOpeator();
        var o5 = _calculate(o1, o3, o2);
        if(o5 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      ///4 ẩn
      //- A ? ? ? ?
      else if (_isNum(o1) && o2 == '' && o3 == '' && o4 == '' && o5 == '') {
        _log('A ? ? ? ?', 'info');
        var o2 = _getOpeator(ignore: true);
        var o3 = _getNum();
        var o4 = '=';
        var o5 = _calculate(o1, o3, o2);
        if(o5 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- ? ? B ? ?
      else if (o1 == '' && o2 == '' && _isNum(o3) && o4 == '' && o5 == '') {
        _log('? ? B ? ?', 'info');
        var o1 = _getNum();
        var o2 = _getOpeator();
        var o4 = '=';
        var o5 = _calculate(o1, o3, o2);
        if(o5 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- ? ? ? ? C
      else if (o1 == '' && o2 == '' && o3 == '' && o4 == '' && _isNum(o5)) {
        _log('? ? ? ? C', 'info');
        var o3 = _getNum();
        var o2 = _getOpeator();
        var o4 = '=';
        var o1 = _findX(o5, o3, o2);
        if(o1 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }
    }

    return null;
  }

  //- Hàm set giá trị ----------------------------------------------------------
  void _setRowEquation(Map<String, String?> mathMap, int startRow, int startCol, List<String> equation) {
    mathMap['$startRow,$startCol'] = equation[0];
    mathMap['$startRow,${startCol + 1}'] = equation[1];
    mathMap['$startRow,${startCol + 2}'] = equation[2];
    mathMap['$startRow,${startCol + 3}'] = equation[3];
    mathMap['$startRow,${startCol + 4}'] = equation[4];

    //- Tạo khoảng cách -

    //- Num 1
    if(mathMap['$startRow,${startCol - 1}'] == '') {
      mathMap['$startRow,${startCol - 1}'] = null;
    }

    //- Num 3
    if(mathMap['$startRow,${startCol + 5}'] == '') {
      mathMap['$startRow,${startCol + 5}'] = null;
    }

    //- Operator
    if(mathMap['${startRow + 1},${startCol + 1}'] == '') {
      mathMap['${startRow + 1},${startCol + 1}'] = null;
    }
    if(mathMap['${startRow - 1},${startCol + 1}'] == '') {
      mathMap['${startRow - 1},${startCol + 1}'] = null;
    }
    if(mathMap['${startRow + 1},${startCol + 3}'] == '') {
      mathMap['${startRow + 1},${startCol + 3}'] = null;
    }
    if(mathMap['${startRow - 1},${startCol + 3}'] == '') {
      mathMap['${startRow - 1},${startCol + 3}'] = null;
    }

    //- Tạo số ẩn -
    int randomHide = random.nextInt(3);
    if(randomHide == 0) {
      mathMap['$startRow,$startCol'] = '_${mathMap['$startRow,$startCol']}';
    } else if(randomHide == 1) {
      mathMap['$startRow,${startCol + 2}'] = '_${mathMap['$startRow,${startCol + 2}']}';
    } else {
      mathMap['$startRow,${startCol + 4}'] = '_${mathMap['$startRow,${startCol + 4}']}';
    }
  }

  void _setColumnEquation(Map<String, String?> mathMap, int startRow, int startCol, List<String> equation) {
    mathMap['$startRow,$startCol'] = equation[0];
    mathMap['${startRow + 1},$startCol'] = equation[1];
    mathMap['${startRow + 2},$startCol'] = equation[2];
    mathMap['${startRow + 3},$startCol'] = equation[3];
    mathMap['${startRow + 4},$startCol'] = equation[4];

    //- Tạo khoảng cách -

    //- Num 1
    if(mathMap['${startRow - 1},$startCol'] == '') {
      mathMap['${startRow - 1},$startCol'] = null;
    }

    //- Num 3
    if(mathMap['${startRow + 5},$startCol'] == '') {
      mathMap['${startRow + 5},$startCol'] = null;
    }

    //- Operator
    if(mathMap['${startRow + 1},${startCol + 1}'] == '') {
      mathMap['${startRow + 1},${startCol + 1}'] = null;
    }
    if(mathMap['${startRow + 1},${startCol - 1}'] == '') {
      mathMap['${startRow + 1},${startCol - 1}'] = null;
    }
    if(mathMap['${startRow + 3},${startCol + 1}'] == '') {
      mathMap['${startRow + 3},${startCol + 1}'] = null;
    }
    if(mathMap['${startRow + 3},${startCol - 1}'] == '') {
      mathMap['${startRow + 3},${startCol - 1}'] = null;
    }

    //- Tạo ẩn  -
    if(random.nextInt(100) / 100 > 0.8) {
      mathMap['$startRow,$startCol'] = '_${mathMap['$startRow,$startCol']}';
    }
    if(random.nextInt(100) / 100 > 0.4) {
      mathMap['${startRow + 2},$startCol'] = '_${mathMap['${startRow + 2},$startCol']}';
    }
    if(random.nextInt(100) / 100 > 0.6) {
      mathMap['${startRow + 4},$startCol'] = '_${mathMap['${startRow + 4},$startCol']}';
    }
  }


//- Các hàm check --------------------------------------------------------------
  bool _isOperatorWithEqual(String op) {
    return op == '+' || op == '-' || op == '*' || op == '/' || op == '=';
  }

  bool _isBasicOperator(String op) {
    return op == '+' || op == '-' || op == '*' || op == '/';
  }

  bool _isNum(String num) {
    try {
      int.parse(num);
      return true;
    } catch (e) {
      return false;
    }
  }

//- Các hàm tính toán tìm giá trị ----------------------------------------------
  String? _calculate(String a, String b, String operator) {
    int? aNum = int.tryParse(a);
    int? bNum = int.tryParse(b);

    if (aNum == null || bNum == null) return null;

    switch (operator) {
      case '+':
        return (aNum + bNum).toString();
      case '-':
        return (aNum - bNum).toString();
      case '*':
        return (aNum * bNum).toString();
      case '/':
        if (bNum == 0 || aNum % bNum != 0) return null;
        return (aNum ~/ bNum).toString();
      default:
        return null;
    }
  }

  String? _findX(String z, String y, String opeator) {
    int? zNum = int.tryParse(z);
    int? yNum = int.tryParse(y);
    if (zNum == null || yNum == null) return null;
    switch (opeator) {
      case '+':
        return (zNum - yNum).toString();
      case '-':
        return (zNum + yNum).toString();
      case '*':
        if (zNum == 0 || zNum % yNum != 0) return null;
        return (zNum ~/ yNum).toString();
      case '/':
        return (zNum * yNum).toString();
      default:
        return null;
    }
  }

  String? _findOperator(String x, String y, String z) {
    int? xNum = int.tryParse(x);
    int? yNum = int.tryParse(y);
    int? zNum = int.tryParse(z);

    if (xNum == null || yNum == null || zNum == null) return null;

    if (xNum + yNum == zNum) return '+';
    if (xNum - yNum == zNum) return '-';
    if (xNum * yNum == zNum) return '*';
    if (yNum != 0 && xNum ~/ yNum == zNum && xNum % yNum == 0) return '/';

    return null;
  }

//- Các hàm tạo ngẫu nhiên  ----------------------------------------------------
  String _getOpeator({bool? ignore}) {
    if(ignore != null) {
      final opeator = _opeator.where((element) => element != '-' && element != '/').toList();
      return opeator[random.nextInt(opeator.length)];
    }
    return _opeator[random.nextInt(_opeator.length)];
  }

  String _getNum() {
    return '${random.nextInt(_num) + 1}';
  }
}

//- Hàm log theo dõi tiến trình ------------------------------------------------
void _log(String text, [String type = 'info']) {
  final Map<String, String> iconMap = {
    'info': 'ℹ️',
    'check': '✅',
    'warn': '⚠️',
    'error': '❌',
    'calc': '🧮',
    'step': '➡️',
    'result': '🎯',
    'debug': '🐞',
  };

  final icon = iconMap[type] ?? '';
  if(kDebugMode) {
    print('$icon $text');
  }
}
