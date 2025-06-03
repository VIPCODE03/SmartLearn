import 'package:flutter/material.dart';
import 'package:flutter_awesome_calculator/flutter_awesome_calculator.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/widgets/ai_chat_widget.dart';

import '../widgets/translate_widget.dart';

bool _isShowingTranslationSheet = false;

void showTranslationBottomSheet(BuildContext context) {
  if (_isShowingTranslationSheet) return;

  _isShowingTranslationSheet = true;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const WdgTranslation(),
  ).whenComplete(() {
    _isShowingTranslationSheet = false;
  });
}


bool _isShowCaculator = false;

void showCaculator(BuildContext context) {
  if (_isShowCaculator) return;

  _isShowCaculator = true;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.design_services)),
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Máy tính',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ]),

        FlutterAwesomeCalculator(
          context: context,
          digitsButtonColor: Colors.white,
          backgroundColor: Colors.transparent,
          expressionAnswerColor: Colors.black,
          showAnswerField: true,
          fractionDigits: 1,
          buttonRadius: 8,
          clearButtonColor: Colors.red,
          operatorsButtonColor: primaryColor(context),
          onChanged: (ans,expression){

          },
        ),
      ],
    )
  ).whenComplete(() {
    _isShowCaculator = false;
  });
}

bool _isShowChat = false;

void showChatBottomSheet(BuildContext context) {
  if (_isShowChat) return;

  _isShowChat = true;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      final sheetController = DraggableScrollableController();

      return DraggableScrollableSheet(
        controller: sheetController,
        initialChildSize: 0.7,
        minChildSize: 0.2,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return WdgChat(externalScrollController: scrollController);
        },
      );
    },
  ).whenComplete(() {
    _isShowChat = false;
  });
}

