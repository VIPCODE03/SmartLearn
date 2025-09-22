import 'package:flutter/material.dart';

//---   Chuyển màn hình   ---------------------------------------------------
void navigateToNextScreen(
    BuildContext context,
    Widget nextScreen, {
      Offset? offsetBegin,
      Function(dynamic)? onScreenPop,
    })
async {
  final result = await Navigator.of(context).push(PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = offsetBegin ?? const Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  ));

  if (onScreenPop != null) {
    onScreenPop(result);
  }
}
