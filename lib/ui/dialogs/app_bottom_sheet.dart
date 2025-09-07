import 'package:flutter/material.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';

void showAppBottomSheet({
  required BuildContext context,
  required String title,
  Widget? action,
  double? height,
  Color? backgroundColor,
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).cardColor,
            border: Border.all(color: primaryColor(context))
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),

                if(action != null)
                  action
              ],
            ),

            const SizedBox(height: 16),

            Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2.5
              ),
              child: SingleChildScrollView(
                child: child,
              ),
            ),

            const SizedBox(height: 25)
          ],
        ),
      );
    },
  );
}

void showAppConfirmBottomSheet({
  required BuildContext context,
  double? height,
  required String title,
  required VoidCallback onConfirm,
  required Widget child,
}) {
  showAppBottomSheet(
      context: context,
      title: title,
      action: WdgBounceButton(
          onTap: onConfirm,
          child: Icon(Icons.check, color: primaryColor(context))
      ),
      child: child
  );
}
