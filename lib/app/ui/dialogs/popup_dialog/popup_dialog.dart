import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'controller.dart';

//--------------------Xác định kiểu tương tác để hiển thị menu popup.
enum PressType {
  /// Menu hiển thị khi người dùng nhấn và giữ.
  longPress,
  /// Menu hiển thị khi người dùng nhấn một lần.
  singleClick,
}

//--------------------Xác định vị trí ưu tiên để hiển thị menu popup so với screen con.
enum PreferredPosition {
  /// Ưu tiên hiển thị menu ở phía trên screen con.
  top,
  /// Ưu tiên hiển thị menu ở phía dưới screen con.
  bottom,
}

//-----------------Định danh cho các child trong CustomMultiChildLayout để sắp xếp menu và mũi tên.
enum _MenuLayoutId {
  /// Định danh cho mũi tên hướng lên.
  arrow,
  /// Định danh cho mũi tên hướng xuống.
  downArrow,
  /// Định danh cho nội dung của menu.
  content,
}

//------------------Các vị trí có thể của menu popup so với screen con.
enum _MenuPosition {
  /// Góc dưới bên trái.
  bottomLeft,
  /// Chính giữa phía dưới.
  bottomCenter,
  /// Góc dưới bên phải.
  bottomRight,
  /// Góc trên bên trái.
  topLeft,
  /// Chính giữa phía trên.
  topCenter,
  /// Góc trên bên phải.
  topRight,
}

class WdgPopupDialog extends StatefulWidget {
  const WdgPopupDialog({
    super.key,
    required this.child,
    required this.menuBuilder,
    required this.pressType,
    this.borderRadius,
    this.controller,
    this.color = const Color(0xFF4C4C4C),
    this.showArrow = true,
    this.barrierColor = Colors.black12,
    this.arrowSize = 10.0,
    this.horizontalMargin = 10.0,
    this.verticalMargin = 10.0,
    this.position,
    this.enablePassEvent = true,
  });

  /// Widget con mà khi tương tác (nhấn hoặc nhấn giữ) sẽ hiển thị menu popup.
  final Widget child;
  /// Xác định kiểu tương tác (nhấn đơn hoặc nhấn giữ) để kích hoạt hiển thị menu.
  final PressType pressType;
  /// Xác định xem có hiển thị mũi tên nhỏ trỏ vào screen con từ menu hay không.
  final bool showArrow;
  /// Màu popup.
  final Color color;
  /// Bo góc
  final BorderRadius? borderRadius;
  /// Màu của lớp phủ (barrier) xuất hiện phía sau menu khi nó được hiển thị.
  final Color barrierColor;
  /// Khoảng cách ngang giữa menu và cạnh của màn hình.
  final double horizontalMargin;
  /// Khoảng cách dọc giữa menu và screen con (nếu có mũi tên) hoặc cạnh của màn hình.
  final double verticalMargin;
  /// Kích thước của mũi tên menu.
  final double arrowSize;
  /// Bộ điều khiển tùy chỉnh để quản lý trạng thái hiển thị của menu. Nếu không được cung cấp, một bộ điều khiển mặc định sẽ được tạo.
  final PopupMenuController? controller;
  /// Hàm builder trả về screen chứa nội dung của menu popup.
  final Widget Function() menuBuilder;
  /// Vị trí ưu tiên để hiển thị menu (trên hoặc dưới screen con). Nếu không được chỉ định, vị trí sẽ được tự động xác định.
  final PreferredPosition? position;

  /// Xác định xem sự kiện chạm có được chuyển đến các screen bên dưới lớp phủ hay không.
  /// Chỉ hoạt động khi [barrierColor] trong suốt.
  final bool enablePassEvent;

  @override
  State createState() => _WdgPopupDialogState();
}

class _WdgPopupDialogState extends State<WdgPopupDialog> with SingleTickerProviderStateMixin {
  // Bộ điều khiển
  PopupMenuController? _controller;
  RenderBox? _childBox;
  RenderBox? _parentBox;
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  //-  Show menu --------------------------------------------------------------
  _showMenu() {
    Widget arrow = ClipPath(
      clipper: _ArrowClipper(),
      child: Container(
        width: widget.arrowSize,
        height: widget.arrowSize,
        color: widget.color,
      ),
    );

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final anchorGlobalPosition = _childBox!.localToGlobal(Offset.zero);
        final anchorCenter = anchorGlobalPosition + _childBox!.size.center(Offset.zero);
        //- Tính toán vị trí bắt đầu và kết thúc animation
        final offset = Offset(
          anchorCenter.dx - _parentBox!.size.width / 2,
          anchorCenter.dy - _parentBox!.size.height / 2,
        );

        Widget menu = AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              origin: offset,
              child: child,
            );
          },
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: _parentBox!.size.width - 2 * widget.horizontalMargin,
                minWidth: 0,
              ),
              child: CustomMultiChildLayout(
                delegate: _MenuLayoutDelegate(
                  anchorSize: _childBox!.size,
                  anchorOffset: _childBox!.localToGlobal(
                    Offset(-widget.horizontalMargin, 0),
                  ),
                  verticalMargin: widget.verticalMargin,
                  position: widget.position,
                ),
                children: <Widget>[
                  widget.showArrow
                      ? LayoutId(
                          id: _MenuLayoutId.arrow,
                          child: arrow,
                        )
                      : LayoutId(
                          id: _MenuLayoutId.downArrow,
                          child: Transform.rotate(
                            angle: math.pi,
                            child: arrow,
                          ),
                        ),
                  LayoutId(
                    id: _MenuLayoutId.content,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Material(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.color,
                              borderRadius: widget.borderRadius
                            ),
                            child: widget.menuBuilder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        return Listener(
          behavior: widget.enablePassEvent
              ? HitTestBehavior.translucent
              : HitTestBehavior.opaque,
          onPointerDown: (PointerDownEvent event) {
            _controller?.hideMenu();
          },
          child: widget.barrierColor == Colors.transparent
              ? menu
              : Container(color: widget.barrierColor, child: menu),
        );
      },
    );
    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
      _animationController.forward();
    }
  }

  //-  Hide menu --------------------------------------------------------------
  _hideMenu() {
    if (_overlayEntry != null) {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _animationController.reset();
      });
    }
  }

  //- Cập nhật view ------------------------------------------------------------
  _updateView() {
    bool menuIsShowing = _controller?.menuIsShowing ?? false;
    if (menuIsShowing) {
      _showMenu();
    } else {
      _hideMenu();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller ??= PopupMenuController();
    _controller?.addListener(_updateView);
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        _childBox = context.findRenderObject() as RenderBox?;
        _parentBox = Overlay.of(context).context.findRenderObject() as RenderBox?;
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.removeListener(_updateView);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child = Material(
      color: Colors.transparent,
      child: GestureDetector(
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: widget.child),
        onTap: () {
          if (widget.pressType == PressType.singleClick) {
            _controller?.showMenu();
          }
        },
        onLongPress: () {
          if (widget.pressType == PressType.longPress) {
            _controller?.showMenu();
          }
        },
      ),
    );
    if (Platform.isIOS) {
      return child;
    } else {
      return PopScope(
        onPopInvokedWithResult: (bool invoked, dynamic result) {
          _hideMenu();
        },
        child: child,
      );
    }
  }
}

