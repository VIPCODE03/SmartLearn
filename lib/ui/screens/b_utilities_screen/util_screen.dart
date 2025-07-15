import 'package:flutter/material.dart';
import 'package:smart_learn/ui/widgets/utilities_widget/ai_chat_widget.dart';
import 'package:smart_learn/ui/widgets/utilities_widget/translate_widget.dart';

import '../../widgets/utilities_widget/calculator_widget.dart';

enum UtilityType {
  calculator,
  assistant,
  translation,
}

class UtilScreen extends StatelessWidget {
  final UtilityType utilityType;
  final String? title;

  const UtilScreen({super.key, required this.utilityType, required this.title});

  const UtilScreen.calculator({super.key}) : utilityType = UtilityType.calculator, title = 'Máy tính';
  const UtilScreen.assistant({super.key}) : utilityType = UtilityType.assistant, title = 'Trợ lý';
  const UtilScreen.translation({super.key}) : utilityType = UtilityType.translation, title = 'Dịch thuật';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.design_services)
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (utilityType) {
      case UtilityType.calculator:
        return const WdgCalculator();
      case UtilityType.assistant:
        return const WdgChat();
      case UtilityType.translation:
        return const WdgTranslation();
    }
  }
}