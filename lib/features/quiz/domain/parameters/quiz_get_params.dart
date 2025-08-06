import 'package:smart_learn/features/quiz/domain/parameters/quiz_params.dart';

abstract class QuizGetParams extends QuizParams {
  QuizGetParams(super.foreign);
}

class QuizGetAllParams extends QuizGetParams {
  QuizGetAllParams(super.foreign);
}

class QuizGetByIdParams extends QuizGetParams {
  final String id;
  QuizGetByIdParams(super.foreign, this.id);
}