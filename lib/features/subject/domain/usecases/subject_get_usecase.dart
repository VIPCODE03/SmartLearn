import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';
import 'package:smart_learn/features/subject/domain/repositories/subject_repository.dart';

abstract class SubjectGetParams {}

class SubjectGetParamsAll extends SubjectGetParams {}

class SubjectGetParamsById extends SubjectGetParams {
  final String id;
  SubjectGetParamsById({required this.id});
}

class UCESubjectGet extends UseCase<List<ENTSubject>, SubjectGetParams> {
  final REPSubject repository;
  UCESubjectGet({required this.repository});

  @override
  Future<Either<Failure, List<ENTSubject>>> call(SubjectGetParams params) {
    switch(params) {
      case SubjectGetParamsAll():
        return repository.getAllSubject();
      case SubjectGetParamsById():
        throw UnimplementedError();
      default:
        throw UnimplementedError();
    }
  }
}