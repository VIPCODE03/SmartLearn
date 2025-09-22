import 'package:flutter/material.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/dialogs/scale_dialog.dart';

Future<String?> showInputDialog({
  required BuildContext context,
  required String title,
  String? initialValue,
  String? hint,
}) async {
  final TextEditingController controller = TextEditingController(text: initialValue);
  final FocusNode focusNode = FocusNode();

  return showDialog<String>(
    context: context,
    builder: (context) {
      final primaryColor = context.style.color.primaryColor;
      return WdgScaleDialog(
          border: true,
          shadow: true,
          onShow: () {
            focusNode.requestFocus();
          },
          child: SizedBox(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                focusNode: focusNode,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                autofocus: false,
                cursorColor: primaryColor,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(controller.text),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              )
            ]),
          )
      );
    }
  );
}
