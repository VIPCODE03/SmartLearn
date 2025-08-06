import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';
import 'package:smart_learn/features/file/domain/parameters/load_params.dart';
import 'package:smart_learn/features/file/domain/repositories/appfile_repository.dart';

class UCEAppFileLoad extends UseCase<List<ENTAppFile>, AppFileLoadParams> {
  final REPAppFile repository;
  UCEAppFileLoad(this.repository);

  @override
  Future<Either<Failure, List<ENTAppFile>>> call(AppFileLoadParams params) async {
    return repository.getFiles(params.pathId, foreign: params.link);
  }
}