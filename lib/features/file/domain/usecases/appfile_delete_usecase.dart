import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/file/domain/parameters/delete_params.dart';
import 'package:smart_learn/features/file/domain/repositories/appfile_repository.dart';

class UCEAppFileDelete extends UseCase<bool, AppFileDeleteParams> {
  final REPAppFile repository;
  UCEAppFileDelete(this.repository);

  @override
  Future<Either<Failure, bool>> call(AppFileDeleteParams params) async {
    return repository.deleteFile(params.file.id);
  }
}