import 'package:flutter/material.dart';
import 'package:smart_learn/features/calculator/presentation/screen/calculator_screen.dart';

abstract class ICalculatorWidget {
  Widget calculatorView();
}

abstract class ICalculatorRouter {
  void goCalculatorScreen(BuildContext context);
}

class _CalculatorWidget implements ICalculatorWidget {
  static final _CalculatorWidget _singleton = _CalculatorWidget._internal();
  _CalculatorWidget._internal();
  static _CalculatorWidget get instance => _CalculatorWidget._singleton;

  @override
  Widget calculatorView() => const SCRCalculator();
}

class _CalculatorRouter implements ICalculatorRouter {
  static final _CalculatorRouter _singleton = _CalculatorRouter._internal();
  _CalculatorRouter._internal();
  static _CalculatorRouter get instance => _CalculatorRouter._singleton;

  @override
  void goCalculatorScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SCRCalculator()),
    );
  }
}

class CalculatorProvider {
  static final CalculatorProvider _singleton = CalculatorProvider._internal();
  CalculatorProvider._internal();
  static CalculatorProvider get instance => _singleton;

  ICalculatorWidget get widget => _CalculatorWidget.instance;
  ICalculatorRouter get router => _CalculatorRouter.instance;
}
