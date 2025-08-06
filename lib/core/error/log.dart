import 'package:flutter/foundation.dart';

void logError(
    dynamic error, {
      StackTrace? stackTrace,
      String? context,
    }) {
  final time = DateTime.now().toIso8601String();
  final contextInfo = context != null ? '[$context]' : '';
  if (kDebugMode) {
    print('❌ [$time] $contextInfo \nError: $error');
  }
  if (stackTrace != null) {
    if (kDebugMode) {
      print('📌 StackTrace:\n$stackTrace');
    }
  }
}

logDev(String log, {String? context}) {
  if (kDebugMode) {
    final now = DateTime.now();
    print('🐛 [${now.toIso8601String()}] ➤ $log'
        '\n${context != null ? '[$context]' : ''}');
  }
}