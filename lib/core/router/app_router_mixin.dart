import 'package:flutter/material.dart';

mixin AppRouterMixin {
  Future<T?> pushSlideLeft<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(_buildRoute<T>(page, AxisDirection.left));
  }

  Future<T?> pushSlideUp<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(_buildRoute<T>(page, AxisDirection.up));
  }

  Future<T?> pushFade<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(_fadeRoute<T>(page));
  }

  Future<T?> pushScale<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(_scaleRoute<T>(page));
  }

  PageRouteBuilder<T> _buildRoute<T>(Widget page, AxisDirection direction) {
    final offset = _getBeginOffset(direction);
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(begin: offset, end: Offset.zero)
            .chain(CurveTween(curve: Curves.ease));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  PageRouteBuilder<T> _fadeRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  PageRouteBuilder<T> _scaleRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<double>(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack));
        return ScaleTransition(scale: animation.drive(tween), child: child);
      },
    );
  }

  Offset _getBeginOffset(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.left:
        return const Offset(1, 0);
      case AxisDirection.right:
        return const Offset(-1, 0);
    }
  }
}
