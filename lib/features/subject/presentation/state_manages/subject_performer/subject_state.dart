import 'package:performer/main.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';

class SubjectState extends DataState {
  final List<ENTSubject> subjects;
  final List<ENTSubject> subjectsFilted;
  final StateData state;

  final FilterSubjectBy filterBy;
  final SortType sortType;
  final String search;

  const SubjectState(this.state, this.subjects, this.subjectsFilted, this.filterBy, this.sortType, this.search);

  SubjectState copyWith({
    List<ENTSubject>? subjects,
    List<ENTSubject>? subjectsFilted,
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

enum StateData {init, loading, loaded, updating, updated, error}
enum FilterSubjectBy {none, isHide}
enum SortType {none, byName, byLastStudyDate }
