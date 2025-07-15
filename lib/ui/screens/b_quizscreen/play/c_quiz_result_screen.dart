import 'package:flutter/material.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/data/models/quiz/c_quiz_result.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/performers/action_unit/quiz_action/quiz_action.dart';
import 'package:smart_learn/ui/widgets/circular_progressbar_widget.dart';

import '../../../../performers/performer/quiz_performer.dart';
import 'd_check_quiz.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResult quizResult;

  const QuizResultScreen({super.key, required this.quizResult});

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            _WdgHead(),

            Expanded(child: _QuizResultCard(quizResult: quizResult)),

            _WdgFootAction(quizResult),
          ],
    );
  }
}

///---  Phần đầu  -------------------------------------------------------------
class _WdgHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        padding: const EdgeInsets.only(top: 50.0, bottom: 60.0),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor(context).withAlpha(50), primaryColor(context).withAlpha(50)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor(context).withAlpha(15),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
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
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0.0, size.height);

    var firstControlPoint = Offset(size.width / 4, size.height - 30);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 10);
    var secondEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

///-  Phần kết quả  ---------------------------------------------------------
class _QuizResultCard extends StatelessWidget {
  final QuizResult quizResult;

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
class _WdgFootAction extends StatelessWidget {
  final QuizResult quizResult;

  const _WdgFootAction(this.quizResult);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuizCheckScreen(
                          quizs: quizResult.quizs,
                          userAnswers: quizResult.userAnswers)
                  ));
                },
                icon: const Icon(Icons.history_edu, size: 28),
                label: const Text(
                  'Xem Lại Bài Làm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor(context).withAlpha(150),
                  side: const BorderSide(color: Colors.grey, width: 2),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),

            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  PerformerProvider.of<QuizReviewPerformer>(context).add(StartQuiz(quizResult.quizs));
                },
                icon: const Icon(Icons.refresh, size: 28),
                label: const Text(
                  'Làm Lại Bài Tập',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor(context).withAlpha(150),
                  side: const BorderSide(color: Colors.grey, width: 2),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            )
          ]),

          const SizedBox(height: 15),

          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primaryColor(context).withAlpha(200),
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 8,
            ),
            child: const Text(
              'Hoàn Thành',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}