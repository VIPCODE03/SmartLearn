import 'package:flutter/material.dart';
import 'package:smart_learn/app/services/floating_bubble_service.dart';
import 'package:smart_learn/app/ui/dialogs/bubble_funs_dialog.dart';
import 'package:smart_learn/app/ui/widgets/item_widget.dart';
import 'package:smart_learn/screen/smartlearn/smartleanrn_screen.dart';
import 'package:star_menu/star_menu.dart';

//---   Show tiện ích   ------------------------------------------------
void showFloatingBubble(BuildContext context) {
  final otherEntries = <Widget>[
    WdgItem(
      text: 'Dịch thuật',
      icon: Icons.translate,
      onTap: () {
        showTranslationBottomSheet(navigatorKey.currentContext!);
      },
    ),

    WdgItem(
      text: 'Trợ lý',
      icon: Icons.smart_toy_rounded,
      onTap: () {
        showChatBottomSheet(navigatorKey.currentContext!);
      },
    ),

    WdgItem(
      text: 'Máy tính',
      icon: Icons.calculate,
      onTap: () {
        showCaculator(navigatorKey.currentContext!);
      },
    ),

    WdgItem(
      text: 'Trình duyệt',
      icon: Icons.web,
      onTap: () {
        showWebBottomSheet(navigatorKey.currentContext!, 'https://www.google.com');
      },
    ),
  ];

  AppFloatingBubbleService.toggleBubble(
    context,
    child: StarMenu(
      onStateChanged: (state) {
        switch(state) {
          case MenuState.closing:AppFloatingBubbleService.visible();
          case MenuState.opening:AppFloatingBubbleService.fade();
          case MenuState.open:
          case MenuState.closed:
        }
      },
      controller: StarMenuController(),
      items: otherEntries,
      child: const Icon(Icons.widgets_rounded, color: Colors.grey, size: 24),
    ),
  );
}