import 'package:performer/performer.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quiz_play_performer/quizplay_state.dart';

class QuizReviewPerformer extends Performer<QuizPlayState> {
  QuizReviewPerformer() : super(data: const QuizInitState());
}