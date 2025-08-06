import 'package:flutter/material.dart';
import 'package:smart_learn/features/translate/presentation/screens/translate_screen.dart';

abstract class ITranslateWidget {
  Widget translateView();
}

abstract class ITranslateRouter {
  void goTranslation(BuildContext context);
}

class _TranslateWidget implements ITranslateWidget {
  static final _TranslateWidget _singleton = _TranslateWidget._internal();
  _TranslateWidget._internal();
  static _TranslateWidget get instance => _singleton;

  @override
  Widget translateView() => const SCRTranslation();
}

class _TranslateRouter implements ITranslateRouter {
  static final _TranslateRouter _singleton = _TranslateRouter._internal();
  _TranslateRouter._internal();
  static _TranslateRouter get instance => _singleton;

  @override
  void goTranslation(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SCRTranslation()));
  }
}

class TranslateProvider {
  static final TranslateProvider _singleton = TranslateProvider._internal();
  TranslateProvider._internal();
  static TranslateProvider get instance => _singleton;

  ITranslateWidget get widget => _TranslateWidget.instance;
  ITranslateRouter get router => _TranslateRouter.instance;
}
