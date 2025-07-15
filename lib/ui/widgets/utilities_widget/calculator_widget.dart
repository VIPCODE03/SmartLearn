import 'package:flutter/material.dart';
import 'package:flutter_awesome_calculator/flutter_awesome_calculator.dart';
import '../../../global.dart';

class WdgCalculator extends StatelessWidget {
  const WdgCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FlutterAwesomeCalculator(
        context: context,
        digitsButtonColor: Colors.white,
        backgroundColor: Colors.transparent,
        expressionAnswerColor: Colors.black,
        showAnswerField: true,
        fractionDigits: 1,
        buttonRadius: 8,
        clearButtonColor: Colors.red,
        operatorsButtonColor: primaryColor(context),
        onChanged: (ans,expression){

        },
      ),
    );
  }
}