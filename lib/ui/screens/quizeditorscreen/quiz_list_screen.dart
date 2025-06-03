import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:smart_learn/data/models/quiz/a_quiz.dart';
import 'package:smart_learn/performers/action_unit/gemini_action.dart';
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import 'package:smart_learn/performers/performer/gemini_conductor.dart';
import 'package:smart_learn/ui/dialogs/dialog_textfiled.dart';
import 'package:smart_learn/ui/dialogs/scale_dialog.dart';
import 'package:smart_learn/utils/json_util.dart';
import '../../../data/models/quiz/b_choice_quiz.dart';
import '../../../data/models/quiz/b_multi_choice_quiz.dart';
import 'quiz_editor_screen.dart';

class QuizListScreen extends StatefulWidget {
  final String name;
  final String? json;
  final void Function(String json)? onSave;

  const QuizListScreen({
    super.key,
    this.json,
    required this.name,
    this.onSave
  });

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  late List<Quiz> quizList;
  final _key = GlobalKey<ExpandableFabState>();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  String _getSubtitle(Quiz quiz) {
    if (quiz is OneChoiceQuiz) return 'Chọn 1 đáp án';
    if (quiz is MultiChoiceQuiz) return 'Chọn nhiều đáp án';
    return 'Không rõ loại';
  }

  //--- Load từ json  ---------------------------
  void _loadQuiz() {
    quizList = widget.json != null ? Quiz.fromJson(widget.json!) : [];
  }

  //--- Thêm quiz ------------------------------
  void _addQuiz(BuildContext context, _TypeAdd type) async {
    final state = _key.currentState;
    if (state != null) {
      state.toggle();
    }
    if(type == _TypeAdd.handmade) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QuizEditorScreen(),
        ),
      );

      if (result != null && result is Quiz) {
        setState(() {
          quizList.add(result);
        });
      }
    }
    else {
      final instruct = await showInputDialog(context: context, title: 'Hướng dẫn');
      if(instruct != null) {
        final gemP = GeminiConductor()..add(CreateQuiz(instruct: instruct));
        _subscription = gemP.stream.listen((current) {
          if (current.state == GemState.progress) {
            if (context.mounted) {
              if (ModalRoute.of(context)?.isCurrent == true) {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) =>
                  const WdgScaleDialog(
                    border: true,
                    shadow: true,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text("Đang tạo dữ liệu..."),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
          } else {
            if(context.mounted) {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            }
            setState(() {
              quizList.addAll(Quiz.fromJson(JsonUtil.cleanRawJsonString(current.answers)));
            });
            _subscription?.cancel();
          }
        });
      }
    }
  }

  //--- Sửa quiz  ------------------------------
  void _editQuiz(int index) async {
    final edited = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => QuizEditorScreen(quiz: quizList[index])),
    );
    if (edited != null && edited is Quiz) {
      setState(() => quizList[index] = edited);
    }
  }

  //--- Lưu -----------------------------------
  void _save() {
    if(widget.onSave != null) {
      List<Map<String, dynamic>> maps = [];
      for(var quiz in quizList) {
        maps.add(quiz.toMap());
      }
      widget.onSave!(jsonEncode(maps));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.design_services),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.name),
        actions: [
          IconButton(
              onPressed: () {
                _save();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save)
          ),
        ],
      ),
      body: quizList.isNotEmpty
          ? ListView.builder(
              itemCount: quizList.length,
              itemBuilder: (context, index) {
                final quiz = quizList[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade300,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      quiz.question,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _getSubtitle(quiz),
                      style: const TextStyle(color: Colors.black87),
                    ),
                    trailing: const Icon(Icons.edit, color: Colors.blueAccent),
                    onTap: () => _editQuiz(index),
                  ),
                );
              },
            )
          : const Center(child: Text('Chưa có dữ liệu')),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.black.withValues(alpha: 0.05),
          blur: 5,
        ),
        children: [
          /// Thêm thủ công ----------------------------------------------------
          FloatingActionButton.small(
            onPressed: () => _addQuiz(context, _TypeAdd.handmade),
            child: const Icon(Icons.edit_note_rounded),
          ),

          /// Thêm bằng AI ----------------------------------------------
            FloatingActionButton.small(
              child: const Icon(Icons.smart_toy_rounded),
              onPressed: () => _addQuiz(context, _TypeAdd.ai),
            ),
        ],
      ),
    );
  }
}

enum _TypeAdd {
  handmade, ai
}