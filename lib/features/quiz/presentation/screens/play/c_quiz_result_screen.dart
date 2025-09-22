import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/features/quiz/domain/entities/c_quiz_result_entity.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quiz_play_performer/quizplay_action.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quiz_play_performer/quizplay_performer.dart';
import 'package:smart_learn/app/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/app/ui/widgets/circular_progressbar_widget.dart';
import 'd_check_quiz.dart';

class SCRQuizResult extends StatefulWidget {
  final ENTQuizResult quizResult;
  const SCRQuizResult({super.key, required this.quizResult});

  @override
  State<StatefulWidget> createState() => _SCRQuizResultState();
}

class _SCRQuizResultState extends State<SCRQuizResult> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        /// THÔNG TIN -----------------------------------------------------------
        Column(
          children: [
            _WdgHead(),
            Expanded(child: _QuizResultCard(quizResult: widget.quizResult)),
            _WIDFootAction(widget.quizResult),
          ],
        ),

        /// BẮN PHÁO HOA  ----------------------------------------------------
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple, Colors.yellow, Colors.red],
        ),
      ],
    );
  }
}

///---  Phần đầu  -------------------------------------------------------------
class _WdgHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50.0, bottom: 60.0),
      width: double.infinity,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80.0,
          ),
          SizedBox(height: 10.0),
          Text(
            "Hoàn Thành Xuất Sắc!",
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.0),
          Text(
            "Chúc mừng bạn đã hoàn thành bài tập!",
            style: TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

///-  Phần kết quả  ---------------------------------------------------------
class _QuizResultCard extends StatelessWidget {
  final ENTQuizResult quizResult;

  const _QuizResultCard({
    required this.quizResult,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),

      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Kết Quả Của Bạn',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Row(
              children: [
                ///-  Hiển thị vòng tròn  --------------------------------------
                SizedBox(
                  height: 160,
                  width: 160,
                  child: WdgCircularProgressBar(
                    percentage: quizResult.correctTotal / quizResult.quizTotal,
                    progressColor: Colors.green.shade600,
                    backgroundColor: Colors.red.shade200,
                    radius: 50.0,
                    strokeWidth: 12.0,
                  ),
                ),

                ///-  Hiển thị số câu đúng/sai  -----------------------------------
                Expanded(
                  child: Column(
                    children: [
                      _buildTextItem('Đúng: ${quizResult.correctTotal}', Colors.green.shade600, Icons.check_circle),

                      const SizedBox(height: 15),

                      _buildTextItem('Sai: ${quizResult.wrongTotal}', Colors.red.shade200, Icons.cancel),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextItem(String text, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

///-  Phần hành động  ------------------------------------------------------
class _WIDFootAction extends StatelessWidget with AppRouterMixin {
  final ENTQuizResult quizResult;

  const _WIDFootAction(this.quizResult);

  @override
  Widget build(BuildContext context) {
    final color = context.style.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          Row(children: [
            Expanded(
                child: _buildButton('Làm lại', Icons.refresh, color.primaryColor, () {
                  PerformerProvider.of<QuizReviewPerformer>(context).add(StartQuiz(quizResult.quizs));
                })
            ),

            const SizedBox(width: 15),

            Expanded(
              child: _buildButton('Xem lại', Icons.history_edu, color.primaryColor, () {
                pushSlideLeft(context, SCRQuizCheck(
                    quizs: quizResult.quizs,
                    userAnswers: quizResult.userAnswers)
                );
              })
            ),
          ]),

          const SizedBox(height: 15),

          WdgBounceButton(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: color.primaryColor.withValues(alpha: 0.4),
              ),
              child: const Text(
                'Hoàn Thành',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return WdgBounceButton(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(15),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ]
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(width: 5),
              Text(
                text,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
        )
    );
  }
}

