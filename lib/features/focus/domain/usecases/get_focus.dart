import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/focus/domain/repositories/focus_repository.dart';
import '../entities/weekly_focus_entity.dart';

class UCEGetFocus extends UseCase<ENTWeeklyFocus, NoParams> {
  final REPFocus focusRepository;

  UCEGetFocus({required this.focusRepository});

  @override
  Future<Either<Failure, ENTWeeklyFocus>> call(NoParams params) {
    return focusRepository.getWeeklyFocus();
  }
}