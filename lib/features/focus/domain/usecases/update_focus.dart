
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/focus/domain/repositories/focus_repository.dart';
import '../entities/weekly_focus_entity.dart';

class UpdateFocusParams extends Equatable {
  final ENTWeeklyFocus focus;

  const UpdateFocusParams({required this.focus});

  @override
  List<Object?> get props => [focus];
}

class UCEUpdateFocus extends UseCase<void, UpdateFocusParams> {
  final REPFocus focusRepository;

  UCEUpdateFocus({required this.focusRepository});

  @override
  Future<Either<Failure, void>> call(UpdateFocusParams params) {
    return focusRepository.updateFocus(params.focus);
  }
}