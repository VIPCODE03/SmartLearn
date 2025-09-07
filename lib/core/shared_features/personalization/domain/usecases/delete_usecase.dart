import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/parameters/dataanalysis_params.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/repositories/analysis_repository.dart';
import 'package:smart_learn/core/usecase.dart';

class UCEAnalysisDelete extends UseCase<bool, PARDataAnalysisDelete> {
  final REPAnalysis _repository;
  UCEAnalysisDelete(this._repository);

  @override
  Future<Either<Failure, bool>> call(PARDataAnalysisDelete params) async {
    return await switch (params) {
      PARDataAnalysisDeleteAll() => _repository.deleteAll(),
      PARDataAnalysisDeleteById(id : String id) => _repository.delete(id),
      PARDataAnalysisDeleteByOwnerId(ownerId : String ownerId) => _repository.deleteByOwnerId(ownerId),
      _ => throw UnimplementedError(),
    };
  }
}
