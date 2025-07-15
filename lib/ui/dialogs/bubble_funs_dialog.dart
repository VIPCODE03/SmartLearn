import 'package:flutter/material.dart';
import 'package:smart_learn/ui/widgets/utilities_widget/ai_chat_widget.dart';
import '../widgets/utilities_widget/calculator_widget.dart';
import '../widgets/utilities_widget/translate_widget.dart';

bool _isShowingTranslationSheet = false;

void showTranslationBottomSheet(BuildContext context) {
  if (_isShowingTranslationSheet) return;

  _isShowingTranslationSheet = true;

  _showUtilBottomSheet(
      context,
      const WdgTranslation(),
      'Dịch ',
          () {
            _isShowingTranslationSheet = false;
          }
  );
}

bool _isShowCaculator = false;

void showCaculator(BuildContext context) {
  if (_isShowCaculator) return;

  _isShowCaculator = true;

  _showUtilBottomSheet(
      context,
      const WdgCalculator(),
      'Máy tính ',
          () {
        _isShowCaculator = false;
      }
  );
}

bool _isShowChat = false;

void showChatBottomSheet(BuildContext context) {
  if (_isShowChat) return;

  _isShowChat = true;

  _showUtilBottomSheet(
      context,
      const WdgChat(),
      'Trợ lý', () {
    _isShowChat = false;
  });
}

void _showUtilBottomSheet(
    BuildContext context,
    Widget widget,
    String title,
    VoidCallback onCompleted
    ) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.design_services),
                  )
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
              )
            ]),
            Expanded(child: widget)
          ]
      );
    },
  ).whenComplete(onCompleted);
}
