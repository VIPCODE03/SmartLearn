import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/file/domain/parameters/checknameduplicate_params.dart';
import 'package:smart_learn/features/file/domain/repositories/appfile_repository.dart';

class UCEAppFileCheckNameDuplicate extends UseCase<bool, AppFileCheckDuplicateParams> {
  final REPAppFile repository;
  UCEAppFileCheckNameDuplicate(this.repository);

  @override
  Future<Either<Failure, bool>> call(AppFileCheckDuplicateParams params) async {
    final result = await repository.getFileByPathName(params.pathId, params.newName, foreign: params.foreign);
    result.fold(
            (fail) {
              return Left(fail);
            },
            (files) {
              if(files != null) {
                return const Right(true);
              }
            }
    );
    return const Right(false);
  }
}