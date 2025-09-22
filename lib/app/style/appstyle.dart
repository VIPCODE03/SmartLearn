import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_learn/app/style/color.dart';
import 'package:smart_learn/app/style/theme.dart';

export 'package:smart_learn/app/style/theme.dart';
export 'package:smart_learn/app/style/color.dart';

class AppStyle {
  final BuildContext _context;
  AppStyle(this._context);

  AppColor get color => AppColor(_context);
  AppThemeProvider get theme => _context.read<AppThemeProvider>();
}

extension AppStyleContext on BuildContext {
  AppStyle get style => AppStyle(this);
}