
import 'package:performer/performer.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/state.dart';

class QuizManagePerformer extends Performer<QuizManageState> {
  QuizManagePerformer() : super(data: const QuizManageInitState());
}