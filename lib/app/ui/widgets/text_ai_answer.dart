// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
// import 'package:smart_learn/global.dart';
//
// class WdgTextAIAnswer extends StatelessWidget {
//   final String jsonString;
//   final TextStyle? mathTextStyle;
//   final TextStyle? textStyle;
//
//   const WdgTextAIAnswer({
//     super.key,
//     required this.jsonString,
//     this.mathTextStyle,
//     this.textStyle,
//   });
//
//   //------------------Xử lý kết quả-------------------------------------------
//   static String extractJsonFromAIResponse(String rawResponse) {
//     final regex = RegExp(r'```json\s*([\s\S]*?)\s*```', multiLine: true);
//     final match = regex.firstMatch(rawResponse);
//
//     if (match != null) {
//       final extractedJson = match.group(1)?.trim();
//       return extractedJson ?? rawResponse;
//     }
//
//     return rawResponse;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final String processedJsonString = extractJsonFromAIResponse(jsonString);
//
//     try {
//       final List<dynamic> data = jsonDecode(processedJsonString);
//       final defaultTextColor = Theme.of(context).textTheme.bodyMedium?.color;
//       List<InlineSpan> textSpans = [];
//
//       for (var item in data) {
//         String? type = item['type'];
//         String? value = item['value'];
//
//         if (value != null) {
//           TextStyle currentStyle =
//           (textStyle ?? const TextStyle(fontSize: 16)).copyWith(color: defaultTextColor);
//
//           if (type == 'text-b') {
//             currentStyle = currentStyle.copyWith(fontWeight: FontWeight.bold);
//           } else if (type == 'text-i') {
//             currentStyle = currentStyle.copyWith(fontStyle: FontStyle.italic);
//           } else if (type == 'text-b+i') {
//             currentStyle = currentStyle.copyWith(
//               fontWeight: FontWeight.bold,
//               fontStyle: FontStyle.italic,
//             );
//           } else if (type == 'math_matrix') {
//             textSpans.add(
//               WidgetSpan(
//                 alignment: PlaceholderAlignment.middle,
//                 child: Padding(
//                   padding: const EdgeInsets.all(4.0   ),
//                   child: Math.tex(
//                     value,
//                     textStyle: (mathTextStyle ??
//                         TextStyle(fontSize: 16, color: defaultTextColor))
//                         .copyWith(color: defaultTextColor),
//                   ),
//                 ),
//               ),
//             );
//             continue;
//           }
//
//           textSpans.add(TextSpan(text: value, style: currentStyle));
//         } else if (type == 'newLine') {
//           textSpans.add(const TextSpan(text: '\n'));
//         }
//       }
//
//       return Text.rich(TextSpan(children: textSpans));
//
//     } catch (e) {
//       debugPrint('Error JSON: $e');
//       return Text(
//         globalLanguage.error,
//         style: TextStyle(color: Theme.of(context).colorScheme.error),
//       );
//     }
//   }
//
// }