import 'package:flutter/material.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_multichoice_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_onechoice_entity.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_add_params.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_params.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_update_params.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/action.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/performer.dart';
import 'package:smart_learn/app/ui/snackbars/app_snackbar.dart';
import 'package:smart_learn/app/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/app/ui/widgets/textfeild_widget.dart';

enum TypeQuiz {
  choice,
  multiChoice,
}

class SCRQuizEditor extends StatefulWidget {
  final ENTQuiz? quiz;
  final ForeignKeyParams foreign;
  final QuizManagePerformer performer;
  const SCRQuizEditor({
    super.key,
    required this.performer ,
    this.quiz,
    required this.foreign
  });

  @override
  State<SCRQuizEditor> createState() => _SCRQuizEditorState();
}

class _SCRQuizEditorState extends State<SCRQuizEditor> {
  TypeQuiz type = TypeQuiz.choice;
  final _questionController = TextEditingController();
  final _choiceEditorKey = GlobalKey<_WdgChoiceState>();
  final _multiChoiceEditorKey = GlobalKey<_WdgMultiChoiceState>();

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    if (widget.quiz != null) {
      if (widget.quiz is ENTQuizOneChoice) {
        type = TypeQuiz.choice;
        final quiz = widget.quiz as ENTQuizOneChoice;
        _questionController.text = quiz.question;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _choiceEditorKey.currentState?.loadData({
            'answers': quiz.options,
            'correct': quiz.correctAnswer,
          });
        });
      } else if (widget.quiz is ENTQuizMultiChoice) {
        type = TypeQuiz.multiChoice;
        final quiz = widget.quiz as ENTQuizMultiChoice;
        _questionController.text = quiz.question;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _multiChoiceEditorKey.currentState?.loadData({
            'answers': quiz.options,
            'correct': quiz.correctAnswer,
          });
        });
      }
    }
  }

  void _onSave() {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      showAppSnackbar(context, globalLanguage.pleaseEnterQuestion);
      return;
    }

    switch (type) {
      case TypeQuiz.choice:
        final choiceState = _choiceEditorKey.currentState;
        if (choiceState != null && choiceState.validate()) {
          final data = choiceState.getData();
          widget.quiz == null
              ? widget.performer.add(CreateQuiz(params: AddQuizOneChoiceParams(widget.foreign, question: question, correctAnswer: data['correct'], answers: data['answers'])))
              : widget.performer.add(UpdateQuiz(params: QuizOneChoiceUpdateParams(widget.quiz as ENTQuizOneChoice, question: question, correctAnswer: data['correct'], answers: data['answers'])));
          Navigator.pop(context);
        } else {
          showAppSnackbar(context, globalLanguage.invalidData);
        }
        break;

      case TypeQuiz.multiChoice:
        final multiState = _multiChoiceEditorKey.currentState;
        if (multiState != null && multiState.validate()) {
          final data = multiState.getData();
          widget.quiz == null
              ? widget.performer.add(CreateQuiz(params: AddQuizMultiChoiceParams(widget.foreign, question: question, correctAnswer: data['correct'], answers: data['answers'])))
              : widget.performer.add(UpdateQuiz(params: QuizMultiChoiceUpdateParams(widget.quiz as ENTQuizMultiChoice, question: question, correctAnswer: data['correct'], answers: data['answers'])));
          Navigator.pop(context);
        } else {
          showAppSnackbar(context, globalLanguage.invalidData);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(globalLanguage.quiz),
        actions: [
          IconButton(onPressed: _onSave, icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            DropdownButton<TypeQuiz>(
              value: type,
              onChanged: (value) {
                if (value != null) setState(() => type = value);
              },
              items: [
                DropdownMenuItem(
                  value: TypeQuiz.choice,
                  child: Text(globalLanguage.chooseOne),
                ),
                DropdownMenuItem(
                  value: TypeQuiz.multiChoice,
                  child: Text(globalLanguage.chooseMulti),
                ),
              ],
            ),
            const SizedBox(height: 10),
            WdgTextFeildCustom(
                controller: _questionController,
                hintText:  globalLanguage.question,
                color:  context.style.color.primaryColor
            ),
            const SizedBox(height: 12),
            Expanded(
              child: type == TypeQuiz.choice
                  ? _WdgChoice(key: _choiceEditorKey)
                  : _WdgMultiChoice(key: _multiChoiceEditorKey),
            ),
          ],
        ),
      ),
    );
  }
}

