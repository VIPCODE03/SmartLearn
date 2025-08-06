import 'package:flutter/material.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';

class FloatingBubbleService {
  static final ValueNotifier isVisibled = ValueNotifier(false);
  static OverlayEntry? _overlayEntry;
  static Offset _currentPosition = const Offset(50, 100);
  static const double _bubbleSize = 50.0;

  // Cho lớp phủ mờ
  static OverlayEntry? _dimmingOverlayEntry;
  static double _dimmingTargetOpacity = 0.0;
  static const Duration _dimmingAnimationDuration = Duration(milliseconds: 300);

  static final GlobalKey<_DraggableBubbleState> _bubbleKey = GlobalKey<_DraggableBubbleState>();

  static bool get isBubbleVisible => _overlayEntry != null;
  static bool get isDimmingLayerVisible => _dimmingTargetOpacity > 0.0;

  static void showBubble(
      BuildContext context, {
        Offset initialPosition = const Offset(50, 100),
        VoidCallback? onTap,
        Widget? child,
      }) {
    if (_overlayEntry != null) {
      return;
    }

    _currentPosition = initialPosition;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return _DraggableBubble(
          key: _bubbleKey,
          initialPosition: _currentPosition,
          bubbleSize: _bubbleSize,
          userOnTap: onTap,
          child: child,
          onDragEnd: (newPosition) {
            _currentPosition = newPosition;
          },
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    FloatingBubbleService.isVisibled.value = true;
  }

  static void hideBubble() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    FloatingBubbleService.isVisibled.value = false;
  }

  static void toggleBubble(
      BuildContext context, {
        Offset initialPosition = const Offset(50, 100),
        VoidCallback? onTap,
        Widget? child,
      }) {
    if (isBubbleVisible) {
      hideBubble();
    } else {
      Offset positionToShow = (initialPosition == const Offset(50, 100) && _currentPosition != const Offset(50,100))
          ? _currentPosition
          : initialPosition;
      showBubble(
        context,
        initialPosition: positionToShow,
        onTap: onTap,
        child: child,
      );
    }
  }

/*  static void moveBack() {
    if (isBubbleVisible && _bubbleKey.currentState != null) {
      _bubbleKey.currentState!._moveBack();
    }
  }*/

  static void visible() {
    if (isBubbleVisible && _bubbleKey.currentState != null) {
      _bubbleKey.currentState!._opacity(1.0);
    }
  }

  static void fade() {
    if (isBubbleVisible && _bubbleKey.currentState != null) {
      _bubbleKey.currentState!._opacity(0.0);
    }
  }

  // Hiển thị lớp phủ mờ
  static void showDimmingLayer(BuildContext context) {
    if (_dimmingOverlayEntry != null) { // Đã có entry, chỉ cần build lại
      _dimmingTargetOpacity = 0.5; // Màu đen với 50% opacity
      _dimmingOverlayEntry?.markNeedsBuild();
      return;
    }

    _dimmingTargetOpacity = 0.0; // Bắt đầu từ trong suốt để animated opacity hoạt động

    _dimmingOverlayEntry = OverlayEntry(builder: (context) {
      return AnimatedOpacity(
        opacity: _dimmingTargetOpacity,
        duration: _dimmingAnimationDuration,
        child: GestureDetector(
          onTap: () {

          },
          child: Container(
            color: Colors.black, // Độ mờ thực tế khi _dimmingTargetOpacity = 1 cho AnimatedOpacity
            // Nhưng vì ta dùng opacity của AnimatedOpacity, nên màu ở đây là màu gốc
            // Vậy nên ở đây sẽ là Colors.black, và opacity của AnimatedOpacity sẽ làm mờ.
            // Tuy nhiên, để đơn giản, ta set màu với opacity luôn và AnimatedOpacity sẽ chạy từ 0.0 -> 0.5 (target)
            // --> Không, AnimatedOpacity sẽ điều khiển opacity của child. Child nên là màu solid.
            // --> Container(color: Colors.black) và AnimatedOpacity sẽ là 0.0 -> 0.5
            // --> Hoặc Container(color: Colors.black.withOpacity(SOME_MAX_OPACITY)) và AnimatedOpacity 0.0 -> 1.0
            // Chọn cách 1: Container màu đen, AnimatedOpacity điều khiển độ mờ từ 0.0 -> 0.5
            // Vậy target opacity sẽ là 0.5, và child là Container(color: Colors.black)
          ),
        ),
        onEnd: () {
          // Nếu animation kết thúc ở trạng thái ẩn và entry vẫn tồn tại
          if (_dimmingTargetOpacity == 0.0 && _dimmingOverlayEntry != null) {
            _dimmingOverlayEntry?.remove();
            _dimmingOverlayEntry = null;
          }
        },
      );
    });
    // Chèn lớp mờ BÊN DƯỚI bong bóng. Nếu chỉ có 1 Overlay, thứ tự insert quan trọng.
    // Nếu muốn đảm bảo, có thể dùng nhiều Overlay hoặc sắp xếp lại entries.
    // Hiện tại, giả sử bong bóng được insert sau nên sẽ ở trên.
    // Hoặc tốt hơn là insert lớp mờ trước, rồi bong bóng sau nếu đang show cả hai.
    // Trong trường hợp này, _dimmingOverlayEntry được tạo khi cần.
    Overlay.of(context).insert(_overlayEntry!, below: _dimmingOverlayEntry!);


    // Kích hoạt animation cho AnimatedOpacity sau khi frame được build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dimmingOverlayEntry != null &&_dimmingTargetOpacity != 0.5) {
        _dimmingTargetOpacity = 0.5;
        _dimmingOverlayEntry?.markNeedsBuild();
      }
    });
  }

  // Ẩn lớp phủ mờ
  static void hideDimmingLayer() {
    if (_dimmingOverlayEntry == null && _dimmingTargetOpacity == 0.0) return;

    _dimmingTargetOpacity = 0.0; // Target opacity về 0 để ẩn
    _dimmingOverlayEntry?.markNeedsBuild();
    // Việc remove entry sẽ được xử lý bởi onEnd của AnimatedOpacity
  }
}

