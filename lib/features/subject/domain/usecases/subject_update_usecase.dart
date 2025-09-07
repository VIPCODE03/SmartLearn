import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';
import 'package:smart_learn/features/subject/domain/repositories/subject_repository.dart';

class SubjectUpdateParams {
  final ENTSubject subject;
  final String? name;
  final List<String>? tags;
  final String? level;
  final List<double>? exercisesScores;
  final DateTime? lastStudyDate;

  SubjectUpdateParams(
    this.subject, {
        this.name,
        this.tags,
        this.level,
        this.exercisesScores,
        this.lastStudyDate,
  });
}

class UCESubjectUpdate extends UseCase<ENTSubject, SubjectUpdateParams> {
  final REPSubject repository;
  UCESubjectUpdate({required this.repository});

  @override
  Future<Either<Failure, ENTSubject>> call(SubjectUpdateParams params) async {
    final subjectUpdated = ENTSubject(
      id: params.subject.id,
      name: params.name ?? params.subject.name,
      lastStudyDate: params.lastStudyDate ?? params.subject.lastStudyDate,
      tags: params.tags ?? params.subject.tags,
      level: params.level ?? params.subject.level,
      exercisesScores: params.exercisesScores ?? params.subject.exercisesScores,
    );
    final result = await repository.update(subjectUpdated);
    return result.fold((failure) => Left(failure), (sucsses) => sucsses ? Right(subjectUpdated) : Left(CacheFailure()));
  }
}