class _WdgChoice extends StatefulWidget {
  const _WdgChoice({super.key});

  @override
  State<_WdgChoice> createState() => _WdgChoiceState();
}

class _WdgChoiceState extends State<_WdgChoice> {
  List<TextEditingController> _controllers = [];
  int correctIndex = 0;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(2, (_) => TextEditingController());
  }

  void _addAnswer() {
    setState(() => _controllers.add(TextEditingController()));
  }

  void _removeAnswer(int index) {
    if (_controllers.length <= 2) return;
    setState(() {
      _controllers.removeAt(index);
      if (correctIndex == index) {
        correctIndex = 0;
      } else if (correctIndex > index) {
        correctIndex--;
      }
    });
  }

  bool validate() {
    return _controllers.length >= 2 &&
        _controllers.every((e) => e.text.trim().isNotEmpty);
  }

  Map<String, dynamic> getData() {
    return {
      'answers': _controllers.map((e) => e.text.trim()).toList(),
      'correct': _controllers[correctIndex].text.trim(),
    };
  }

  void loadData(Map<String, dynamic> data) {
    final answers = List<String>.from(data['answers'] ?? []);
    final correct = data['correct'];
    setState(() {
      _controllers = answers.map((e) => TextEditingController(text: e)).toList();
      correctIndex = answers.indexOf(correct);
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = context.style.color.primaryColor;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _controllers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: correctIndex,
                      onChanged: (val) => setState(() => correctIndex = val!),
                      activeColor: color,
                    ),
                    Expanded(
                        child: WdgTextFeildCustom(
                            controller: _controllers[index],
                            hintText: '${globalLanguage.answer} ${index + 1}',
                            color: color,
                        )
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeAnswer(index),
                    )
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        _addButton(context, _addAnswer)
      ],
    );
  }
}

class _WdgMultiChoice extends StatefulWidget {
  const _WdgMultiChoice({super.key});

  @override
  State<_WdgMultiChoice> createState() => _WdgMultiChoiceState();
}

class _WdgMultiChoiceState extends State<_WdgMultiChoice> {
  List<TextEditingController> _controllers = [];
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(2, (_) => TextEditingController());
  }

  void _addAnswer() {
    setState(() => _controllers.add(TextEditingController()));
  }

  void _removeAnswer(int index) {
    if (_controllers.length <= 2) return;
    setState(() {
      _controllers.removeAt(index);
      selectedIndexes = selectedIndexes
          .where((i) => i != index)
          .map((i) => i > index ? i - 1 : i)
          .toSet();
    });
  }

  bool validate() {
    return _controllers.length >= 2 &&
        selectedIndexes.isNotEmpty &&
        _controllers.every((e) => e.text.trim().isNotEmpty);
  }

  Map<String, dynamic> getData() {
    return {
      'answers': _controllers.map((e) => e.text.trim()).toList(),
      'correct': selectedIndexes.map((i) => _controllers[i].text.trim()).toList(),
    };
  }

  void loadData(Map<String, dynamic> data) {
    final answers = List<String>.from(data['answers'] ?? []);
    final correctAnswers = List<String>.from(data['correct'] ?? []);
    setState(() {
      _controllers = answers.map((e) => TextEditingController(text: e)).toList();
      selectedIndexes = {
        for (int i = 0; i < answers.length; i++)
          if (correctAnswers.contains(answers[i])) i,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _controllers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Checkbox(
                      value: selectedIndexes.contains(index),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            selectedIndexes.add(index);
                          } else {
                            selectedIndexes.remove(index);
                          }
                        });
                      },
                      activeColor: context.style.color.primaryColor,
                      checkColor: Colors.white,
                    ),
                    Expanded(
                      child: WdgTextFeildCustom(
                          controller: _controllers[index],
                          hintText: '${globalLanguage.answer} ${index + 1}',
                          color: context.style.color.primaryColor,
                      )
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeAnswer(index),
                    )
                  ],
                ),
              );
            },
          ),
        ),

        _addButton(context, _addAnswer)
      ]
    );
  }
}

Widget _addButton(BuildContext context, VoidCallback onTap) {
  return WdgBounceButton(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.style.color.primaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            globalLanguage.addAnswer,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}
