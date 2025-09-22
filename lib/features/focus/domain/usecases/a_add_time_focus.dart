import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/focus/domain/entities/weekly_focus_entity.dart';
import 'package:smart_learn/features/focus/domain/repositories/focus_repository.dart';

class AddTimeFocusParams extends Equatable {
  final Duration duration;
  final DateTime day;

  const AddTimeFocusParams({required this.duration, required this.day});

  @override
  List<Object?> get props => [ duration, day ];
}

class UCEAddTimeFocus extends UseCase<ENTWeeklyFocus, AddTimeFocusParams> {
  final REPFocus focusRepository;

  UCEAddTimeFocus({required this.focusRepository});

  @override
  Future<Either<Failure, ENTWeeklyFocus>> call(AddTimeFocusParams params) async {
    late ENTWeeklyFocus focus;
    (await focusRepository.getWeeklyFocus()).fold(
            (fail) {
              return Left(fail);
            },
            (data) {
              focus = data;
            }
    );
    final day = WeekDay.values[params.day.weekday - 1];
    final current = focus.durations[day] ?? Duration.zero;

    final newDuration = {
      ...focus.durations,
      day: current + params.duration,
    };

    final newFocus = ENTWeeklyFocus(
        year: focus.year,
        weekNumber: focus.weekNumber,
        durations: newDuration,
    );

    final result = await focusRepository.updateFocus(newFocus);
    return result.fold(
          (failure) => Left(failure),
          (data) => Right(newFocus),
    );
  }
}