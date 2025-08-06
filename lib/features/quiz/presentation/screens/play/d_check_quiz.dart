import 'package:flutter/material.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/presentation/screens/play/quizs/a_quiz_widget.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/dialogs/popup_dialog/controller.dart';
import 'package:smart_learn/ui/widgets/popup_menu_widget.dart';

class SCRQuizCheck extends StatefulWidget {
  final List<ENTQuiz> quizs;
  final Map<int, dynamic> userAnswers;

  const SCRQuizCheck({super.key, required this.quizs, required this.userAnswers});

  @override
  State<StatefulWidget> createState() => _SCRQuizCheckState();
}

class _SCRQuizCheckState extends State<SCRQuizCheck> {
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
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          /// --- Nộp bài và thanh chọn câu hỏi ---------------------------------------
          Align(
            alignment: Alignment.centerRight,
            child: WdgPopupMenuCustom(
                item: Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  margin: const EdgeInsets.all(8),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(widget.quizs.length, (index) {
                      final isCurrent = index == currentIndex;
                      final isCorrect = widget.quizs[index].check(widget.userAnswers[index]);

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
                              color: isCorrect
                                  ? Colors.green
                                  : Colors.red,
                              width: 2,
                            ),
                            color: isCurrent
                                ? primaryColor(context).withAlpha(50)
                                : Colors.transparent,
                          ),
                          child: Text('${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isCurrent
                                  ? primaryColor(context)
                                  : isCorrect
                                  ? Colors.green
                                  : Colors.red,
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
              child: IgnorePointer(
                ignoring: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: WIDQuiz.build(
                    widget.quizs[currentIndex],
                    userAnswer: widget.userAnswers[currentIndex],
                    isTestMode: false
                  ),
                ),
              )
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
      ),
    );
  }
}
