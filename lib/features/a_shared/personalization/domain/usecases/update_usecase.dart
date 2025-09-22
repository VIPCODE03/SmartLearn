import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/a_shared/personalization/domain/entities/data_analysis_entity.dart';
import 'package:smart_learn/features/a_shared/personalization/domain/parameters/dataanalysis_params.dart';
import 'package:smart_learn/features/a_shared/personalization/domain/repositories/analysis_repository.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

class UCEAnalysisUpdate extends UseCase<ENTAnalysis, PARDataAnalysisUpdate> {
  final REPAnalysis _repository;
  UCEAnalysisUpdate(this._repository);

  @override
  Future<Either<Failure, ENTAnalysis>> call(PARDataAnalysisUpdate params) async {
    final entityUpdated = ENTAnalysis(
      id: UTIGenerateID.random(),
      tag: params.tag ?? params.entity.tag,
      ownerId: params.ownerId ?? params.entity.ownerId,
      analysis: params.analysis ?? params.entity.analysis,
      version: params.entity.version + 1,
    );
    final result = await _repository.update(entityUpdated);
    return result.fold(
            (l) => Left(l),
            (r) => r ? Right(entityUpdated) : Left(CacheFailure())
    );
  }
}