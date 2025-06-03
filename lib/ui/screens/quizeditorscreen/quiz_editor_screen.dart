import 'package:flutter/material.dart';
import 'package:smart_learn/data/models/quiz/a_quiz.dart';
import 'package:smart_learn/data/models/quiz/b_choice_quiz.dart';
import 'package:smart_learn/data/models/quiz/b_multi_choice_quiz.dart';

enum TypeQuiz {
  choice,
  multiChoice,
}

class QuizEditorScreen extends StatefulWidget {
  final Quiz? quiz;
  const QuizEditorScreen({super.key, this.quiz});

  @override
  State<QuizEditorScreen> createState() => _QuizEditorScreenState();
}

class _QuizEditorScreenState extends State<QuizEditorScreen> {
  TypeQuiz type = TypeQuiz.choice;
  final _questionController = TextEditingController();

  final _choiceEditorKey = GlobalKey<_WdgChoiceState>();
  final _multiChoiceEditorKey = GlobalKey<_WdgMultiChoiceState>();

  @override
  void initState() {
    super.initState();

    if (widget.quiz != null) {
      if (widget.quiz is OneChoiceQuiz) {
        type = TypeQuiz.choice;
        final quiz = widget.quiz as OneChoiceQuiz;
        _questionController.text = quiz.question;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _choiceEditorKey.currentState?.loadData({
            'answers': quiz.answers,
            'correct': quiz.correctAnswer,
          });
        });
      } else if (widget.quiz is MultiChoiceQuiz) {
        type = TypeQuiz.multiChoice;
        final quiz = widget.quiz as MultiChoiceQuiz;
        _questionController.text = quiz.question;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _multiChoiceEditorKey.currentState?.loadData({
            'answers': quiz.answers,
            'correct': quiz.correctAnswer,
          });
        });
      }
    }
  }

  void _onSave() {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      _showError('Vui lòng nhập câu hỏi');
      return;
    }

    switch (type) {
      case TypeQuiz.choice:
        final choiceState = _choiceEditorKey.currentState;
        if (choiceState != null && choiceState.validate()) {
          final data = choiceState.getData();
          final newQuiz = OneChoiceQuiz(
              question: question,
              correctAnswer: data['correct'],
              answers: data['answers']
          );
          Navigator.pop(context, newQuiz);
        } else {
          _showError('Dữ liệu không hợp lệ');
        }
        break;

      case TypeQuiz.multiChoice:
        final multiState = _multiChoiceEditorKey.currentState;
        if (multiState != null && multiState.validate()) {
          final data = multiState.getData();
          final newQuiz = MultiChoiceQuiz(
              question: question,
              correctAnswer: data['correct'],
              answers: data['answers']
          );
          Navigator.pop(context, newQuiz);
        } else {
          _showError('Dữ liệu không hợp lệ');
        }
        break;
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Quiz'),
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
              items: const [
                DropdownMenuItem(
                  value: TypeQuiz.choice,
                  child: Text('Chọn 1 đáp án'),
                ),
                DropdownMenuItem(
                  value: TypeQuiz.multiChoice,
                  child: Text('Chọn nhiều đáp án'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Câu hỏi',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
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
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _controllers.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Radio<int>(
                    value: index,
                    groupValue: correctIndex,
                    onChanged: (val) => setState(() => correctIndex = val!),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controllers[index],
                      decoration: InputDecoration(labelText: 'Đáp án ${index + 1}'),
                      maxLines: null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () => _removeAnswer(index),
                  )
                ],
              );
            },
          ),
        ),
        ElevatedButton.icon(
          onPressed: _addAnswer,
          icon: const Icon(Icons.add),
          label: const Text('Thêm đáp án'),
        )
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
              return Row(
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
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controllers[index],
                      decoration: InputDecoration(labelText: 'Đáp án ${index + 1}'),
                      maxLines: null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () => _removeAnswer(index),
                  )
                ],
              );
            },
          ),
        ),
        ElevatedButton.icon(
          onPressed: _addAnswer,
          icon: const Icon(Icons.add),
          label: const Text('Thêm đáp án'),
        )
      ],
    );
  }
}