class _DraggableBubble extends StatefulWidget {
  final Offset initialPosition;
  final double bubbleSize;
  final VoidCallback? userOnTap;
  final Widget? child;
  final Function(Offset) onDragEnd;

  const _DraggableBubble({
    super.key,
    required this.initialPosition,
    required this.bubbleSize,
    this.userOnTap,
    this.child,
    required this.onDragEnd,
  });

  @override
  _DraggableBubbleState createState() => _DraggableBubbleState();
}

class _DraggableBubbleState extends State<_DraggableBubble> with SingleTickerProviderStateMixin {
  late Offset _position;
  late AnimationController _animationController;

/*  late Offset _positionOld;
  Animation<Offset>? _animation;*/

  double _currentOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
    _currentOpacity = 1.0;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _opacity(double opacity) {
    setState(() {
      _currentOpacity = opacity;
    });
  }

/*
  void _moveBack() {
    if(!mounted) return;

    _move(_position, _positionOld);
  }

  void _moveToCenter() {
    _positionOld = _position;
    if (!mounted) return;

    final screenSize = MediaQuery.of(context).size;
    final targetPosition = Offset(
      (screenSize.width - screens.bubbleSize) / 2,
      (screenSize.height - screens.bubbleSize) / 2,
    );

    // Nếu đã ở giữa rồi thì không cần làm gì thêm
    if ((_position - targetPosition).distanceSquared < 0.01) {
      screens.userOnTap?.call(); // Gọi hành động của người dùng nếu có
      return;
    }

    _move(_position, targetPosition);
  }

  void _move(Offset begin, Offset end) {
    _animation = Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addListener(() {
      if (mounted) {
        setState(() {
          _position = _animation!.value;
        });
      }
    })..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        screens.onDragEnd(_position);
        screens.userOnTap?.call();
      }
    });

    _animationController.forward(from: 0.0);
  }*/

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Nếu đang có animation chạy, chúng ta không muốn screens Positioned
    // bị rebuild với giá trị _position cũ từ state trước khi animation listener cập nhật.
    // Tuy nhiên, với cách listener gọi setState, nó sẽ tự động rebuild.
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: WdgBounceButton(
          onPanStart: (_) {
            // Dừng animation nếu người dùng bắt đầu kéo
            if (_animationController.isAnimating) {
              _animationController.stop();
            }
          },
          onPanUpdate: (details) {
            // Dừng animation nếu người dùng kéo trong lúc nó đang chạy
            // (mặc dù onPanStart đã xử lý, nhưng để chắc chắn)
            if (_animationController.isAnimating) {
              _animationController.stop();
            }
            if (mounted) {
              setState(() {
                _position = Offset(
                  _position.dx + details.delta.dx,
                  _position.dy + details.delta.dy,
                );
              });
            }
          },
          onPanEnd: (details) {
            widget.onDragEnd(_position);
          },
          onTap: () {
            // _moveToCenter();
          },
          child: AnimatedOpacity(
            opacity: _currentOpacity,
            duration: const Duration(milliseconds: 100),
            child: Material(
              elevation: 4.0,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              color: primaryColor(context),
              child: Container(
                width: widget.bubbleSize,
                height: widget.bubbleSize,
                alignment: Alignment.center,
                child: widget.child ?? const Icon(Icons.star, color: Colors.white, size: 30),
              ),
            ),
          )
      ),
    );
  }
}