import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_bloc/bloc.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_bloc/event.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_bloc/state.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/ui/widgets/divider_widget.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';
import 'package:confetti/confetti.dart';

class SCRFlashCard extends StatefulWidget {
  final String cardSetId;
  const SCRFlashCard({super.key, required this.cardSetId});

  @override
  State<StatefulWidget> createState() => _SCRFlashCardState();
}

class _SCRFlashCardState extends State<SCRFlashCard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard'),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.design_services)
        ),
      ),

      body: BlocProvider<FlashCardBloc>(
        create: (context) => FlashCardBloc(getIt(), getIt(), getIt())..add(FlashCardLoadBySetId(widget.cardSetId)),
        child: BlocBuilder<FlashCardBloc, FlashCardState>(builder: (context, state) {
          if (state is FlashCardNoData) {
            if(state is FlashCardLoading) {
              return const Center(child: WdgLoading());
            }
            return const Center(child: Text('No data'));
          }

          if (state is FlashCardHasData) {
            if(state is FlashCardCurrent) {
              return _FlashCardCurrent(state: state);
            }

            return _FlashCardCompletedScreen(
                data: state as FlashCardCompleted,
                onRestartAll: () {
                  context.read<FlashCardBloc>().add(ResetAll());
                },
                onRestartDontRemember: () {
                  context.read<FlashCardBloc>().add(ReviewDontRememberEvent());
                }
            );
          }

          return const SizedBox();
        }),
      ),
    );
  }
}

/// THẺ HIỆN TẠI  --------------------------------------------------------------
class _FlashCardCurrent extends StatelessWidget {
  final FlashCardCurrent state;
  const _FlashCardCurrent({required this.state});

  @override
  Widget build(BuildContext context) {
    final card = state.card;
    return Column(children: [

      /// HEADER THÔNG TIN  -------------------------------------------------
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Tooltip(
                message: 'Chưa nhớ',
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: Colors.red
                      )
                  ),
                  child: Text('${state.totalDontRemember}',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.w700)
                  ),
                ),
              ),

              Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: state.currentIndex / state.total,
                          backgroundColor: Colors.grey.withValues(
                              alpha: 0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              primaryColor(context).withValues(
                                  alpha: 0.5)),
                          minHeight: 20,
                        ),
                      ),
                      Text(
                        "${state.currentIndex} / ${state.total}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )

              ),

              Tooltip(
                message: 'Đã nhớ',
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: Colors.green
                      )
                  ),
                  child: Text('${state.totalRemember}',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.w700)
                  ),
                ),
              )
            ],
          )
      ),

      const SizedBox(height: 10),

      /// THẺ CARD  ---------------------------------------------------------
      Expanded(child: _FlashCardFlip(
          key: GlobalKey(),
          card: card,
          onRemember: () {
            context.read<FlashCardBloc>().add(FlashCardUpdateStatus.remember(card));
          },
          onDontRemember: () {
            context.read<FlashCardBloc>().add(FlashCardUpdateStatus.dontRemember(card));
          }
      )),

      const WdgDivider(height: 5),
      const SizedBox(height: 10),

      /// BUTTONS --------------------------------------------------------------
      Row(
        children: [
          const SizedBox(width: 20),
          WdgBounceButton(
              scaleFactor: 0.6,
              child: const Icon(Icons.arrow_back, size: 35, color: Colors.grey),
              onTap: () {
                context.read<FlashCardBloc>().add(FlashCardBack());
              }
          ),
          const SizedBox(width: 20),

          WdgBounceButton(
              scaleFactor: 0.6,
              child: const Icon(Icons.restart_alt_outlined, size: 35, color: Colors.grey),
              onTap: () {
                context.read<FlashCardBloc>().add(ResetAll());
              }
          ),

        ],
      ),

      const SizedBox(height: 10),
    ]);
  }
}

/// THẺ LẬT -------------------------------------------------------------------------
class _FlashCardFlip extends StatefulWidget {
  final ENTFlashCard card;
  final VoidCallback onRemember;
  final VoidCallback onDontRemember;

  const _FlashCardFlip({
    super.key,
    required this.card,
    required this.onRemember,
    required this.onDontRemember,
  });

  @override
  State<_FlashCardFlip> createState() => _FlashCardFlipState();
}

class _FlashCardFlipState extends State<_FlashCardFlip> with TickerProviderStateMixin {
  final pi = 3.14;
  bool isFront = true;
  double _rotationZ = 0;
  double _top = 0;
  double _left = 0;

  bool init = false;
  late final double cardHeight;
  late final double cardWidth;
  late final double cardTop;
  late final double cardLeft;

  int _positionDuration = 20;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          final maxWidth = constraints.maxWidth;

          if(!init) {
            init = true;
            cardHeight = maxHeight * 0.9;
            cardWidth = maxWidth * 0.8;
            cardTop = maxHeight / 2 - cardHeight / 2;
            _top = cardTop;
            cardLeft = maxWidth / 2 - cardWidth / 2;
            _left = cardLeft;
          }

