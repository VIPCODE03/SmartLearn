import 'package:flutter/services.dart';

/// A utility class holding constants for smartlearn configuration and communication.
///
/// This class prevents the use of "magic strings" and provides a single
/// source of truth for all smartlearn-related constants.
abstract class FlashCardSetNativeConfig {

  // --- Channel and Widget Identification ---
  /// The MethodChannel name used for communication between Flutter and Native.
  /// This MUST match the channel name defined in the native code (Android/iOS).
  static const String channelName = 'com.zent.app.smart_learn/smartlearn';

  /// The name of the smartlearn provider on iOS.
  static const String iOSWidgetName = 'FlashcardWidgetProvider';

  /// The name of the smartlearn provider on Android.
  static const String androidWidgetName = 'FlashcardWidgetProvider';

  // --- Method Invocation ---
  /// The name of the method to invoke on the native side to update smartlearn data.
  static const String updateMethodName = 'update';

  /// The name of the method to invoke on the native side to remove smartlearn data.
  static const String removeMethodName = 'remove';

  // --- Data Keys ---
  /// The key for the list of cards in the data map.
  static const String cardsListKey = 'cards';

  /// The key for the front side of a card.
  static const String cardFrontKey = 'front';

  /// The key for the back side of a card.
  static const String cardBackKey = 'back';

  // --- Platform Channel Instance ---
  static const platform = MethodChannel(FlashCardSetNativeConfig.channelName);
}