import 'dart:async';
import 'package:flutter/material.dart';

class AppFloatingBubbleService {
  static final ValueNotifier isVisibled = ValueNotifier(false);
  static OverlayEntry? _overlayEntry;
  static Offset _currentPosition = const Offset(50, 100);
  static const double _bubbleSize = 50.0;

  static OverlayEntry? _dimmingOverlayEntry;
  static double _dimmingTargetOpacity = 0.0;
  static const Duration _dimmingAnimationDuration = Duration(milliseconds: 300);

  static final GlobalKey<_DraggableBubbleState> _bubbleKey =
  GlobalKey<_DraggableBubbleState>();

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
          onPositionChanged: (newPosition) {
            _currentPosition = newPosition;
          },
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    AppFloatingBubbleService.isVisibled.value = true;
  }

  static void hideBubble() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    AppFloatingBubbleService.isVisibled.value = false;
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
      Offset positionToShow =
      (initialPosition == const Offset(50, 100) &&
          _currentPosition != const Offset(50, 100))
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

  static void visible() {
    if (isBubbleVisible && _bubbleKey.currentState != null) {
      _bubbleKey.currentState!._setOpacity(1.0);
    }
  }

  static void fade() {
    if (isBubbleVisible && _bubbleKey.currentState != null) {
      _bubbleKey.currentState!._setOpacity(0.0);
    }
  }

  // Hiển thị lớp phủ mờ
  static void showDimmingLayer(BuildContext context) {
    if (_dimmingOverlayEntry != null) {
      _dimmingTargetOpacity = 0.5;
      _dimmingOverlayEntry?.markNeedsBuild();
      return;
    }

    _dimmingTargetOpacity = 0.0;

    _dimmingOverlayEntry = OverlayEntry(builder: (context) {
      return AnimatedOpacity(
        opacity: _dimmingTargetOpacity,
        duration: _dimmingAnimationDuration,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            color: Colors.black,
          ),
        ),
        onEnd: () {
          if (_dimmingTargetOpacity == 0.0 && _dimmingOverlayEntry != null) {
            _dimmingOverlayEntry?.remove();
            _dimmingOverlayEntry = null;
          }
        },
      );
    });
    Overlay.of(context).insert(_dimmingOverlayEntry!);

    // Kích hoạt animation cho AnimatedOpacity sau khi frame được build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dimmingOverlayEntry != null && _dimmingTargetOpacity != 0.5) {
        _dimmingTargetOpacity = 0.5;
        _dimmingOverlayEntry?.markNeedsBuild();
      }
    });
  }

  // Ẩn lớp phủ mờ
  static void hideDimmingLayer() {
    if (_dimmingOverlayEntry == null && _dimmingTargetOpacity == 0.0) return;

    _dimmingTargetOpacity = 0.0;
    _dimmingOverlayEntry?.markNeedsBuild();
  }
}

class _DraggableBubble extends StatefulWidget {
  final Offset initialPosition;
  final double bubbleSize;
  final VoidCallback? userOnTap;
  final Widget? child;
  final Function(Offset) onPositionChanged;

  const _DraggableBubble({
    super.key,
    required this.initialPosition,
    required this.bubbleSize,
    this.userOnTap,
    this.child,
    required this.onPositionChanged,
  });

  @override
  _DraggableBubbleState createState() => _DraggableBubbleState();
}

class _DraggableBubbleState extends State<_DraggableBubble> with SingleTickerProviderStateMixin {
  late Offset _position;
  double _currentOpacity = 1.0;

  Timer? _fadeTimer;
  late AnimationController _controller;
  Animation<Offset>? _activeAnimation;
  VoidCallback? _activeListener;

