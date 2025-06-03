import 'package:flutter/material.dart';
import 'package:smart_learn/services/floating_bubble_service.dart';
import 'package:smart_learn/ui/dialogs/bubble_funs_dialog.dart';
import 'package:smart_learn/ui/widgets/item_widget.dart';
import 'package:smart_learn/ui/widgets/translate_widget.dart';
import 'package:star_menu/star_menu.dart';

import 'languages/a_global_language.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

late GlobalLanguage globalLanguage;

Color primaryColor(BuildContext context) => Theme.of(context).primaryColor;

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

  // 📝 Sau khi màn hình được pop và có kết quả (nếu có), gọi callback.
  if (onScreenPop != null) {
    onScreenPop(result);
  }
}

void hideKeyboardAndRemoveFocus(BuildContext context) {
  // 1. Ẩn bàn phím:
  //    - Sử dụng FocusManager để lấy focus hiện tại (primaryFocus).
  //    - Gọi unfocus() trên focus hiện tại để ẩn bàn phím.
  FocusManager.instance.primaryFocus?.unfocus();

  // 2. Xóa focus của tất cả TextField (trong phạm vi context hiện tại):
  //    - Sử dụng FocusScope.of(context) để lấy FocusScope hiện tại.
  //    - Gọi unfocus() trên FocusScope để loại bỏ focus khỏi bất kỳ widget nào đang có focus trong scope đó, bao gồm cả TextField.
  FocusScope.of(context).unfocus();
}

void showFloatingBubble(BuildContext context) {
  final StarMenuController controller = StarMenuController();
  final otherEntries = <Widget>[
    WdgItem(
      text: 'Dịch thuật',
      icon: Icons.translate,
      color: Colors.grey,
      backgroundColor: Colors.blueGrey,
      onTap: () {
        showTranslationBottomSheet(navigatorKey.currentContext!);
      },
    ),

    WdgItem(
      text: 'Trợ lý',
      icon: Icons.smart_toy_rounded,
      color: Colors.grey,
      backgroundColor: Colors.deepPurple,
      onTap: () {
        showChatBottomSheet(navigatorKey.currentContext!);
      },
    ),

    WdgItem(
      text: 'Máy tính',
      icon: Icons.calculate,
      color: Colors.grey,
      backgroundColor: Colors.brown,
      onTap: () {
        showCaculator(navigatorKey.currentContext!);
      },
    ),
  ];

  FloatingBubbleService.toggleBubble(
    context,
    child: StarMenu(
      onStateChanged: (state) {
        switch(state) {
          case MenuState.closed:
            // FloatingBubbleService.hideDimmingLayer();
          case MenuState.closing:
            FloatingBubbleService.visible();
          case MenuState.opening:
            FloatingBubbleService.fade();
          case MenuState.open:
            // FloatingBubbleService.showDimmingLayer(context);
        }
      },
      controller: StarMenuController(),
      items: otherEntries,
      child: const Icon(Icons.ac_unit_sharp, color: Colors.grey, size: 30),
    ),
  );
}

void hideFloatingBubble() {
  FloatingBubbleService.hideBubble();
}

final Map<String, Map<String, String>> translateds = {};