import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/focus/domain/entities/weekly_focus_entity.dart';
import 'package:week_of_year/date_week_extensions.dart';

class CheckFocusParams extends Equatable {
  final ENTWeeklyFocus weeklyFocus;
  const CheckFocusParams({required this.weeklyFocus});

  @override
  List<Object?> get props => [weeklyFocus];
}

class UCECheckFocus extends UseCase<ENTWeeklyFocus, CheckFocusParams> {
  @override
  Future<Either<Failure, ENTWeeklyFocus>> call(CheckFocusParams params) async {
    final focus = params.weeklyFocus;
    final now = DateTime.now();
    final currentWeek = now.weekOfYear;
    final currentYear = now.year;
    if (focus.year != currentYear || focus.weekNumber != currentWeek) {
      return Right(ENTWeeklyFocus(
        year: currentYear,
        weekNumber: currentWeek,
        durations: const {},
      ));
    }
    return Right(params.weeklyFocus);
  }
}