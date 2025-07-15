import 'package:flutter/material.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/performers/action_unit/quiz_action/quiz_action.dart';
import 'package:smart_learn/performers/performer/quiz_performer.dart';
import 'package:smart_learn/performers/data_state/quiz_state.dart';
import 'package:smart_learn/data/models/quiz/a_quiz.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/screens/b_quizscreen/play/quizs/a_quiz_widget.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';
import 'package:smart_learn/ui/widgets/popup_menu_widget.dart';

import '../../../dialogs/popup_dialog/controller.dart';
import 'c_quiz_result_screen.dart';

class QuizReviewScreen extends StatefulWidget {
  final List<Quiz> quizs;

  const QuizReviewScreen({super.key, required this.quizs});

  @override
  State<StatefulWidget> createState() => _QuizReviewScreenState();
}

class _QuizReviewScreenState extends State<QuizReviewScreen> {
  int currentIndex = 0;
  final PopupMenuController controller = PopupMenuController();

  //--- Chuyển quiz ---------------------------------
  void next() {
    if (currentIndex < widget.quizs.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  //--- Quay lại -------------------------------------
  void previous() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PerformerProvider<QuizReviewPerformer>.create(
      create: (_) => QuizReviewPerformer()..add(StartQuiz(widget.quizs)),
      child: PerformerBuilder<QuizReviewPerformer>(
        builder: (context, performer) {
          final state = performer.current;
          if (state is QuizInitState) {
            return const Center(child: WdgLoading());
          }

          if (state is QuizStateProgress) {
            return Column(
              children: [
                /// --- Nộp bài và thanh chọn câu hỏi ---------------------------------------
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Opacity(opacity: state.isCompleted ? 1 : 0.3,
                        child: GestureDetector(
                          onTap: () {
                            if(state.isCompleted) {
                              currentIndex = 0;
                              performer.add(CompletedQuiz());
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text('Hoàn thành',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor(context))
                            ),
                          )
                        ),
                      ),

                      const SizedBox(width: 12),

                      WdgPopupMenuCustom(
                          item: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            margin: const EdgeInsets.all(8),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: List.generate(widget.quizs.length, (index) {
                                final isCurrent = index == currentIndex;
                                final isAnswered = performer.current.userAnswers[index] != null;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = index;
                                      controller.hideMenu();
                                    });
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isCurrent
                                            ? primaryColor(context)
                                            : isAnswered
                                            ? Colors.yellow
                                            : Colors.grey,
                                        width: 2,
                                      ),
                                      color: isCurrent
                                          ? primaryColor(context).withAlpha(10)
                                          : Colors.transparent,
                                    ),
                                    child: Text('${index + 1}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isCurrent
                                            ? primaryColor(context)
                                            : isAnswered
                                            ? Colors.orange
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          controller: controller,
                          child: const Icon(Icons.dashboard)
                      ),
                    ]
                ),

                /// --- Câu hỏi ---------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Câu hỏi: ${widget.quizs[currentIndex].question}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                /// --- Widget Quiz -----------------------------------------------
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: WdgQuiz.build(
                      widget.quizs[currentIndex],
                      userAnswer: performer.current.userAnswers[currentIndex],
                      onAnswered: (userAnswer) {
                        performer.add(SaveQuiz(currentIndex, userAnswer));
                      },
                    ),
                  ),
                ),

                /// --- Điều hướng -------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: previous,
                          icon: const Icon(Icons.arrow_back),
                          label: Text(globalLanguage.previous),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentIndex == 0
                                ? Colors.grey.shade400
                                : primaryColor(context).withAlpha(100),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: next,
                          icon: Text(globalLanguage.next),
                          label: const Icon(Icons.arrow_forward),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentIndex == widget.quizs.length - 1
                                    ? Colors.grey.shade400
                                    : primaryColor(context).withAlpha(100),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }

          else if(state is QuizStateCompleted) {
            return QuizResultScreen(quizResult: state.quizResult);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
