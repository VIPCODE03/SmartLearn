import 'package:flutter/material.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';

void showAppBottomSheet({
  required BuildContext context,
  required String title,
  Widget? action,
  double? height,
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.grey.withAlpha(50),
            border: Border.all(
                color: primaryColor(context)
            )
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

            child,

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
  required VoidCallback onComfirm,
  required Widget child,
}) {
  showAppBottomSheet(
      context: context,
      title: title,
      action: WdgBounceButton(
          onTap: onComfirm,
          child: Icon(Icons.check, color: primaryColor(context))
      ),
      child: child
  );
}
