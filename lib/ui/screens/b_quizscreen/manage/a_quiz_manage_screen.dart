import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:performer/performer_build.dart';
import 'package:smart_learn/data/models/quiz/a_quiz.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/performers/action_unit/quiz_action/quiz_manage_action.dart';
import 'package:smart_learn/performers/data_state/quiz_mamage_state.dart';
import 'package:smart_learn/performers/performer/quiz_manage_performer.dart';
import 'package:smart_learn/ui/dialogs/dialog_textfiled.dart';
import 'package:smart_learn/ui/dialogs/scale_dialog.dart';
import 'package:smart_learn/ui/widgets/bouncebutton_widget.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';
import 'b_quiz_editor_screen.dart';

enum _TypeAdd {
  handmade, ai
}

class QuizManageScreen extends StatelessWidget {
  final String name;
  final String? json;
  final void Function(String json)? onSave;

  const QuizManageScreen({
    super.key,
    this.json,
    required this.name,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return PerformerProvider<QuizManagePerformer>.create(
      create: (_) => QuizManagePerformer()..add(Init(json)),
      child: _QuizManageScaffold(name: name, onSave: onSave),
    );
  }
}

class _QuizManageScaffold extends StatefulWidget {
  final String name;
  final void Function(String json)? onSave;

  const _QuizManageScaffold({required this.name, this.onSave});

  @override
  State<_QuizManageScaffold> createState() => _QuizManageScaffoldState();
}

class _QuizManageScaffoldState extends State<_QuizManageScaffold> {
  final _key = GlobalKey<ExpandableFabState>();

  void _addQuiz(_TypeAdd type, QuizManagePerformer performer) async {
    _key.currentState?.toggle();

    if (type == _TypeAdd.handmade) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QuizEditorScreen()),
      );
      performer.add(AddQuizManual(result));
    }

    else {
      final instruct = await showInputDialog(context: context, title: 'Hướng dẫn');
      performer.add(CreateQuizByAI(instruct: instruct));
    }
  }

  void _save(QuizManagePerformer performer) {
    performer.add(Save(onSave: widget.onSave));
  }

  @override
  Widget build(BuildContext context) {
    return PerformerBuilder<QuizManagePerformer>(
      builder: (context, performer) {
        final state = performer.current;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.design_services),
              onPressed: () {
                _save(performer);
                Navigator.pop(context);
              },
            ),
            title: Text(widget.name),
            actions: [
              WdgBounceButton(
                onTap: () {
                  _save(performer);
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Text('Lưu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(width: 10),
                    Icon(Icons.save),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
          body: Builder(
            builder: (_) {
              if (state is QuizManageInitState) {
                return const Center(child: WdgLoading());
              }

              final quizList = state.quizList;

              final listUI = quizList.isNotEmpty
                  ? ListView.builder(
                    itemCount: quizList.length,
                    itemBuilder: (context, index) {
                      final quiz = quizList[index];
                      return _ItemQuiz(quiz: quiz, index: index, performer: performer);
                },
              )
                  : const Center(child: Text('Chưa có dữ liệu'));

              return Stack(
                children: [
                  listUI,
                  if (state is QuizManageCreatingByAIState)
                    _DialogCreating()
                ],
              );
            },
          ),
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFab(
            key: _key,
            overlayStyle: const ExpandableFabOverlayStyle(
              blur: 5,
            ),
            children: [
              FloatingActionButton.small(
                onPressed: () => _addQuiz(_TypeAdd.handmade, performer),
                child: const Icon(Icons.edit_note_rounded),
              ),
              FloatingActionButton.small(
                onPressed: () => _addQuiz(_TypeAdd.ai, performer),
                child: const Icon(Icons.smart_toy_rounded),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ItemQuiz extends StatelessWidget {
  final Quiz quiz;
  final int index;
  final QuizManagePerformer performer;

  const _ItemQuiz({required this.quiz, required this.index, required this.performer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withAlpha(50)
          )
        )
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor(context).withAlpha(100),
          child: Text('${index + 1}'),
        ),
        title: Text(quiz.question, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: quiz.answers.asMap().entries.map((entry) {
            final index = entry.key;
            final answer = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('${index + 1}. $answer'),
            );
          }).toList(),
        ),
        // trailing: const Icon(Icons.edit, color: Colors.grey),
        onTap: () => _editQuiz(context, quiz, index, performer),
      ),
    );
  }

  void _editQuiz(BuildContext context, Quiz quiz, int index, QuizManagePerformer performer) async {
    final edited = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuizEditorScreen(quiz: quiz)),
    );
    performer.add(UpdateQuizByIndex(index: index, changed: edited));
  }
}

class _DialogCreating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: WdgScaleDialog(
        barrierDismissible: false,
        border: true,
        shadow: true,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WdgLoading(),
              SizedBox(height: 10),
              Text("Đang tạo dữ liệu..."),
            ],
          ),
        ),
      ),
    );
  }
}