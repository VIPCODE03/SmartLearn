// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:performer/main.dart';
// import 'package:smart_learn/global.dart';
// import 'package:smart_learn/utils/time_formatter.dart';
// import '../../performers/action_unit/focus_action.dart';
// import '../../performers/data_state/focus_state.dart';
// import '../../performers/performer/focus_performer.dart';
//
// class GlobalFocusTimerBar extends StatefulWidget {
//   const GlobalFocusTimerBar({super.key});
//
//   @override
//   State<GlobalFocusTimerBar> createState() => _GlobalFocusTimerBarState();
// }
//
// class _GlobalFocusTimerBarState extends State<GlobalFocusTimerBar> with SingleTickerProviderStateMixin {
//   bool _showTitleOnly = true;
//   bool _showFullLayout = false;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {
//         _showTitleOnly = false;
//         _showFullLayout = true;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PerformerBuilder<FocusPerformer>(builder: (context, perf) {
//       final state = perf.current;
//       if (state is! FocusingState) return const SizedBox.shrink();
//
//       return Container(
//         height: 30,
//         width: MediaQuery.of(context).size.width,
//         color: primaryColor(context).withAlpha(150),
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: _buildContent(state.elapsed, perf),
//       );
//     });
//   }
//
//   Widget _buildContent(Duration elapsed, FocusPerformer perf) {
//     if (_showFullLayout || _showTitleOnly) {
//       return Stack(
//         children: [
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             left: _showTitleOnly ? MediaQuery.of(context).size.width / 3 : 0,
//             top: 4,
//             bottom: 0,
//             child: const Text(
//                 'Chế độ tập trung',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//           ),
//
//           Positioned(
//               right: 0,
//               top: 0,
//               bottom: 0,
//               child: AnimatedOpacity(
//                 opacity: _showTitleOnly ? 0 : 1,
//                 duration: const Duration(milliseconds: 300),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.timer, color: Colors.white, size: 20),
//                     const SizedBox(width: 6),
//                     Text(
//                       TimeFormatterUtil.fomathhmmss(elapsed),
//                       style: const TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//
//                     const SizedBox(width: 12),
//
//                     InkWell(
//                       child: const Icon(Icons.stop, color: Colors.white),
//                       onTap: () => perf.add(StopFocus()),
//                     ),
//                   ],
//                 ),
//             )
//           )
//         ],
//       );
//     }
//
//     return const SizedBox.shrink();
//   }
// }
