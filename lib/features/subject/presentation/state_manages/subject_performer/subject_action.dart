import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';
import 'package:smart_learn/features/subject/domain/usecases/subject_add_usecase.dart';
import 'package:smart_learn/features/subject/domain/usecases/subject_delete_usecase.dart';
import 'package:smart_learn/features/subject/domain/usecases/subject_get_usecase.dart';
import 'package:smart_learn/features/subject/domain/usecases/subject_update_usecase.dart';
import 'package:smart_learn/features/subject/presentation/state_manages/subject_performer/subject_state.dart';
import 'package:performer/performer.dart';

abstract class SubjectAction extends ActionUnit<SubjectState> {
  final UCESubjectAdd add;
  final UCESubjectUpdate update;
  final UCESubjectDelete delete;
  final UCESubjectGet get;
  SubjectAction()
      : add = getIt(),
        update = getIt(),
        delete = getIt(),
        get = getIt()
  ;
}

//- Truy vấn--------------------------------------------
class LoadAllSubject extends SubjectAction {
  @override
  Stream<SubjectState> execute(SubjectState current) async* {
    yield current.copyWith(state: StateData.loading);
    await Future.delayed(const Duration(seconds: 1));
    final result = await get(SubjectGetParamsAll());
    if (result.isLeft()) {
    } else {
      final datas = result.getOrElse(() => []);
      yield current.copyWith(
        subjects: datas,
        subjectsFilted: datas,
        state: StateData.loaded,
      );
    }
  }
}

class AddSubject extends SubjectAction {
  final String name;
  final int level;
  AddSubject(this.name, this.level);

  @override
  Stream<SubjectState> execute(SubjectState current) async* {
    yield current.copyWith(state: StateData.updating);
    final result = await add(SubjectAddParams(name: name, level: level));
    ENTSubject? newSubject;
    result.fold(
            (failure) => newSubject = null,
            (subject) => newSubject = subject
    );
    if (newSubject != null) {
      final updatedSubjects = List<ENTSubject>.from(current.subjects)
        ..add(newSubject!);
      final updatedSubjectsFiltered = List<ENTSubject>.from(current.subjectsFilted)
        ..add(newSubject!);
      yield current.copyWith(
        subjects: updatedSubjects,
        subjectsFilted: updatedSubjectsFiltered,
        state: StateData.updated,
      );
    }
  }
}

class DeleteSubjectById extends SubjectAction {
  final String subjectId;
  DeleteSubjectById(this.subjectId);

  @override
  Stream<SubjectState> execute(SubjectState current) async* {
    yield current.copyWith(state: StateData.updating);
    final result = await delete(SubjectDeleteParams(id: subjectId));
    final updatedSubjects = List<ENTSubject>.from(current.subjects);
    final updatedSubjectsFiltered = List<ENTSubject>.from(current.subjectsFilted);
    result.fold(
            (a) {},
            (b) {
              updatedSubjects.removeWhere((element) => element.id == subjectId);
              updatedSubjectsFiltered.removeWhere((element) => element.id == subjectId);
            }
    );
    yield current.copyWith(
      subjects: updatedSubjects,
      subjectsFilted: updatedSubjectsFiltered,
      state: StateData.updated,
    );
  }
}

//- Thay đổi danh sách----------------------------------
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
      List<ENTSubject> sortedSubjects = List.from(current.subjectsFilted);
      if (sortType == SortType.byName) {
        sortedSubjects.sort((a, b) => a.name.compareTo(b.name));
      } else if (sortType == SortType.byLastStudyDate) {
        sortedSubjects.sort((a, b) {
          return a.lastStudyDate.compareTo(b.lastStudyDate);
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
      List<ENTSubject> filteredSubjects = current.subjectsFilted.where((subject) {
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
      List<ENTSubject> subjectFiltered = current.subjects.where((subject) {
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

