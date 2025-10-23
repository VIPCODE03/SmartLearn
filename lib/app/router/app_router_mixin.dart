import 'package:flutter/material.dart';

mixin AppRouterMixin {
  // --- push ---
  Future<T?> pushSlideLeft<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(_buildRoute<T>(page, AxisDirection.left));
  }

  Future<T?> pushSlideRight<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(_buildRoute<T>(page, AxisDirection.right));
  }

  Future<T?> pushSlideUp<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(_buildRoute<T>(page, AxisDirection.up));
  }

  Future<T?> pushSlideDown<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(_buildRoute<T>(page, AxisDirection.down));
  }

  Future<T?> pushFade<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(_fadeRoute<T>(page));
  }

  Future<T?> pushScale<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(_scaleRoute<T>(page));
  }

  // --- pushReplacement ---
  Future<T?> pushSlideLeftReplace<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement<T, T>(
      _buildRoute<T>(page, AxisDirection.left),
    );
  }

  Future<T?> pushSlideRightReplace<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement<T, T>(
      _buildRoute<T>(page, AxisDirection.right),
    );
  }

  Future<T?> pushSlideUpReplace<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement<T, T>(
      _buildRoute<T>(page, AxisDirection.up),
    );
  }

  Future<T?> pushSlideDownReplace<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement<T, T>(
      _buildRoute<T>(page, AxisDirection.down),
    );
  }

  Future<T?> pushFadeReplace<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement<T, T>(_fadeRoute<T>(page));
  }

  Future<T?> pushScaleReplace<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement<T, T>(_scaleRoute<T>(page));
  }

  // --- helpers ---
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
        final tween = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubicEmphasized));
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
