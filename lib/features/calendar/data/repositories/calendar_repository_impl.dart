
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/calendar/data/datasources/calendar_local_data_source.dart';
import 'package:smart_learn/features/calendar/data/models/a_calendar_model.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/repositories/calendar_repository.dart';

class REPCalendarImpl extends REPCalendar {
  final LDSCalendar localDataSource;
  REPCalendarImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> add(ENTCalendar calendar) async {
    try {
      final model = MODCalendar.fromEntity(calendar);
      await localDataSource.add(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> update(ENTCalendar calendar) async {
    try {
      final model = MODCalendar.fromEntity(calendar);
      await localDataSource.update(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await localDataSource.delete(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTCalendar>>> getAll() async {
    try {
      final models = await localDataSource.getAll();
      return Right(models);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTCalendar>>> getByDate(DateTime date) async {
    try {
      final models = await localDataSource.getByDate(date);
      return Right(models);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTCalendar>>> getByDateRange(DateTime start, DateTime end) async {
    try {
      final models = await localDataSource.getByDateRange(start, end);
      return Right(models);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTCalendar>>> getById(String id) async {
    try {
      final model = await localDataSource.getById(id);
      return Right([model]);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTCalendar>>> search(String title) async {
    try {
      final models = await localDataSource.search(title);
      return Right(models);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}