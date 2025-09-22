import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/app/ui/widgets/loading_widget.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';
import 'package:smart_learn/features/flashcard/presentation/screens/flashcard_screen.dart';
import 'package:smart_learn/features/flashcard/presentation/screens/manage/flashcard_manage_screen.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_extenal_bloc/bloc.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_extenal_bloc/event.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_extenal_bloc/state.dart';

class SCRFlashCardExtenal extends StatelessWidget with AppRouterMixin {
  final String? fileId;
  final FlashCardSetForeignParams _params;

  SCRFlashCardExtenal.byFile({super.key, required String this.fileId})
      : _params = FlashCardSetForeignParams.byFileID(fileId: fileId);

  @override
  Widget build(BuildContext context) {
    final color = context.style.color;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color.primaryColor.withValues(alpha: 0.4),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.design_services)
        ),
      ),
      body: CustomPaint(
        painter: _FlashCardBackgroundPainter(color: color.primaryColor),
        child: BlocProvider(
          create: (context) => FlashCardExtenalBloc(getIt(), getIt())
            ..add(FlashCardExtenalLoadOrCreate(params: _params)),
          child: BlocBuilder<FlashCardExtenalBloc, FlashCardExtenalState>(
            builder: (context, state) {
              if (state is FlashCardExtenalLoading) {
                return const Center(child: WdgLoading());
              }

              if (state is FlashCardExtenalLoaded) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// TIÊU ĐỀ + MÔ TẢ ------------------------------------------
                    const Text(
                      "Bộ Flashcard",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "Mẹo: Ôn tập thường xuyên giúp bạn nhớ lâu hơn. "
                            "Hãy bắt đầu hoặc chỉnh sửa bộ flashcard để cá nhân hóa kiến thức của bạn.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 50),

                    /// NÚT BẮT ĐẦU -----------------------------------------
                    _buildCustomButton(
                      label: "🚀 Bắt đầu học",
                      gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.pink],
                      ),
                      onTap: () => pushScale(
                          context,
                          SCRFlashCard(cardSetId: state.flashcardSet.id)),
                    ),
                    const SizedBox(height: 20),

                    /// NÚT SỬA --------------------------------------------
                    _buildCustomButton(
                      label: "✏️ Chỉnh sửa thẻ",
                      gradient: const LinearGradient(
                        colors: [Colors.yellow, Colors.deepOrange],
                      ),
                      onTap: () => pushSlideLeft(
                          context,
                          SCRFlashCardManage(
                              cardSetId: state.flashcardSet.id)),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      )
    );
  }

  /// BUTTON  ------------------------------------------------------------------
  Widget _buildCustomButton({
    required String label,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return WdgBounceButton(
      onTap: onTap,
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// BACKGROUND  ----------------------------------------------------------------
class _FlashCardBackgroundPainter extends CustomPainter {
  final Color color;
  final List<_FlashCardShape> cards;

  _FlashCardBackgroundPainter({required this.color})
      : cards = List.generate(8, (_) {
    final random = Random();
    return _FlashCardShape(
      dx: random.nextDouble(),
      dy: random.nextDouble(),
      width: random.nextDouble() * 100 + 80,  // rộng hơn circle
      height: random.nextDouble() * 60 + 50,  // cao hơn
      rotation: (random.nextDouble() - 0.5) * 0.4, // nghiêng nhẹ
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// NỀN --------------------------------------------------------------------
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      colors: [color.withValues(alpha: 0.4), color.withValues(alpha: 0.6)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    /// THẺ --------------------------------------------------------------------
    final cardPaint = Paint()..color = Colors.white.withValues(alpha: 0.15);
    for (final c in cards) {
      final left = c.dx * size.width;
      final top = c.dy * size.height;

      canvas.save();
      canvas.translate(left, top);
      canvas.rotate(c.rotation);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: const Offset(0, 0),
          width: c.width,
          height: c.height,
        ),
        const Radius.circular(10),
      );
      canvas.drawRRect(rrect, cardPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FlashCardShape {
  final double dx, dy, width, height, rotation;
  _FlashCardShape({
    required this.dx,
    required this.dy,
    required this.width,
    required this.height,
    required this.rotation,
  });
}
