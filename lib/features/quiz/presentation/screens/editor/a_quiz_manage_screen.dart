import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:performer/performer_build.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_create_ai_params.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_get_params.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_params.dart';
import 'package:smart_learn/features/quiz/presentation/screens/editor/b_quiz_editor_screen.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/action.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/performer.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/state.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/dialogs/dialog_textfiled.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';

enum _TypeAdd {
  handmade, ai
}

class SCRQuizManage extends StatelessWidget {
  final ForeignKeyParams foreign;
  final String title;

  SCRQuizManage.byFile({super.key, required String fileId, required this.title})
      : foreign = ForeignKeyParams(fileId: fileId);

  @override
  Widget build(BuildContext context) {
    return PerformerProvider<QuizManagePerformer>.create(
      create: (_) => QuizManagePerformer()..add(Load(QuizGetAllParams(foreign))),
      child: _QuizManageScaffold(name: title, foreign: foreign),
    );
  }
}

class _QuizManageScaffold extends StatefulWidget {
  final String name;
  final ForeignKeyParams foreign;

  const _QuizManageScaffold({
    required this.name,
    required this.foreign
  });

  @override
  State<_QuizManageScaffold> createState() => _QuizManageScaffoldState();
}

class _QuizManageScaffoldState extends State<_QuizManageScaffold> {
  final _key = GlobalKey<ExpandableFabState>();

  void _addQuiz(_TypeAdd type, QuizManagePerformer performer) async {
    _key.currentState?.toggle();

    if (type == _TypeAdd.handmade) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SCRQuizEditor(
          performer: performer,
          foreign: widget.foreign,
        )),
      );
    }

    else {
      final instruct = await showInputDialog(context: context, title: 'Hướng dẫn');
      performer.add(CreateQuizByAI(QuizCreateQuizAIParams(instruct: instruct ?? '')));
    }
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
                Navigator.pop(context);
              },
            ),
            title: Text(widget.name),
          ),
          body: Builder(
            builder: (_) {
              if(state is QuizError) {
                return const Center(child: Text('Error'));
              }

              if(state is QuizManageHasDataState) {
                final quizzes = state.quizzes;
                return quizzes.isNotEmpty
                    ? ListView.builder(
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    return _ItemQuiz(quiz: quiz, index: index, performer: performer, foreign: widget.foreign);
                  },
                )
                    : const Center(child: Text('Chưa có dữ liệu'));
              }

              return const Center(child: WdgLoading());
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
  final ENTQuiz quiz;
  final int index;
  final QuizManagePerformer performer;
  final ForeignKeyParams foreign;

  const _ItemQuiz({
    required this.quiz,
    required this.index,
    required this.performer,
    required this.foreign
  });

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
        onTap: () => _editQuiz(context, quiz, index, performer),
      ),
    );
  }

  void _editQuiz(BuildContext context, ENTQuiz quiz, int index, QuizManagePerformer performer) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SCRQuizEditor(
        quiz: quiz,
        performer: performer,
        foreign: foreign,
      )),
    );
  }
}