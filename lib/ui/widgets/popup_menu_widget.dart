import 'package:flutter/material.dart';
import 'package:smart_learn/ui/dialogs/popup_dialog/popup_dialog.dart';

import '../../global.dart';
import '../dialogs/popup_dialog/controller.dart';

class WdgPopupMenu extends StatelessWidget {
  final List<MenuItem> items;
  final Widget child;
  final PopupMenuController controller = PopupMenuController();

  WdgPopupMenu({super.key, required this.items, required this.child});

  @override
  Widget build(BuildContext context) {
    return WdgPopupDialog(
      pressType: PressType.singleClick,
      verticalMargin: -15,
      controller: controller,
      arrowSize: 15,
      color: Color.alphaBlend(Colors.grey.withAlpha(150), primaryColor(context)),
      borderRadius: BorderRadius.circular(6),
      menuBuilder: () => IntrinsicWidth(
        child: Column(
          children: items.map((item) => InkWell(
                  onTap: () {
                    item.func();
                    controller.hideMenu();
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(item.icon, size: 15),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(item.title),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      child: child,
    );
  }
}

class MenuItem {
  String title;
  IconData icon;
  VoidCallback func;

  MenuItem(this.title, this.icon, this.func);
}

class WdgPopupMenuCustom extends StatelessWidget {
  final Widget item;
  final Widget child;
  final PopupMenuController controller;

  const WdgPopupMenuCustom({super.key, required this.item, required this.child, required this.controller});

  @override
  Widget build(BuildContext context) {
    return WdgPopupDialog(
      pressType: PressType.singleClick,
      verticalMargin: -5,
      controller: controller,
      arrowSize: 15,
      color: Colors.grey.shade300,
      barrierColor: Colors.grey.withAlpha(200),
      borderRadius: BorderRadius.circular(6),
      menuBuilder: () => item,
      child: child,
    );
  }
}

