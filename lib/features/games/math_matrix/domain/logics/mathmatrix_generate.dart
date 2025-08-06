import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:smart_learn/features/games/math_matrix/domain/entities/matrixsquare_entity.dart';

enum LOGMathMatrixLevel {
  easy, medium, hard
}

class LOGMathMatrixGenerate {
  static LOGMathMatrixGenerate get instance => _singleton;
  static final LOGMathMatrixGenerate _singleton = LOGMathMatrixGenerate._private();
  LOGMathMatrixGenerate._private() {
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
        row = random.nextInt(3) + 12;
        column = random.nextInt(3) + 12;
        break;
    }
  }

  //- Hàm tạo ma trận math  ------------------------------------------------------
  Map<String, ENTMatrixSquare?> mathGenerate() {
    final Map<String, ENTMatrixSquare?> mapMathMatrix = {};
    final mapMath = _mathGenerate();

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

  Map<String, String?> _mathGenerate() {
    final int x = row;
    final int y = column;
    final Map<String, String?> mapMath = _initMap(x, y);
    for (int i = 0; i < x; i++) {
      for (int j = 0; j < y; j++) {
        if (random.nextInt(100) / 100 < (i % 2 == 0 ? 0.95 : 0.7)) {

          // Quét ngang ----------------------------------------------------------
          /// Điều kiện
          // Nếu như đủ không gian và trái và phải nó là rỗng
          if (y - j > 5
              && (mapMath['$i,${j+5}'] == '' || mapMath['$i,${j+5}'] == null)
              && (mapMath['$i,${j-1}'] == '' || mapMath['$i,${j-1}'] == null)
          ) {
            //-> Bước 1: Tạo hàng ngang ------------------------------------------
            final list = _findRow(mapMath, i, j, x, y);
            if (list != null) {
              mapMath['$i,$j'] = list[0];       //-> num
              mapMath['$i,${j + 1}'] = list[1]; //-> op
              mapMath['$i,${j + 2}'] = list[2]; //-> num
              mapMath['$i,${j + 3}'] = list[3]; //-> op
              mapMath['$i,${j + 4}'] = list[4]; //-> num

              //- Tạo khoảng cách -
              if(mapMath['$i,${j - 1}'] == '') {
                mapMath['$i,${j - 1}'] = null;
              }
              if(mapMath['${i + 1},${j + 1}'] == '') {
                mapMath['${i + 1},${j + 1}'] = null;
              }
              if(mapMath['${i + 1},${j + 3}'] == '') {
                mapMath['${i + 1},${j + 3}'] = null;
              }
              if(mapMath['${i + 1},${j + 5}'] == '') {
                mapMath['$i,${j + 5}'] = null;
              }

              //- Tạo số ẩn
              int randomHide = random.nextInt(3);
              if(randomHide == 0) {
                mapMath['$i,$j'] = '_${mapMath['$i,$j']}';
              } else if(randomHide == 1) {
                mapMath['$i,${j + 2}'] = '_${mapMath['$i,${j + 2}']}';
              } else {
                mapMath['$i,${j + 4}'] = '_${mapMath['$i,${j + 4}']}';
              }

              //-> Bước 2: Tạo các hàng dọc tại các số ---------------------------
              /// Logic
              //- Trong 3 số tạo ngẫu nhiên cột phép tính từ 3 số nếu không set cột dưới là null
              final List<int> numIndex = [j, j + 2, j + 4];
              for (var index in numIndex) {
                if (random.nextInt(100) / 100 > (i % 2 == 0 ? 0.15 : 0.4)) {
                  final list1 = _findCol(mapMath, i, index, x, y);
                  if (list1 != null) {
                    mapMath['${i + 1},$index'] = list1[1]; //-> op
                    mapMath['${i + 2},$index'] = list1[2]; //-> num
                    mapMath['${i + 3},$index'] = list1[3]; //-> op
                    mapMath['${i + 4},$index'] = list1[4]; //-> num

                    //- Tạo khoảng cách -
                    mapMath['${i + 5},$index'] = null;

                    //- Tạo số ẩn -
                    int randomHide = random.nextInt(3);
                    if(randomHide == 0) {
                      mapMath['${i + 0},$index'] = '_${mapMath['${i + 0},$index']}';
                    }
                    else if(randomHide == 1) {
                      mapMath['${i + 2},$index'] = '_${mapMath['${i + 2},$index']}';
                    } else {
                      mapMath['${i + 4},$index'] = '_${mapMath['${i + 4},$index']}';
                    }

                  } else {
                    if(mapMath['${i + 1},$index'] == '') {
                      mapMath['${i + 1},$index'] = null;
                    }
                  }
                } else if(mapMath['${i + 1},$index'] == ''){
                  mapMath['${i + 1},$index'] = null;
                }
              }
            }
          }

          // Quét dọc-------------------------------------------------------------
          /// Điều kiện
          // Nếu như bên trái và phải là rỗng
          else if (random.nextInt(100) / 100 < (i % 2 != 0 ? 0.4 : 0.2)
              && (mapMath['$i,${j+1}'] == '' || mapMath['$i,${j+1}'] == null)
              && (mapMath['$i,${j-1}'] == '' || mapMath['$i,${j-1}'] == null))
          {
            //-> Tạo hàng dọc ----------------------------------------------------
            final list = _findCol(mapMath, i, j, x, y);
            if (list != null) {
              mapMath['$i,$j'] = list[0]; //-> num
              mapMath['${i + 1},$j'] = list[1]; //-> op
              mapMath['${i + 2},$j'] = list[2]; //-> num
              mapMath['${i + 3},$j'] = list[3]; //-> op
              mapMath['${i + 4},$j'] = list[4]; //-> num

              //- Tạo khoảng cách -
              if(mapMath['$i,${j - 1}'] == '') {
                mapMath['$i,${j - 1}'] = null;
              }
              if(mapMath['$i,${j + 1}'] == '') {
                mapMath['$i,${j + 1}'] = null;
              }
              if(mapMath['${i + 5},$j'] == '') {
                mapMath['${i + 5},$j'] = null;
              }

              //- Tạo số ẩn -
              int randomHide = random.nextInt(3);
              if(randomHide == 0) {
                mapMath['$i,$j'] = '_${mapMath['$i,$j']}';
              } else if(randomHide == 1) {
                mapMath['${i + 2},$j'] = '_${mapMath['${i + 2},$j']}';
              }
              else {
                mapMath['${i + 4},$j'] = '_${mapMath['${i + 4},$j']}';
              }
            }
          }
        }
      }
    }

    return mapMath;
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
  List<String>? _findRow(Map<String, String?> mapMath, int i, int j, int x, int y) {
    if(y - j < 5) {
      return null;
    }

    //- Kiểm tra xem có đủ 5 ô hợp lệ không  -
    bool isFind = true;
    for(int k = j; k < j+5; k++) {
      if(mapMath['$i,$k'] == null) {
        isFind = false;
        break;
      }
    }

    //- Nếu hợp lệ  -
    if(isFind) {
      var o1 = mapMath['$i,$j'];
      var o2 = mapMath['$i,${j+1}'];
      var o3 = mapMath['$i,${j+2}'];
      var o4 = mapMath['$i,${j+3}'];
      var o5 = mapMath['$i,${j+4}'];
      final list = _findEquation(o1!, o2!, o3!, o4!, o5!);
      if(list != null) {
        return list;
      }
    }
    return null;
  }

  List<String>? _findCol(Map<String, String?> mapMath, int i, int j, int x, int y) {
    if(x - i < 5) {
      return null;
    }

    //- Kiểm tra xem có đủ 5 ô hợp lệ không  -
    bool isFind = true;
    for(int k = i; k < i+5; k++) {
      if(mapMath['$k,$j'] == null) {
        isFind = false;
        break;
      }
    }

    //- Nếu hợp lệ  -
    if(isFind) {
      var o1 = mapMath['$i,$j'];
      var o2 = mapMath['${i+1},$j'];
      var o3 = mapMath['${i+2},$j'];
      var o4 = mapMath['${i+3},$j'];
      var o5 = mapMath['${i+4},$j'];
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
        var o1 = _getNum();
        var o3 = _findX(o5, o1, o2);
        if(o3 != null) {
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
        var o2 = _getOpeator();
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
        var o1 = _getNum();
        var o2 = _getOpeator();
        var o3 = _findX(o5, o1, o2);
        if(o3 != null) {
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
        var o2 = _getOpeator();
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

      //- A op ? ? ?
      else if (_isNum(o1) && _isBasicOperator(o2) && o3 == '' && o4 == '' && o5 == '') {
        _log('A op ? ? ?', 'info');
        var o4 = '=';
        var o3 = _getNum();
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
        var o2 = _getOpeator();
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
        var o1 = _getNum();
        var o2 = _getOpeator();
        var o4 = '=';
        var o3 = _findX(o5, o1, o2);
        if(o3 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- Ngược chiều -----------------

      ///1 ẩn
      //- ? = A + B
      else if (o1 == '' && o2 == '=' && _isNum(o3) && _isBasicOperator(o4) && _isNum(o5)) {
        _log('? = A + B', 'info');
        var o1 = _calculate(o3, o5, o4);
        if(o1 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- C = ? op B
      else if (_isNum(o1) && o2 == '=' && o3 == '' && _isOperatorWithEqual(o4) && _isNum(o5)) {
        _log('C = ? op B', 'info');
        var o3 = _findX(o1, o5, o4);
        if(o3 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- C = A op ?
      else if (_isNum(o1) && o2 == '=' && _isNum(o3) && o4 == '' && o5 == '') {
        _log('C = A op ?', 'info');
        var o5 = _findX(o1, o3, o4);
        if(o5 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      ///2 ẩn
      //- C = ? op ?
      else if (_isNum(o1) && o2 == '=' && o3 == '' && _isOperatorWithEqual(o4) && o5 == '') {
        _log('C = ? op ?', 'info');
        var o3 = _getNum();
        var o5 = _findX(o1, o3, o4);
        if(o5 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- ? = ? op B
      else if (o1 == '' && o2 == '=' && o3 == '' && _isOperatorWithEqual(o4) && _isNum(o5)) {
        _log('? = ? op B', 'info');
        var o3 = _getNum();
        var o1 = _calculate(o3, o5, o4);
        if(o1 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      //- ? = A op ?
      else if (_isNum(o1) && o2 == '=' && o3 == '' && _isOperatorWithEqual(o4) && o5 == '') {
        _log('? = A op ?', 'info');
        var o5 = _getNum();
        var o1 = _calculate(o3, o5, o4);
        if(o1 != null) {
          _log('$o1 $o2 $o3 $o4 $o5', 'result');
          return [o1, o2, o3, o4, o5];
        }
      }

      ///3 ẩn
      //- ? = ? op ?
    }

    return null;
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
  String _getOpeator() {
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
