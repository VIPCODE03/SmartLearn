import 'package:smart_learn/features/quiz/domain/parameters/quiz_params.dart';

class QuizCreateQuizAIParams extends QuizParams {
  final String instruct;
  QuizCreateQuizAIParams(super.foreign, { required this.instruct });
}