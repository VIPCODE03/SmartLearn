
import 'package:performer/performer.dart';
import 'package:smart_learn/performers/data_state/quiz_state.dart';

class QuizReviewPerformer extends Performer<QuizState> {
  QuizReviewPerformer() : super(data: const QuizInitState());
}