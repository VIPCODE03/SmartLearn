import 'package:flutter/material.dart';
import 'package:smart_learn/core/router/app_router_mixin.dart';
import 'package:smart_learn/features/user/presentation/screens/user_screen.dart';
import 'package:smart_learn/features/user/presentation/widgets/user_infomation_widget.dart';

abstract class IUserWidget {
  Widget userInfo(UserInfoBuilder builder);
}

abstract class IUserRouter {
  void goUserScreen(BuildContext context);
}

class _UserWidget implements IUserWidget {
  static final _UserWidget _singleton = _UserWidget._internal();
  _UserWidget._internal();
  static _UserWidget get instance => _singleton;

  @override
  Widget userInfo(UserInfoBuilder builder) => WIDUserInfo(builder: builder);
}

class _UserRouter extends IUserRouter with AppRouterMixin {
  static final _UserRouter _singleton = _UserRouter._internal();
  _UserRouter._internal();
  static _UserRouter get instance => _singleton;

  @override
  void goUserScreen(BuildContext context) {
    pushSlideRight(context, const SCRUser());
  }
}

class UserProvider {
  static final UserProvider _singleton = UserProvider._internal();
  UserProvider._internal();
  static UserProvider get instance => _singleton;

  IUserWidget get widget => _UserWidget.instance;
  IUserRouter get router => _UserRouter.instance;
}
