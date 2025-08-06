import 'package:performer/main.dart';
import 'package:smart_learn/features/subject/presentation/state_manages/subject_performer/subject_state.dart';

class SubjectPerformer extends Performer<SubjectState> {
  SubjectPerformer()
      : super(
      data: const SubjectState(StateData.init, [], [], FilterSubjectBy.none, SortType.none, '')
  );
}