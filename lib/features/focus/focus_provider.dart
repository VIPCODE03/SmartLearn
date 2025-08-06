import 'package:flutter/material.dart';
import 'package:smart_learn/features/focus/presentation/widgets/export/export_manage_focus.dart';

abstract class IFocusWidget {
  Widget focusManage(FocusBuilder builder);
}

abstract class IFocusRouter {
}

class _FocusWidget implements IFocusWidget {
  static final _FocusWidget _singleton = _FocusWidget._internal();
  _FocusWidget._internal();
  static _FocusWidget get instance => _singleton;

  @override
  Widget focusManage(FocusBuilder builder) => WIDFocusStatus(buildWidget: builder);
}

class _FocusRouter implements IFocusRouter {
  static final _FocusRouter _singleton = _FocusRouter._internal();
  _FocusRouter._internal();
  static _FocusRouter get instance => _singleton;

}

class FocusProvider {
  static final FocusProvider _singleton = FocusProvider._internal();
  FocusProvider._internal();
  static FocusProvider get instance => _singleton;

  IFocusWidget get widget => _FocusWidget.instance;
  IFocusRouter get router => _FocusRouter.instance;
}
