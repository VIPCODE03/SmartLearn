import 'package:flutter/material.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/features/flashcard/presentation/screens/flashcard_extenal_screen.dart';
import 'package:smart_learn/features/flashcard/presentation/screens/flashcard_screen.dart';
import 'package:smart_learn/features/flashcard/presentation/screens/manage/flashcardset_manage_screen.dart';

abstract class IFlashCardWidget {}

abstract class IFlashCardRouter {
  void goFlashCardSet(BuildContext context);
  void goFlashCard(BuildContext context, String cardSetId);
  void goFlashCardByFile(BuildContext context, String fileId);
}

class _FlashCardWidget implements IFlashCardWidget {
  static final _FlashCardWidget _singleton = _FlashCardWidget._internal();
  _FlashCardWidget._internal();
  static _FlashCardWidget get instance => _singleton;
}

class _FlashCardRouter extends IFlashCardRouter with AppRouterMixin {
  static final _FlashCardRouter _singleton = _FlashCardRouter._internal();
  _FlashCardRouter._internal();
  static _FlashCardRouter get instance => _singleton;

  @override
  void goFlashCardSet(BuildContext context) => pushScale(context, const SCRFlashCardSetManage());

  @override
  void goFlashCard(BuildContext context, String cardSetId) => pushScale(context, SCRFlashCard(cardSetId: cardSetId));

  @override
  void goFlashCardByFile(BuildContext context, String fileId) {
    pushScale(context, SCRFlashCardExtenal.byFile(fileId: fileId));
  }
}

class FlashCardProvider {
  static final FlashCardProvider _singleton = FlashCardProvider._internal();
  FlashCardProvider._internal();
  static FlashCardProvider get instance => _singleton;

  IFlashCardWidget get widget => _FlashCardWidget.instance;
  IFlashCardRouter get router => _FlashCardRouter.instance;
}
