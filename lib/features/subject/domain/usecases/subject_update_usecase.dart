import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';
import 'package:smart_learn/features/subject/domain/repositories/subject_repository.dart';

class SubjectUpdateParams {
  final ENTSubject subject;
  final String? name;
  final String? level;
  final DateTime? lastStudyDate;
  final bool? isHide;

  SubjectUpdateParams(
    this.subject, {
        this.name,
        this.level,
        this.lastStudyDate,
        this.isHide,
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
      level: params.level ?? params.subject.level,
      isHide: params.isHide ?? params.subject.isHide,
    );
    final result = await repository.update(subjectUpdated);
    return result.fold((failure) => Left(failure), (sucsses) => sucsses ? Right(subjectUpdated) : Left(CacheFailure()));
  }
}