          return Stack(
            children: [
              AnimatedPositioned(
                top: _top,
                left: _left,
                duration: Duration(milliseconds: _positionDuration),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _toggleCard,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: (details) => _onPanEnd(details, maxHeight, maxWidth),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) {
                      final rotate = Tween(begin: isFront ? 0.0 : pi, end: isFront ? pi : 0.0).animate(anim);
                      return AnimatedBuilder(
                        animation: rotate,
                        child: child,
                        builder: (context, child) {
                          var tilt = ((anim.value - 0.5).abs() - 0.5) * 0.0015;
                          final isUnder = (ValueKey(isFront) != child!.key);
                          final rotationY = rotate.value;
                          return Transform(
                            transform: Matrix4.identity()
                              ..rotateZ(_rotationZ)
                              ..rotateY(rotationY)
                              ..setEntry(3, 0, tilt),
                            alignment: Alignment.center,
                            child: Opacity(
                            opacity: isUnder ? 0 : 1,
                            child: child
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      key: ValueKey(isFront),
                      width: cardWidth,
                      height: cardHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.alphaBlend(primaryColor(context), Colors.grey).withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 1.5,
                          color: primaryColor(context).withValues(alpha: 0.5),
                        ),
                      ),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..scale(isFront ? -1.0 : 1.0, 1.0, 1.0),
                          child: Stack(
                            children: [
                              if(widget.card.isDontRemember)
                                const Positioned(
                                  top: 5,
                                  left: 5,
                                  child: Text('Chưa nhớ', style: TextStyle(color: Colors.redAccent))
                                ),

                              if(widget.card.isRemember)
                                const Positioned(
                                  top: 5,
                                  left: 5,
                                  child: Text('Đã nhớ', style: TextStyle(color: Colors.green))
                                ),

                              Center(
                                child: Text(
                                  isFront ? widget.card.front : widget.card.back,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          )
                        )

                    ),
                  ),
                ),
              )
            ],
          );
        }
    );
  }

  void _toggleCard() {
    setState(() {
      isFront = !isFront;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _positionDuration = 10;
      _top += details.delta.dy;
      _left += details.delta.dx;
      _rotationZ = _left / cardWidth;
    });
  }

  void _onPanEnd(DragEndDetails details, double maxHeight, double maxWidth) async {
    double velocityX = details.velocity.pixelsPerSecond.dx;
    double velocityY = details.velocity.pixelsPerSecond.dy;

    const double flingThreshold = 2003;
    double distanceX = velocityX / flingThreshold;
    double distanceY = velocityY / flingThreshold;

    setState(() {
      if (velocityX.abs() > flingThreshold || velocityY.abs() > flingThreshold) {
        _positionDuration = 150;
        _left += maxWidth / distanceX + maxWidth * 0.2;
        _top += maxHeight / distanceY + maxHeight * 0.1;
        _rotationZ = _left / cardWidth;

      } else if (_left + cardWidth * 0.66 > maxWidth / 10 && _left + cardWidth * 0.33 < maxWidth - maxWidth / 10) {
        _positionDuration = 50;
        _top = cardTop;
        _left = cardLeft;
        _rotationZ = 0;

      } else {
        _positionDuration = 200;
        _top += maxHeight / 2;
        _left += _left < maxWidth / 2 ? -maxWidth : maxWidth + maxWidth / 2;
      }
    });

    await Future.delayed(Duration(milliseconds: _positionDuration + 100));
    if (_left < 0) {
      widget.onDontRemember();
    } else if (_left > maxWidth) {
      widget.onRemember();
    }
  }
}

/// HOÀN THÀNH  ----------------------------------------------------------------------
class _FlashCardCompletedScreen extends StatefulWidget {
  final FlashCardCompleted data;
  final VoidCallback onRestartAll;
  final VoidCallback onRestartDontRemember;

  const _FlashCardCompletedScreen({
    required this.data,
    required this.onRestartAll,
    required this.onRestartDontRemember,
  });

  @override
  State<_FlashCardCompletedScreen> createState() => _FlashCardCompletedScreenState();
}

class _FlashCardCompletedScreenState extends State<_FlashCardCompletedScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final double percentRemember = data.total == 0 ? 0 : data.totalRemember / data.total;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// NỘI DUNG  --------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 100),

                /// VÒNG TRÒN ---------------------------------------------------
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0, end: percentRemember),
                  curve: Curves.easeOutBack,
                  builder: (context, value, _) {
                    return Transform.scale(
                      scale: 1 + (0.1 * value),
                      child: CustomPaint(
                        size: const Size(140, 140),
                        painter: _CircleProgressPainter(value),
                        child: Center(
                          child: Text(
                            "${(value * 100).toStringAsFixed(0)}%",
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 100),

                /// THÔNG TIN --------------------------------------------------
                const Text("Bạn đã hoàn thành", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),

                const SizedBox(height: 8),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Nhớ: ${data.totalRemember}",
                      style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.style, color: Colors.green),
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Chưa nhớ: ${data.totalDontRemember}",
                      style: const TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.style, color: Colors.redAccent),
                  ],
                ),

                const Expanded(child: SizedBox()),

                /// BUTTON -----------------------------------------------------
                WdgBounceButton(
                  onTap: widget.onRestartAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.cyan)
                    ),
                    child: const Text('Làm lại tất cả', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                ),

                const SizedBox(height: 12),

                if(data.totalDontRemember > 0)
                  WdgBounceButton(
                    onTap: widget.onRestartDontRemember,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.purpleAccent)
                      ),
                      child: const Text('Ôn lại phần chưa nhớ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                    ),
                  ),

                const SizedBox(height: 12),
              ],
            ),
          ),

          /// BẮN PHÁO HOA  ----------------------------------------------------
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple, Colors.yellow, Colors.red],
          ),
        ],
      ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  _CircleProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 10.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 5;

    final basePaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.greenAccent, Colors.yellowAccent, Colors.redAccent],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, basePaint);
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(_CircleProgressPainter oldDelegate) => oldDelegate.progress != progress;
}