  static const double _sideMargin = 16.0;
  static const double _fadeOpacity = 0.3;
  static const Duration _snapDuration = Duration(milliseconds: 600);
  static const Duration _fadeDelay = Duration(seconds: 2);
  static const Duration _fadeDuration = Duration(milliseconds: 500);
  static const double _flingThreshold = 800.0;
  static const double _flingProjectionFactor = 0.1;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
    _currentOpacity = 1.0;
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clampToBounds();
      _startFadeTimer();
      widget.onPositionChanged(_position);
    });
  }

  @override
  void dispose() {
    _fadeTimer?.cancel();
    _removeActiveAnimationListener();
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onTapDown: (_) {
          _cancelFadeTimerAndShow();
          _removeActiveAnimationListener();
          _controller.stop();
        },
        onTap: () {
          _cancelFadeTimerAndShow();
          widget.userOnTap?.call();
        },
        onPanStart: (_) {
          _cancelFadeTimerAndShow();
          _removeActiveAnimationListener();
          _controller.stop();
        },
        onPanUpdate: (details) {
          _cancelFadeTimerAndShow();
          setState(() {
            _position = Offset(
              _position.dx + details.delta.dx,
              _position.dy + details.delta.dy,
            );
          });
          _clampToBounds();
        },
        onPanEnd: (details) async {
          _startFadeTimer();
          final velocity = details.velocity.pixelsPerSecond;
          final speed = velocity.distance;

          final sizeScreen = _screenSize();
          final screenW = sizeScreen.width;
          final screenH = sizeScreen.height;
          final media = MediaQuery.of(context);
          final topInset = media.padding.top;
          final bottomInset = media.padding.bottom;

          const minX = _sideMargin;
          final maxX = screenW - widget.bubbleSize - _sideMargin;
          final maxY = screenH - widget.bubbleSize - bottomInset - _sideMargin;
          final minY = topInset + _sideMargin;

          if (speed > _flingThreshold) {
            // project target from velocity
            double projectedX = _position.dx + velocity.dx * _flingProjectionFactor;
            double projectedY = _position.dy + velocity.dy * _flingProjectionFactor;

            // Clamp so projected point never goes outside horizontal bounds
            projectedX = projectedX.clamp(minX, maxX);
            // Clamp vertical as before
            projectedY = projectedY.clamp(minY, maxY);

            final proj = Offset(projectedX, projectedY);

            final distance = (proj - _position).distance;
            final estimatedMs = ((distance / speed) * 1000 * 1.6).clamp(180, 700).toInt();
            await _animateTo(proj, duration: Duration(milliseconds: estimatedMs), curve: Curves.decelerate);

            await _snapToEdge(projected: proj);
          } else {
            await _snapToEdge();
          }
        },
        child: AnimatedOpacity(
          opacity: _currentOpacity,
          duration: _fadeDuration,
          child: Material(
            elevation: 6,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            color: Theme.of(context).primaryColor,
            child: Container(
              width: widget.bubbleSize,
              height: widget.bubbleSize,
              alignment: Alignment.center,
              child: widget.child ?? const Icon(Icons.star, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
    );
  }

  /// Độ mờ khi không chạm  ====================================================
  void _setOpacity(double v) {
    _fadeTimer?.cancel();
    if (mounted) setState(() => _currentOpacity = v);
    if (v == 1.0) _startFadeTimer();
  }

  /// Set thời gian mờ sau khi thả  ============================================
  void _startFadeTimer() {
    _fadeTimer?.cancel();
    _fadeTimer = Timer(_fadeDelay, () {
      if (!mounted) return;
      setState(() {
        _currentOpacity = _fadeOpacity;
      });
    });
  }

  /// Hủy làm mờ khi nhấn ======================================================
  void _cancelFadeTimerAndShow() {
    _fadeTimer?.cancel();
    if (_currentOpacity != 1.0 && mounted) {
      setState(() {
        _currentOpacity = 1.0;
      });
    }
  }

  /// Tính toán kích thước  ====================================================
  Size _screenSize() {
    final mq = MediaQuery.of(context);
    return Size(mq.size.width, mq.size.height - mq.padding.top - mq.padding.bottom);
  }

  /// Tính toán vị trí không tràn màn hình  ====================================
  void _clampToBounds() {
    final media = MediaQuery.of(context);
    final screenW = media.size.width;
    final topInset = media.padding.top;
    final bottomInset = media.padding.bottom;
    final maxX = screenW - widget.bubbleSize - _sideMargin;
    final maxY = MediaQuery.of(context).size.height - widget.bubbleSize - bottomInset - _sideMargin;
    final minY = topInset + _sideMargin;

    double dx = _position.dx;
    double dy = _position.dy;

    if (dx < _sideMargin) dx = _sideMargin;
    if (dx > maxX) dx = maxX;

    if (dy < minY) dy = minY;
    if (dy > maxY) dy = maxY;

    if (dx != _position.dx || dy != _position.dy) {
      setState(() => _position = Offset(dx, dy));
      widget.onPositionChanged(_position);
    }
  }

  /// Xóa lắng nghe animation cũ  ==============================================
  void _removeActiveAnimationListener() {
    if (_activeAnimation != null && _activeListener != null) {
      _controller.removeListener(_activeListener!);
      _activeListener = null;
      _activeAnimation = null;
    }
  }

  /// Bắt đầu hiệu ứng chuyển động  ============================================
  Future<void> _animateTo(Offset target, {Duration? duration, Curve curve = Curves.decelerate}) async {
    _removeActiveAnimationListener();
    _controller.stop();
    _controller.reset();

    // clamp begin and target
    final media = MediaQuery.of(context);
    final screenW = media.size.width;
    final topInset = media.padding.top;
    final bottomInset = media.padding.bottom;
    final maxX = screenW - widget.bubbleSize - _sideMargin;
    final maxY = MediaQuery.of(context).size.height - widget.bubbleSize - bottomInset - _sideMargin;
    final minY = topInset + _sideMargin;

    final begin = Offset(
      _position.dx.clamp(_sideMargin, maxX),
      _position.dy.clamp(minY, maxY),
    );
    final end = Offset(
      target.dx.clamp(-screenW * 2, screenW * 2), // allow x projection a bit out, but not NaN
      target.dy.clamp(minY, maxY),
    );

    _activeAnimation = Tween<Offset>(begin: begin, end: end).animate(CurvedAnimation(parent: _controller, curve: curve));
    _activeListener = () {
      if (!mounted || _activeAnimation == null) return;
      setState(() {
        _position = _activeAnimation!.value;
      });
    };

    _controller.duration = Duration(milliseconds: duration?.inMilliseconds ?? ((200 + (begin - end).distance * 0.6).clamp(120, 800).toInt()));
    _controller.addListener(_activeListener!);

    try {
      await _controller.forward().orCancel;
    } catch (_) {
      // cancelled
    } finally {
      // final fix-up: ensure pos clamped and saved
      _removeActiveAnimationListener();
      _clampToBounds();
      widget.onPositionChanged(_position);
    }
  }

  /// Di chuyển vào rìa ========================================================
  Future<void> _snapToEdge({Offset? projected}) async {
    final media = MediaQuery.of(context);
    final screenW = media.size.width;
    final bottomInset = media.padding.bottom;
    final topInset = media.padding.top;
    final maxY = MediaQuery.of(context).size.height - widget.bubbleSize - bottomInset - _sideMargin;
    final minY = topInset + _sideMargin;

    Offset proj = projected ?? _position;
    double py = proj.dy.clamp(minY, maxY);

    final centerX = proj.dx + widget.bubbleSize / 2;
    final bool snapLeft = centerX < screenW / 2;
    final targetX = snapLeft ? _sideMargin : (screenW - widget.bubbleSize - _sideMargin);
    final target = Offset(targetX, py);

    await _animateTo(target, duration: _snapDuration, curve: Curves.easeOutCubic);
  }
}
