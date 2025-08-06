import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:smart_learn/features/flashcard/data/config/flashcardset_widget_native_config.dart';
import 'package:smart_learn/features/flashcard/data/models/flashcardset_model.dart';

abstract class NDSFlashCardSet {
  Future<void> update(MODFlashCardSet cardSet);
  Future<void> remove(MODFlashCardSet cardSet);
}

class NDSFlashCardSetImpl implements NDSFlashCardSet {
  final MethodChannel _channel = FlashCardSetNativeConfig.platform;

  @override
  Future<void> update(MODFlashCardSet cardSet) async {
    // if (!cardSet.isSelect) return;
    // if (kIsWeb) return;
    // if (Platform.isAndroid || Platform.isIOS) {
    //   await _channel.invokeMethod(
    //     FlashCardSetNativeConfig.updateMethodName,
    //     cardSet.toMap(),
    //   );
    // }
  }

  @override
  Future<void> remove(MODFlashCardSet cardSet) async {
  //   if (kIsWeb) return;
  //   if (Platform.isAndroid || Platform.isIOS) {
  //     await _channel.invokeMethod(
  //       FlashCardSetNativeConfig.removeMethodName,
  //       cardSet.toMap(),
  //     );
  //   }
  }
}
