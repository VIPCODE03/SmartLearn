
import 'package:performer/main.dart';
import 'package:smart_learn/performers/data_state/data_state.dart';
import 'package:smart_learn/performers/data_state/subject_state.dart';

class SubjectPageConductor extends Performer<SubjectState> {
  SubjectPageConductor()
      : super(
      data: const SubjectState(StateData.init, [], [], FilterSubjectBy.none, SortType.none, '')
  );
}