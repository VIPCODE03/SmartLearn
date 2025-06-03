import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/subject/a_subject.dart';

abstract class SubjectPageEvent {}

class LoadSubjectEvent extends SubjectPageEvent {}

class UpdateSubjectEvent extends SubjectPageEvent {}

class SortSubjectEvent extends SubjectPageEvent {
  final int? sort;

  SortSubjectEvent({required this.sort});
}

class FilterSubjectEvent extends SubjectPageEvent {
  final int? filter;

  FilterSubjectEvent({required this.filter});
}

class SearchSubjectEvent extends SubjectPageEvent {
  final String searchTerm;

  SearchSubjectEvent({required this.searchTerm});
}

abstract class SubjectPageState {}

class LoadingSubjectState extends SubjectPageState {}

class LoadedSubjectState extends SubjectPageState {
  final List<Subject> subjects;

  LoadedSubjectState({required this.subjects});
}

class ErrorSubjectState extends SubjectPageState {
  final String error;

  ErrorSubjectState({required this.error});
}

class SubjectPageBloc extends Bloc<SubjectPageEvent, SubjectPageState> {
  // Lưu trữ bản gốc dữ liệu đã tải
  final List<Subject> _originalSubjects = [];

  FilterSubjectEvent? _filter;
  SearchSubjectEvent? _search;
  SortSubjectEvent? _sort;

  SubjectPageBloc() : super(LoadingSubjectState()) {
    on<LoadSubjectEvent>((event, emit) async {
      emit(LoadingSubjectState());
      try {
        // Gọi repository để lấy dữ liệu (giả sử)
        // final subjects = await subjectRepository.getSubjects();
        // _originalSubjects.addAll(subjects);
        await Future.delayed(const Duration(milliseconds: 500));
        _originalSubjects.addAll([

        ]);
        emit(LoadedSubjectState(subjects: List.from(_originalSubjects)));

      } catch (e) {
        emit(ErrorSubjectState(error: e.toString()));
      }
    });

    on<UpdateSubjectEvent>((event, emit) async {
      // TODO: Implement logic cập nhật
    });

    on<SortSubjectEvent>((event, emit) {
      if (state is LoadedSubjectState) {
        if(event.sort != null) {
          _sort = event;
        }
        else {
          _sort = null;
        }
        emit(LoadedSubjectState(subjects: _filterSort()));
      }
    });

    on<FilterSubjectEvent>((event, emit) {
      if (state is LoadedSubjectState) {
        if(event.filter != null) {
          _filter = event;
        }
        else {
          _filter = null;
        }
        emit(LoadedSubjectState(subjects: _filterSort()));
      }
    });

    on<SearchSubjectEvent>((event, emit) {
      if (state is LoadedSubjectState) {
        if(event.searchTerm.isNotEmpty) {
          _search = event;
        }
        else {
          _search = null;
        }
        emit(LoadedSubjectState(subjects: _filterSort()));
      }
    });
  }

  List<Subject> _filterSort() {
    List<Subject> subjects = List.from(_originalSubjects);
    if(_filter != null) {
      FilterSubjectEvent filter = _filter!;
      subjects.removeWhere(((subject) {
        if (filter.filter == 1) {
          return subject.average() < 8.2;
        } else if (filter.filter == 2) {
          double average = subject.average();
          return average < 6.5 || average >= 8.2;
        } else if (filter.filter == 3) {
          double average = subject.average();
          return average < 4 || average >= 6.5;
        } else if (filter.filter == 4) {
          return subject.average() >= 4;
        }
        return true;
      }));
    }

    if(_search != null) {
      SearchSubjectEvent search = _search!;
      subjects.removeWhere((subject) =>
      !subject.name.toLowerCase().contains(search.searchTerm.toLowerCase()));
    }

    if(_sort != null) {
      SortSubjectEvent sort = _sort!;
      subjects.sort((a, b) {
        if (sort.sort == 1) {
          return a.name.compareTo(b.name);

        } else if (sort.sort == 2) {
          final dateA = DateTime.parse(a.lastStudyDate.split('-').reversed.join());
          final dateB = DateTime.parse(b.lastStudyDate.split('-').reversed.join());
          return dateB.compareTo(dateA);
        }
        return 0;
      });
    }
    return subjects;
  }
}