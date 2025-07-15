
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/focus/data/datasources/focus_local_data_source.dart';
import 'package:smart_learn/features/focus/domain/entities/weekly_focus_entity.dart';
import 'package:smart_learn/features/focus/domain/repositories/focus_repository.dart';

import '../models/weekly_focus_model.dart';

class REPFocusImpl implements REPFocus {
  final LDSFocus focusLocalDataSource;

  REPFocusImpl({required this.focusLocalDataSource});

  @override
  @override
  Future<Either<Failure, ENTWeeklyFocus>> getWeeklyFocus() async {
    try {
      final model = await focusLocalDataSource.getLastWeeklyFocus();
      return Right(model);
    } catch (e, s) {
      log('ERROR',
        name: 'REPFocusImpl',
        error: e,
        stackTrace: s,
      );

      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateFocus(ENTWeeklyFocus focus) async {
    try {
      final model = MODWeeklyFocus.fromEntity(focus);
      await focusLocalDataSource.cacheWeeklyFocus(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}