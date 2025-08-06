import 'package:flutter/material.dart';
import 'package:smart_learn/features/assistant/presentation/screens/assistant_screen.dart';

abstract class IAssistantWidget {
  Widget assistantView();
}

abstract class IAssistantRouter {
  void goAssistantScreen(BuildContext context);
}

class _AssistantWidget implements IAssistantWidget {
  static final _AssistantWidget _singleton = _AssistantWidget._internal();
  _AssistantWidget._internal();
  static _AssistantWidget get instance => _singleton;

  @override
  Widget assistantView() => const SCRAssistant();
}

class _AssistantRouter implements IAssistantRouter {
  static final _AssistantRouter _singleton = _AssistantRouter._internal();
  _AssistantRouter._internal();
  static _AssistantRouter get instance => _singleton;

  @override
  void goAssistantScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SCRAssistant()),
    );
  }
}

class AssistantProvider {
  static final AssistantProvider _singleton = AssistantProvider._internal();
  AssistantProvider._internal();
  static AssistantProvider get instance => _singleton;

  IAssistantWidget get widget => _AssistantWidget.instance;
  IAssistantRouter get router => _AssistantRouter.instance;
}
