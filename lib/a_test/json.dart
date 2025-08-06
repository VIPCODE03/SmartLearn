import 'dart:math';

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
  print('$icon $text');
}

Stream<Map<String, String?>> mathGenerate(int row, int col) async* {
  print('------------------------------------------------');
  final int x = row;
  final int y = col;
  final Map<String, String?> mapMath = _initMap(x, y);
  final random = Random();

  for (int i = 0; i < x; i++) {
    for (int j = 0; j < y; j++) {
      if (random.nextInt(100) / 100 < 0.8) {

        // Quét ngang
        /// Điều kiện
        // Nếu như đủ không gian và trái và phải nó là rỗng
        if (y - j > 5
            && (mapMath['$i,${j+5}'] == '' || mapMath['$i,${j+5}'] == null)
            && (mapMath['$i,${j-1}'] == '' || mapMath['$i,${j-1}'] == null)
        ) {
          final list = _findRow(mapMath, i, j, x, y);
          if (list != null) {
            await Future.delayed(Duration(seconds: 2));
            if(mapMath['$i,${j - 1}'] == '') {
              mapMath['$i,${j - 1}'] = null;
            }
            mapMath['$i,$j'] = list[0];

            mapMath['$i,${j + 1}'] = list[1];
            if(mapMath['${i + 1},${j + 1}'] == '') {
              mapMath['${i + 1},${j + 1}'] = null;
            }

            mapMath['$i,${j + 2}'] = list[2];

            mapMath['$i,${j + 3}'] = list[3];
            if(mapMath['${i + 1},${j + 3}'] == '') {
              mapMath['${i + 1},${j + 3}'] = null;
            }

            mapMath['$i,${j + 4}'] = list[4];
            //- Nếu dưới là rỗng
            if(mapMath['${i + 1},${j + 5}'] == '') {
              mapMath['$i,${j + 5}'] = null;
            }

            final List<int> numIndex = [j, j + 2, j + 4];
            for (var index in numIndex) {
              if (random.nextBool()) {
                final list1 = _findCol(mapMath, i, index, x, y);
                if (list1 != null) {
                  await Future.delayed(Duration(seconds: 1));
                  mapMath['${i + 1},$index'] = list1[1];
                  mapMath['${i + 2},$index'] = list1[2];
                  mapMath['${i + 3},$index'] = list1[3];
                  mapMath['${i + 4},$index'] = list1[4];
                  mapMath['${i + 5},$index'] = null;
                } else {
                  if(mapMath['${i + 1},$index'] == '') {
                    mapMath['${i + 1},$index'] = null;
                  }
                }
              } else if(mapMath['${i + 1},$index'] == ''){
                mapMath['${i + 1},$index'] = null;
              }
            }

            yield Map.from(mapMath);
          }
        }

        // Quét dọc
        /// Điều kiện
        // Nếu như bên trái và phải là rỗng
        else if (random.nextBool()
            && (mapMath['$i,${j+1}'] == '' || mapMath['$i,${j+1}'] == null)
            && (mapMath['$i,${j-1}'] == '' || mapMath['$i,${j-1}'] == null))
        {
          final list = _findCol(mapMath, i, j, x, y);
          if (list != null) {
            await Future.delayed(Duration(seconds: 1));
            if(mapMath['$i,${j - 1}'] == '') {
              mapMath['$i,${j - 1}'] = null;
            }
            if(mapMath['$i,${j + 1}'] == '') {
              mapMath['$i,${j + 1}'] = null;
            }
            mapMath['$i,$j'] = list[0];
            mapMath['${i + 1},$j'] = list[1];
            mapMath['${i + 2},$j'] = list[2];
            mapMath['${i + 3},$j'] = list[3];
            mapMath['${i + 4},$j'] = list[4];

            if(mapMath['${i + 5},$j'] == '') {
              mapMath['${i + 5},$j'] = null;
            }

            yield Map.from(mapMath);
          }
        }
      }
    }
  }
}

List<String>? _findRow(Map<String, String?> mapMath, int i, int j, int x, int y) {
  print('$i $j -> $i ${j+5}');
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
  print('$i $j -> ${i+5} $j');
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
    //------------------------------

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
    //-------------------------------

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

String _getOpeator() {
  final random = Random();
  final operators = ['+', '-', '*', '/'];
  return operators[random.nextInt(operators.length)];
}

String _getNum() {
  final random = Random();
  return '${random.nextInt(10) + 1}';
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