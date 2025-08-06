import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_learn/ui/dialogs/popup_dialog/popup_dialog.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';

import '../../global.dart';
import '../dialogs/popup_dialog/controller.dart';

class WdgPopupMenu extends StatelessWidget {
  final List<MenuItem> items;
  final Widget child;
  final PressType? pressType;

  final PopupMenuController controller = PopupMenuController();

  WdgPopupMenu({
    super.key,
    required this.items,
    this.pressType,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    if(kIsWeb) return const SizedBox();
    return WdgPopupDialog(
      pressType: pressType ?? PressType.singleClick,
      verticalMargin: -30,
      controller: controller,
      arrowSize: 15,
      color: Color.alphaBlend(Colors.grey.withAlpha(150), primaryColor(context)),
      borderRadius: BorderRadius.circular(6),
      menuBuilder: () => IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) => WdgBounceButton(
                  onTap: () async {
                    controller.hideMenu();
                    await Future.delayed(const Duration(milliseconds: 200));
                    item.func();
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        if(item.icon != null)
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
              ).toList(),
        ),
      ),
      child: child,
    );
  }
}

class MenuItem {
  String title;
  IconData? icon;
  VoidCallback func;

  MenuItem(this.title, this.icon, this.func);
}

class WdgPopupMenuCustom extends StatelessWidget {
  final Widget item;
  final Widget child;
  final PressType? pressType;
  final PopupMenuController controller;

  const WdgPopupMenuCustom({
    super.key,
    required this.item,
    this.pressType,
    required this.child,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return WdgPopupDialog(
      pressType: pressType ?? PressType.singleClick,
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