/// [_MenuLayoutDelegate] xác định vị trí menu hiển thị và hướng icon mũi tên
class _MenuLayoutDelegate extends MultiChildLayoutDelegate {
  _MenuLayoutDelegate({
    required this.anchorSize,
    required this.anchorOffset,
    required this.verticalMargin,
    this.position,
  });

  /// Kích thước của screen con.
  final Size anchorSize;
  /// Vị trí của screen con trên màn hình.
  final Offset anchorOffset;
  /// Khoảng cách dọc giữa menu và screen con.
  final double verticalMargin;
  /// Vị trí ưu tiên để hiển thị menu.
  final PreferredPosition? position;

  @override
  void performLayout(Size size) {
    Size contentSize = Size.zero;
    Size arrowSize = Size.zero;
    Offset contentOffset = const Offset(0, 0);
    Offset arrowOffset = const Offset(0, 0);

    double anchorCenterX = anchorOffset.dx + anchorSize.width / 2;
    double anchorTopY = anchorOffset.dy;
    double anchorBottomY = anchorTopY + anchorSize.height;
    _MenuPosition menuPosition = _MenuPosition.bottomCenter;

    if (hasChild(_MenuLayoutId.content)) {
      contentSize = layoutChild(
        _MenuLayoutId.content,
        BoxConstraints.loose(size),
      );
    }
    if (hasChild(_MenuLayoutId.arrow)) {
      arrowSize = layoutChild(
        _MenuLayoutId.arrow,
        BoxConstraints.loose(size),
      );
    }
    if (hasChild(_MenuLayoutId.downArrow)) {
      layoutChild(
        _MenuLayoutId.downArrow,
        BoxConstraints.loose(size),
      );
    }

    bool isTop = false;
    if (position == null) {
      isTop = anchorBottomY > size.height / 2;
    } else {
      isTop = position == PreferredPosition.top;
    }
    if (anchorCenterX - contentSize.width / 2 < 0) {
      menuPosition = isTop ? _MenuPosition.topLeft : _MenuPosition.bottomLeft;
    } else if (anchorCenterX + contentSize.width / 2 > size.width) {
      menuPosition = isTop ? _MenuPosition.topRight : _MenuPosition.bottomRight;
    } else {
      menuPosition = isTop ? _MenuPosition.topCenter : _MenuPosition.bottomCenter;
    }

    switch (menuPosition) {
      case _MenuPosition.bottomCenter:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorBottomY + verticalMargin,
        );
        contentOffset = Offset(
          anchorCenterX - contentSize.width / 2,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.bottomLeft:
        arrowOffset = Offset(
            anchorCenterX - arrowSize.width / 2,
            anchorBottomY + verticalMargin);
        contentOffset = Offset(
          0,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.bottomRight:
        arrowOffset = Offset(
            anchorCenterX - arrowSize.width / 2,
            anchorBottomY + verticalMargin);
        contentOffset = Offset(
          size.width - contentSize.width,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.topCenter:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          anchorCenterX - contentSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
      case _MenuPosition.topLeft:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          0,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
      case _MenuPosition.topRight:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          size.width - contentSize.width,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
    }
    if (hasChild(_MenuLayoutId.content)) {
      positionChild(_MenuLayoutId.content, contentOffset);
    }

    bool isBottom = false;
    if (_MenuPosition.values.indexOf(menuPosition) < 3) {
      isBottom = true;
    }
    if (hasChild(_MenuLayoutId.arrow)) {
      positionChild(
        _MenuLayoutId.arrow,
        isBottom
            ? Offset(arrowOffset.dx, arrowOffset.dy + 0.1)
            : const Offset(-100, 0),
      );
    }
    if (hasChild(_MenuLayoutId.downArrow)) {
      positionChild(
        _MenuLayoutId.downArrow,
        !isBottom
            ? Offset(arrowOffset.dx, arrowOffset.dy - 0.1)
            : const Offset(-100, 0),
      );
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}

///-----------------------Vẽ con trỏ ------------------------------------------
class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
