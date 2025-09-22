import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';
import 'package:smart_learn/features/subject/domain/repositories/subject_repository.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

class SubjectAddParams {
  final String name;
  final String level;

  SubjectAddParams({required this.name, required this.level});
}

class UCESubjectAdd extends UseCase<ENTSubject, SubjectAddParams> {
  final REPSubject repository;
  UCESubjectAdd({required this.repository});

  @override
  Future<Either<Failure, ENTSubject>> call(SubjectAddParams params) async {
    final newSubject = ENTSubject(
        id: UTIGenerateID.random(),
        name: params.name,
        lastStudyDate: DateTime.now(),
        level: params.level,
        isHide: false,
    );

    final result = await repository.add(newSubject);
    return result.fold((failure) => Left(failure), (subject) => Right(newSubject));
  }
}