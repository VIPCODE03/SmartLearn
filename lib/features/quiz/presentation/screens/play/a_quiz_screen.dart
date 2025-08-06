import 'package:flutter/material.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_get_params.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_params.dart';
import 'package:smart_learn/features/quiz/presentation/screens/play/b_quiz_review.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/action.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/performer.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/state.dart';

class SCRQuizPlay extends StatelessWidget {
  final Widget quiz;

  SCRQuizPlay.reviewByFileID({super.key, required String fileId})
      : quiz = _SCRQuizById(
      foreign: ForeignKeyParams(fileId: fileId),
      builder: (quizzes) {
        return SCRQuizReview(quizs: quizzes);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.design_services),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: quiz,
    );
  }
}

class _SCRQuizById extends StatelessWidget {
  final ForeignKeyParams foreign;
  final Widget Function(List<ENTQuiz> quizzes) builder;
  const _SCRQuizById({
    required this.foreign,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return PerformerProvider<QuizManagePerformer>.create(
        create: (_) => QuizManagePerformer()..add(Load(QuizGetAllParams(foreign))),
        child: PerformerBuilder<QuizManagePerformer>(
          builder: (context, per) {
            final state = per.current;
            if(state is QuizManageHasDataState) {
              return builder(state.quizzes);
            }
            else {
              return const SizedBox.shrink();
            }
          },
        )
    );
  }
}
