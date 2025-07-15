import 'dart:convert';

import 'package:performer/main.dart';
import 'package:smart_learn/performers/action_unit/gemini_action.dart';
import 'package:smart_learn/performers/data_state/quiz_mamage_state.dart';
import 'package:smart_learn/data/models/quiz/a_quiz.dart';

import '../../data_state/gemini_state.dart';

abstract class QuizManageAction extends ActionUnit<QuizManageState> {}

class Init extends QuizManageAction {
  final String? json;
  Init(this.json);

  @override
  Stream<QuizManageState> execute(QuizManageState current) async* {
    await Future.delayed(const Duration(milliseconds: 666));
    if(json == null) {
      yield const QuizManageLoadedState(quizList: []);
    }
    else {
      yield QuizManageLoadedState(quizList: Quiz.fromJson(json!));
    }
  }
}

class AddQuizManual extends QuizManageAction {
  final dynamic result;

  AddQuizManual(this.result);

  @override
  Stream<QuizManageState> execute(QuizManageState current) async* {
    if (result != null && result is Quiz) {
      final List<Quiz> newList = [...current.quizList, result];
      yield QuizManageLoadedState(quizList: newList);
    }
  }
}

class UpdateQuizByIndex extends QuizManageAction {
  final int index;
  final dynamic changed;

  UpdateQuizByIndex({required this.index, required this.changed});

  @override
  Stream<QuizManageState> execute(QuizManageState current) async* {
    if(changed != null && changed is Quiz) {
      if (index < 0 || index >= current.quizList.length) {
        yield current;
        return;
      }

      final newList = [...current.quizList];
      newList[index] = changed;

      yield QuizManageLoadedState(quizList: newList);
    }
  }
}

class CreateQuizByAI extends QuizManageAction with ActionExecutor {
  final String? instruct;

  CreateQuizByAI({required this.instruct});

  @override
  Stream<QuizManageState> execute(QuizManageState current) async* {
    if(instruct == null || instruct!.isEmpty) {
      return;
    }
    yield QuizManageCreatingByAIState(
      quizList: current.quizList,
      geminiState: const GeminiInitialState(),
    );

    await for (final gemState in run<GeminiState>(
      CreateQuiz(instruct: instruct!),
      const GeminiInitialState(),
    )) {
      if (gemState is GeminiProgressState || gemState is GeminiErrorState) {
        yield QuizManageCreatingByAIState(
          quizList: current.quizList,
          geminiState: gemState,
        );
      } else if (gemState is GeminiDoneState) {
        final List<Quiz> newQuizzes = Quiz.fromJson(gemState.answers);

        yield QuizManageLoadedState(
          quizList: [...current.quizList, ...newQuizzes],
        );
      }
    }
  }
}

class Save extends QuizManageAction {
  final void Function(String json)? onSave;
  Save({this.onSave});

  @override
  Stream<QuizManageState> execute(QuizManageState current) async* {
    final quizList = current.quizList;
    final json = jsonEncode(quizList.map((e) => e.toMap()).toList());

    onSave?.call(json);
  }
}