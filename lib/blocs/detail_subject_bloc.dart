
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_learn/data/models/subject/a_subject.dart';

abstract class DetailSubjectEvent {}

class LoadTheoryEvent extends DetailSubjectEvent {}

class LoadExerciseEvent extends DetailSubjectEvent {}

class UpdateSubjectEvent extends DetailSubjectEvent {
  final Subject subject;

  UpdateSubjectEvent(this.subject);
}

abstract class DetailSubjectState {}

class UpdatingSubjectState extends DetailSubjectState {}

class UpdatedSubjectState extends DetailSubjectState {}

class ErrorUpdateSubjectState extends DetailSubjectState {}

class DetailSubjectBloc extends Bloc<DetailSubjectEvent, DetailSubjectState> {
  DetailSubjectBloc(super.initialState) {
    on<UpdateSubjectEvent>((event, emit) {

    });
  }
}