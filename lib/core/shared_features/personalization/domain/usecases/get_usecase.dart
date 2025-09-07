import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/entities/data_analysis_entity.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/parameters/dataanalysis_params.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/repositories/analysis_repository.dart';
import 'package:smart_learn/core/usecase.dart';

abstract class UCEAnalysisGet<T> extends UseCase<T, PARDataAnalysisGet> {
  final REPAnalysis _repository;
  UCEAnalysisGet(this._repository);
}

class UCEDataAnalysisGetList extends UCEAnalysisGet<List<ENTAnalysis>> {
  UCEDataAnalysisGetList(super.repository);

  @override
  Future<Either<Failure, List<ENTAnalysis>>> call(PARDataAnalysisGet params) async {
    return await switch (params) {
      PARDataAnalysisGetAll _ => _repository.getAll(),
      PARDataAnalysisGetByTag(tag : String tag) => _repository.getByTag(tag),
      _ => throw UnimplementedError(),
    };
  }
}

class UCEDataAnalysisGetData extends UCEAnalysisGet<ENTAnalysis?> {
  UCEDataAnalysisGetData(super.repository);

  @override
  Future<Either<Failure, ENTAnalysis?>> call(PARDataAnalysisGet params) async {
    return await switch (params) {
      PARDataAnalysisGetById(id : String id) => _repository.getById(id),
      PARDataAnalysisGetByOwnerId(ownerId : String ownerId) => _repository.getByOwnerId(ownerId),
      _ => throw UnimplementedError(),
    };
  }
}