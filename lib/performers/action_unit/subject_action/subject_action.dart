
import 'package:smart_learn/performers/data_state/data_state.dart';
import 'package:smart_learn/performers/data_state/subject_state.dart';
import 'package:smart_learn/data/models/subject/a_subject.dart';
import 'package:performer/performer.dart';

abstract class SubjectAction extends ActionUnit<SubjectState> {
  final List<Subject> repository = [
    Subject(id: 1, name: 'Toán', lastStudyDate: '22-03-2022', exercisesScores: [1, 5, 7, 10, 5, 7, 10, 5, 7, 10, 5, 7, 10, 5, 7, 10]),
    Subject(id: 2, name: 'Kĩ thuật lập trình', lastStudyDate: '25-03-2022', exercisesScores: [1, 5, 7, 10]),
    Subject(id: 3, name: 'Lập trình hướng đối tượng', lastStudyDate: '20-03-2022', exercisesScores: [1, 5, 7, 10]),
    Subject(id: 4, name: 'Văn học', lastStudyDate: '28-03-2022', exercisesScores: [1]),
    Subject(id: 5, name: 'Nhập môn công nghệ phần mềm', lastStudyDate: '15-03-2022', exercisesScores: [7, 9]),
    Subject(id: 6, name: 'Lập trình di động', lastStudyDate: '30-03-2022', exercisesScores: [7, 9], theories: [], exercises: []),
  ];
}

//-----------------------------Truy vấn--------------------------------------------
class LoadAllSubject extends SubjectAction {
  @override
  Stream<SubjectState> execute(SubjectState current) async* {
    yield current.copyWith(state: StateData.loading);
    await Future.delayed(const Duration(seconds: 1));
    yield current.copyWith(subjects: repository, subjectsFilted: repository, state: StateData.loaded);
  }
}

class DeleteSubjectById extends SubjectAction {
  final int subjectId;

  DeleteSubjectById(this.subjectId);

  @override
  Stream<SubjectState> execute(SubjectState current) async* {
    final updatedSubjects = current.subjects.where((s) => s.id != subjectId).toList();
    final updatedSubjectsFiltered = current.subjectsFilted.where((s) => s.id != subjectId).toList();

    yield current.copyWith(
      subjects: updatedSubjects,
      subjectsFilted: updatedSubjectsFiltered,
    );
  }

}


//---------------------------------Thay đổi danh sách----------------------------------
class ProcessSubject extends SubjectAction {
  final String? search;
  final FilterSubjectBy? filterBy;
  final SortType? sortType;

  ProcessSubject({this.search, this.filterBy, this.sortType});

  @override
  Stream<SubjectState> execute(SubjectState current) async* {
    SubjectState currentState = current;

    currentState = await _FilterSubject(filterBy ?? current.filterBy).execute(currentState).last;

    currentState = await _SearchSubject(search ?? current.search).execute(currentState).last;

    currentState = await _SortSubject(sortType ?? current.sortType).execute(currentState).last;

    yield currentState;
  }
}

class _SortSubject extends SubjectAction {
  final SortType sortType;

  _SortSubject(this.sortType);

  @override
  Stream<SubjectState> execute(SubjectState current) async* {
    if(sortType == SortType.none) {
      yield current.copyWith(sortType: sortType);
    }
    else {
      List<Subject> sortedSubjects = List.from(current.subjectsFilted);
      if (sortType == SortType.byName) {
        sortedSubjects.sort((a, b) => a.name.compareTo(b.name));
      } else if (sortType == SortType.byLastStudyDate) {
        sortedSubjects.sort((a, b) {
          final dateA = DateTime.parse(a.lastStudyDate.split('-').reversed.join());
          final dateB = DateTime.parse(b.lastStudyDate.split('-').reversed.join());
          return dateB.compareTo(dateA);
        });
      }

      yield current.copyWith(subjectsFilted: sortedSubjects, sortType: sortType);
    }
  }
}

class _SearchSubject extends SubjectAction {
  final String search;

  _SearchSubject(this.search);

  @override
  Stream<SubjectState> execute(SubjectState current) async* {
    if(search.trim().isEmpty) {
      yield current.copyWith(search: search);
    }

    else {
      List<Subject> filteredSubjects = current.subjectsFilted.where((subject) {
        return subject.name.toLowerCase().contains(search.toLowerCase());
      }).toList();

      yield current.copyWith(subjectsFilted: filteredSubjects, search: search);
    }
  }
}

class _FilterSubject extends SubjectAction {
  final FilterSubjectBy filterBy;
  _FilterSubject(this.filterBy);

  @override
  Stream<SubjectState> execute(SubjectState current) async* {
    if(filterBy == FilterSubjectBy.none) {
      yield current.copyWith(subjectsFilted: current.subjects, filterBy: filterBy);
    }
    else {
      List<Subject> subjectFiltered = current.subjects.where((subject) {
        if (filterBy == FilterSubjectBy.good) {
          return subject.averageCore >= 8.2;
        } else if (filterBy == FilterSubjectBy.quiteGood) {
          double average = subject.averageCore;
          return average >= 6.5 && average < 8.2;
        } else if (filterBy == FilterSubjectBy.average) {
          double average = subject.averageCore;
          return average >= 4 && average < 6.5;
        } else if (filterBy == FilterSubjectBy.poor) {
          return subject.averageCore < 4;
        }
        return true;
      }).toList();

      yield current.copyWith(subjectsFilted: subjectFiltered, filterBy: filterBy);
    }
  }
}

