import 'package:flutter/material.dart';
import 'package:smart_learn/app/services/floating_bubble_service.dart';
import 'package:smart_learn/app/ui/dialogs/bubble_funs_dialog.dart';
import 'package:smart_learn/app/ui/widgets/item_widget.dart';
import 'package:star_menu/star_menu.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//---   Show tiện ích   ------------------------------------------------
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

  AppFloatingBubbleService.toggleBubble(
    context,
    child: StarMenu(
      onStateChanged: (state) {
        switch(state) {
          case MenuState.closed:
            // FloatingBubbleService.hideDimmingLayer();
          case MenuState.closing:
            AppFloatingBubbleService.visible();
          case MenuState.opening:
            AppFloatingBubbleService.fade();
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