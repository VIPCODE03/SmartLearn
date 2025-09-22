import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/a_shared/personalization/domain/entities/data_analysis_entity.dart';
import 'package:smart_learn/features/a_shared/personalization/domain/parameters/dataanalysis_params.dart';
import 'package:smart_learn/features/a_shared/personalization/domain/repositories/analysis_repository.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

class UCEAnalysisAdd extends UseCase<ENTAnalysis, PARDataAnalysisAdd> {
  final REPAnalysis _repository;
  UCEAnalysisAdd(this._repository);

  @override
  Future<Either<Failure, ENTAnalysis>> call(PARDataAnalysisAdd params) async {
    final newEntity = ENTAnalysis(
      id: UTIGenerateID.random(),
      tag: params.tag,
      ownerId: params.ownerId,
      analysis: params.analysis,
      version: 1,
    );
    final result = await _repository.add(newEntity);
    return result.fold(
            (l) => Left(l),
            (r) => r ? Right(newEntity) : Left(CacheFailure())
    );
  }
}