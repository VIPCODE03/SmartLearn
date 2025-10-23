import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/features/quiz/presentation/screens/editor/a_quiz_manage_screen.dart';
import 'package:smart_learn/features/quiz/presentation/screens/play/a_quiz_screen.dart';

class SCRQuizExtenal extends StatelessWidget with AppRouterMixin {
  final String? fileId;
  SCRQuizExtenal.byFile({super.key, required String this.fileId});
  
  @override
  Widget build(BuildContext context) {
    final primaryColor = context.style.color.primaryColor;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor.withValues(alpha: 0.4),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.design_services)
          ),
        ),
        body: CustomPaint(
          painter: _QuizBackgroundPainter(color: primaryColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width),

              /// TIÊU ĐỀ + MÔ TẢ ------------------------------------------
              Text(
                globalLanguage.quiz,
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  globalLanguage.tipLearn,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              const SizedBox(height: 50),

              /// NÚT BẮT ĐẦU -----------------------------------------
              _buildCustomButton(
                label: "🚀 ${globalLanguage.start}",
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                ),
                onTap: () => pushScale(
                    context,
                    SCRQuizPlay.reviewByFileID(fileId: fileId!)
                ),
              ),
              const SizedBox(height: 20),

              /// NÚT SỬA --------------------------------------------
              _buildCustomButton(
                label: "✏️ ${globalLanguage.edit}",
                gradient: const LinearGradient(
                  colors: [Colors.yellow, Colors.deepOrange],
                ),
                onTap: () => pushSlideLeft(
                    context,
                    SCRQuizManage.byFile(fileId: fileId!, title: ''))
              ),
            ],
          )
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
class _QuizBackgroundPainter extends CustomPainter {
  final Color color;
  final List<_QuizCardShape> cards;

  _QuizBackgroundPainter({required this.color})
      : cards = List.generate(8, (_) {
    final random = Random();
    return _QuizCardShape(
      dx: random.nextDouble(),
      dy: random.nextDouble(),
      width: random.nextDouble() * 100 + 80,
      height: random.nextDouble() * 60 + 50,
      rotation: (random.nextDouble() - 0.5) * 0.4,
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

    /// THẺ QUIZ ---------------------------------------------------------------
    final cardPaint = Paint()..color = Colors.white.withValues(alpha: 0.15);
    for (final c in cards) {
      final left = c.dx * size.width;
      final top = c.dy * size.height;

      canvas.save();
      canvas.translate(left, top);
      canvas.rotate(c.rotation);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: c.width,
          height: c.height,
        ),
        const Radius.circular(12),
      );
      canvas.drawRRect(rrect, cardPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QuizCardShape {
  final double dx, dy, width, height, rotation;
  _QuizCardShape({
    required this.dx,
    required this.dy,
    required this.width,
    required this.height,
    required this.rotation,
  });
}

