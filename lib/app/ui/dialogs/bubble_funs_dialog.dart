import 'package:flutter/material.dart';
import 'package:smart_learn/core/feature_widgets/app_widget_provider.dart';

bool _isShowingTranslationSheet = false;

void showTranslationBottomSheet(BuildContext context) {
  if (_isShowingTranslationSheet) return;

  _isShowingTranslationSheet = true;

  _showUtilBottomSheet(
      context,
      appWidget.translate.translateView(),
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
      appWidget.calculator.calculatorView(),
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
      appWidget.assistant.assistantView(),
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
    useSafeArea: true,
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: widget,
      );
    },
  ).whenComplete(onCompleted);
}
