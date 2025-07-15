
import 'package:performer/performer.dart';
import 'package:smart_learn/performers/data_state/quiz_mamage_state.dart';

class QuizManagePerformer extends Performer<QuizManageState> {
  QuizManagePerformer() : super(data: QuizManageInitState());
}