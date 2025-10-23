import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/calendar/domain/parameters/calendar_params.dart';
import '../repositories/calendar_repository.dart';

class UCECalendarDelete extends UseCase<bool, PARCalendarDelete> {
  final REPCalendar _repository;
  UCECalendarDelete(this._repository);

  @override
  Future<Either<Failure, bool>> call(PARCalendarDelete params) {
    return _repository.delete(params.id);
  }
}