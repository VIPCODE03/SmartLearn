
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/subject/domain/repositories/subject_repository.dart';

class SubjectDeleteParams {
  final String id;
  SubjectDeleteParams({required this.id});
}

class UCESubjectDelete extends UseCase<bool, SubjectDeleteParams> {
  final REPSubject repository;
  UCESubjectDelete({required this.repository});

  @override
  Future<Either<Failure, bool>> call(SubjectDeleteParams params) {
    return repository.delete(params.id);
  }
}