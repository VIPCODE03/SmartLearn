import 'package:flutter/material.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/features/focus/presentation/widgets/export/export_manage_focus.dart';
import 'package:smart_learn/features/quiz/presentation/screens/quiz_extenal_screen.dart';

abstract class IQuizWidget {
  Widget focusManage(FocusBuilder builder);
}

abstract class IQuizRouter {
  void goQuizByFileId(BuildContext context, {required String fileId});
}

class _QuizWidget implements IQuizWidget {
  static final _QuizWidget _singleton = _QuizWidget._internal();
  _QuizWidget._internal();
  static _QuizWidget get instance => _singleton;

  @override
  Widget focusManage(FocusBuilder builder) => WIDFocusStatus(buildWidget: builder);
}

class _QuizRouter extends IQuizRouter with AppRouterMixin {
  static final _QuizRouter _singleton = _QuizRouter._internal();
  _QuizRouter._internal();
  static _QuizRouter get instance => _singleton;

  @override
  void goQuizByFileId(BuildContext context, {required String fileId}) {
    pushScale(context, SCRQuizExtenal.byFile(fileId: fileId));
  }
}

class QuizProvider {
  static final QuizProvider _singleton = QuizProvider._internal();
  QuizProvider._internal();
  static QuizProvider get instance => _singleton;

  IQuizWidget get widget => _QuizWidget.instance;
  IQuizRouter get router => _QuizRouter.instance;
}
