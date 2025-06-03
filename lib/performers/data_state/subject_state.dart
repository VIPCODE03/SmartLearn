
import 'package:smart_learn/performers/data_state/data_state.dart';
import 'package:smart_learn/data/models/subject/a_subject.dart';

class SubjectState extends Data {
  final List<Subject> subjects;
  final List<Subject> subjectsFilted;

  final FilterSubjectBy filterBy;
  final SortType sortType;
  final String search;

  const SubjectState(super.state, this.subjects, this.subjectsFilted, this.filterBy, this.sortType, this.search);

  SubjectState copyWith({
    List<Subject>? subjects,
    List<Subject>? subjectsFilted,
    StateData? state,
    FilterSubjectBy? filterBy,
    SortType? sortType,
    String? search
  }) {
    return SubjectState(
      state ?? this.state,
      subjects ?? this.subjects,
      subjectsFilted ?? this.subjectsFilted,
      filterBy ?? this.filterBy,
      sortType ?? this.sortType,
      search ?? this.search
    );
  }

  @override
  List<Object?> get props => [state, subjects, subjectsFilted, filterBy, sortType, search];
}

enum FilterSubjectBy {none, good, quiteGood, average, poor}
enum SortType {none, byName, byLastStudyDate }
