import 'package:flutter/material.dart';
import 'package:performer/performer_build.dart';
import 'package:smart_learn/core/router/app_router_mixin.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_create_ai_params.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_get_params.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_params.dart';
import 'package:smart_learn/features/quiz/presentation/screens/editor/b_quiz_editor_screen.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/action.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/performer.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/state.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/dialogs/app_bottom_sheet.dart';
import 'package:smart_learn/ui/dialogs/dialog_textfiled.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';

enum _TypeAdd {
  handmade, ai
}

class SCRQuizManage extends StatelessWidget {
  final ForeignKeyParams foreign;
  final String title;

  SCRQuizManage.byFile({super.key, required String fileId, required this.title})
      : foreign = ForeignKeyParams.byFileId(fileId: fileId);

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

class _QuizManageScaffoldState extends State<_QuizManageScaffold> with AppRouterMixin {

  void _addQuiz(BuildContext context, _TypeAdd type, QuizManagePerformer performer) async {

    if (type == _TypeAdd.handmade) {
      pushSlideLeft(context, SCRQuizEditor(
        performer: performer,
        foreign: widget.foreign,
      ));
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

          floatingActionButton: FloatingActionButton(
              onPressed: () => _showSelectType(context, performer),
              child: const Icon(Icons.add)
          )
        );
      },
    );
  }

  /// BOTTOMSHEET TẠO DỮ LIỆU --------------------------------------------------
  void _showSelectType(BuildContext parentContext, QuizManagePerformer performer) {
    showAppBottomSheet(
        context: parentContext,
        title: 'Quiz',
        child: Column(
          children: [
            _buildOptionCard(
              icon: Icons.edit,
              color: Colors.blue,
              title: 'Tạo thủ công',
              subtitle: 'Tự nhập câu hỏi và đáp án',
              onTap: () {
                Navigator.pop(context);
                _addQuiz(parentContext, _TypeAdd.handmade, performer);
              },
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              icon: Icons.smart_toy,
              color: Colors.purple,
              title: 'Tạo bằng AI',
              subtitle: 'AI tạo quiz dựa trên hướng dẫn',
              onTap: () {
                Navigator.pop(context);
              _addQuiz(parentContext, _TypeAdd.ai, performer);
              },
            ),
          ],
        )
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return WdgBounceButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 14),
                ),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: 2),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700])
            ),
          ],
        ),
      ),
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