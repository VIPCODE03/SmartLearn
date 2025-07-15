// import 'package:flutter_dnd/flutter_dnd.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
//
// class FocusService {
//   static final FocusService _instance = FocusService._internal();
//
//   factory FocusService() => _instance;
//
//   FocusService._internal();
//
//   bool _isFocusing = false;
//
//   bool get isFocusing => _isFocusing;
//
//   /// Bắt đầu chế độ tập trung
//   Future<void> startFocus() async {
//     _isFocusing = true;
//
//     try {
//       if (!kIsWeb && !defaultTargetPlatform.name.contains('iOS')) {
//         final granted = await FlutterDnd.isNotificationPolicyAccessGranted;
//         if (!granted!) {
//           FlutterDnd.gotoPolicySettings();
//         } else {
//           await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_NONE);
//         }
//       }
//     } on PlatformException catch (e) {
//       debugPrint("Lỗi khi bật DND: $e");
//     }
//   }
//
//   /// Dừng chế độ tập trung
//   Future<void> stopFocus() async {
//     _isFocusing = false;
//
//     try {
//       if (!kIsWeb && !defaultTargetPlatform.name.contains('iOS')) {
//         await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_ALL);
//       }
//     } on PlatformException catch (e) {
//       debugPrint("Lỗi khi tắt DND: $e");
//     }
//   }
// }
