import 'package:flutter/material.dart';
import 'package:smart_learn/data/models/quiz/c_quiz_result.dart';
import 'package:smart_learn/ui/screens/quizscreen/d_check_quiz.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResult quizResult;

  const QuizResultScreen({super.key, required this.quizResult});

  @override
  Widget build(BuildContext context) {
    final int correctCount = quizResult.correctTotal;
    final int total = quizResult.quizTotal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả bài kiểm tra'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 100),

            const SizedBox(height: 24),
            Text(
              'Bạn đã hoàn thành!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),
            Text(
              'Số câu đúng: $correctCount / $total',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),

            const SizedBox(height: 24),
            LinearProgressIndicator(
              value: correctCount / total,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
              minHeight: 10,
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Trang chủ'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QuizCheckScreen(
                            quizs: quizResult.quizs,
                            userAnswers: quizResult.userAnswers)
                    ));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Xem lại'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
