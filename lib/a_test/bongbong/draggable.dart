// // floating_bubble_service.dart
// import 'package:flutter/material.dart';
// import 'package:smart_learn/global.dart';
// // floating_bubble.dart không cần thay đổi cho yêu cầu này,
// // nhưng hãy đảm bảo bạn đã có file đó từ lần trước.
// // import 'floating_bubble.dart';
//
// class FloatingBubbleService {
//   static OverlayEntry? _overlayEntry;
//   static Offset _currentPosition = const Offset(50, 100);
//   static const double _bubbleSize = 50.0;
//
//   static final GlobalKey<_DraggableBubbleState> _bubbleKey = GlobalKey<_DraggableBubbleState>();
//
//   static bool get isBubbleVisible => _overlayEntry != null;
//
//   static void showBubble(
//       BuildContext context, {
//         Offset initialPosition = const Offset(50, 100),
//         VoidCallback? onTap,
//         Widget? child,
//       }) {
//     if (_overlayEntry != null) {
//       return;
//     }
//
//     _currentPosition = initialPosition;
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) {
//         return _DraggableBubble(
//           key: _bubbleKey,
//           initialPosition: _currentPosition,
//           bubbleSize: _bubbleSize,
//           userOnTap: onTap,
//           child: child,
//           onDragEnd: (newPosition) {
//             _currentPosition = newPosition;
//           },
//         );
//       },
//     );
//
//     Overlay.of(context).insert(_overlayEntry!);
//   }
//
//   static void hideBubble() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }
//
//   static void toggleBubble(
//       BuildContext context, {
//         Offset initialPosition = const Offset(50, 100),
//         VoidCallback? onTap,
//         Widget? child,
//       }) {
//     if (isBubbleVisible) {
//       hideBubble();
//     } else {
//       // Khi toggle, nếu vị trí ban đầu không được cung cấp, sử dụng vị trí hiện tại
//       // Nếu initialPosition được cung cấp, nó sẽ ghi đè _currentPosition cho lần hiển thị này
//       Offset positionToShow = (initialPosition == const Offset(50, 100) && _currentPosition != const Offset(50,100))
//           ? _currentPosition
//           : initialPosition;
//       showBubble(
//         context,
//         initialPosition: positionToShow,
//         onTap: onTap,
//         child: child,
//       );
//     }
//   }
//
// /*  static void moveBack() {
//     if (isBubbleVisible && _bubbleKey.currentState != null) {
//       _bubbleKey.currentState!._moveBack();
//     }
//   }*/
//
//   static void visible() {
//     if (isBubbleVisible && _bubbleKey.currentState != null) {
//       _bubbleKey.currentState!._opacity(1.0);
//     }
//   }
//
//   static void fade() {
//     if (isBubbleVisible && _bubbleKey.currentState != null) {
//       _bubbleKey.currentState!._opacity(0.0);
//     }
//   }
// }
//
// class _DraggableBubble extends StatefulWidget {
//   final Offset initialPosition;
//   final double bubbleSize;
//   final VoidCallback? userOnTap;
//   final Widget? child;
//   final Function(Offset) onDragEnd;
//
//   const _DraggableBubble({
//     super.key,
//     required this.initialPosition,
//     required this.bubbleSize,
//     this.userOnTap,
//     this.child,
//     required this.onDragEnd,
//   });
//
//   @override
//   _DraggableBubbleState createState() => _DraggableBubbleState();
// }
//
// // Thêm 'SingleTickerProviderStateMixin' để sử dụng cho AnimationController
// class _DraggableBubbleState extends State<_DraggableBubble> with SingleTickerProviderStateMixin {
//   late Offset _position;
//   late AnimationController _animationController;
//
// /*  late Offset _positionOld;
//   Animation<Offset>? _animation;*/
//
//   double _currentOpacity = 1.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _position = screens.initialPosition;
//     _currentOpacity = 1.0;
//
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//   }
//
//   void _opacity(double opacity) {
//     setState(() {
//       _currentOpacity = opacity;
//     });
//   }
//
// /*
//   void _moveBack() {
//     if(!mounted) return;
//
//     _move(_position, _positionOld);
//   }
//
//   void _moveToCenter() {
//     _positionOld = _position;
//     if (!mounted) return;
//
//     final screenSize = MediaQuery.of(context).size;
//     final targetPosition = Offset(
//       (screenSize.width - screens.bubbleSize) / 2,
//       (screenSize.height - screens.bubbleSize) / 2,
//     );
//
//     // Nếu đã ở giữa rồi thì không cần làm gì thêm
//     if ((_position - targetPosition).distanceSquared < 0.01) {
//       screens.userOnTap?.call(); // Gọi hành động của người dùng nếu có
//       return;
//     }
//
//     _move(_position, targetPosition);
//   }
//
//   void _move(Offset begin, Offset end) {
//     _animation = Tween<Offset>(
//       begin: begin,
//       end: end,
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     )..addListener(() {
//       if (mounted) {
//         setState(() {
//           _position = _animation!.value;
//         });
//       }
//     })..addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         screens.onDragEnd(_position);
//         screens.userOnTap?.call();
//       }
//     });
//
//     _animationController.forward(from: 0.0);
//   }*/
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Nếu đang có animation chạy, chúng ta không muốn screens Positioned
//     // bị rebuild với giá trị _position cũ từ state trước khi animation listener cập nhật.
//     // Tuy nhiên, với cách listener gọi setState, nó sẽ tự động rebuild.
//     return Positioned(
//       left: _position.dx,
//       top: _position.dy,
//       child: GestureDetector(
//         onPanStart: (_) {
//           // Dừng animation nếu người dùng bắt đầu kéo
//           if (_animationController.isAnimating) {
//             _animationController.stop();
//           }
//         },
//         onPanUpdate: (details) {
//           // Dừng animation nếu người dùng kéo trong lúc nó đang chạy
//           // (mặc dù onPanStart đã xử lý, nhưng để chắc chắn)
//           if (_animationController.isAnimating) {
//             _animationController.stop();
//           }
//           if (mounted) {
//             setState(() {
//               _position = Offset(
//                 _position.dx + details.delta.dx,
//                 _position.dy + details.delta.dy,
//               );
//             });
//           }
//         },
//         onPanEnd: (details) {
//           screens.onDragEnd(_position);
//         },
//         onTap: () {
//           // _moveToCenter();
//         },
//         child: AnimatedOpacity(
//           opacity: _currentOpacity,
//           duration: const Duration(milliseconds: 100),
//           child: Material(
//             elevation: 4.0,
//             shape: const CircleBorder(),
//             clipBehavior: Clip.antiAlias,
//             color: primaryColor(context),
//             child: Container(
//               width: screens.bubbleSize,
//               height: screens.bubbleSize,
//               alignment: Alignment.center,
//               child: screens.child ?? const Icon(Icons.star, color: Colors.white, size: 30),
//             ),
//           ),
//         )
//       ),
//     );
//   }
// }