import 'package:flutter/material.dart';
import 'package:smart_learn/core/router/app_router_mixin.dart';
import 'package:smart_learn/features/aihomework/presentation/screens/a_ai_screen.dart';
import 'package:smart_learn/features/aihomework/presentation/widgets/aihomework_history_widget.dart';

abstract class IAiHomeWorkWidget {
  Widget history(HistoryBuilder builder);
}

abstract class IAiHomeWorkRouter {
  void goAIText(BuildContext context);
  void goAICamera(BuildContext context);
}

class _AiHomeWorkWidget implements IAiHomeWorkWidget {
  static final _AiHomeWorkWidget _singleton = _AiHomeWorkWidget._internal();
  _AiHomeWorkWidget._internal();
  static _AiHomeWorkWidget get instance => _singleton;

  @override
  Widget history(HistoryBuilder builder) => WIDAIHomeWorkHistory(builder: builder);
}

class _AiHomeWorkRouter extends IAiHomeWorkRouter with AppRouterMixin {
  static final _AiHomeWorkRouter _singleton = _AiHomeWorkRouter._internal();
  _AiHomeWorkRouter._internal();
  static _AiHomeWorkRouter get instance => _singleton;

  @override
  void goAICamera(BuildContext context) {
    pushFade(context,  const SCRAIHomeWork.camera());
  }

  @override
  void goAIText(BuildContext context) {
    pushFade(context, const SCRAIHomeWork.text());
  }
}

class AiHomeWorkProvider {
  static final AiHomeWorkProvider _singleton = AiHomeWorkProvider._internal();
  AiHomeWorkProvider._internal();
  static AiHomeWorkProvider get instance => _singleton;

  IAiHomeWorkWidget get widget => _AiHomeWorkWidget.instance;
  IAiHomeWorkRouter get router => _AiHomeWorkRouter.instance;
}
