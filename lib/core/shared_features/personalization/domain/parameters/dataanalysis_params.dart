import 'package:smart_learn/core/shared_features/personalization/domain/entities/data_analysis_entity.dart';

abstract class PARDataAnalysis {}

class PARDataAnalysisAdd extends PARDataAnalysis {
  final String tag;
  final String ownerId;
  final Map<int, String> analysis;

  PARDataAnalysisAdd({
    required this.tag,
    required this.ownerId,
    required this.analysis
  });
}

class PARDataAnalysisUpdate extends PARDataAnalysis {
  final ENTAnalysis entity;
  final String? tag;
  final String? ownerId;
  final Map<int, String>? analysis;

  PARDataAnalysisUpdate(
      this.entity, {
        this.tag,
        this.ownerId,
        this.analysis,
  });
}

abstract class PARDataAnalysisDelete extends PARDataAnalysis {}

class PARDataAnalysisDeleteAll extends PARDataAnalysisDelete {}

class PARDataAnalysisDeleteById extends PARDataAnalysisDelete {
  final String id;
  PARDataAnalysisDeleteById(this.id);
}

class PARDataAnalysisDeleteByOwnerId extends PARDataAnalysisDelete {
  final String ownerId;
  PARDataAnalysisDeleteByOwnerId(this.ownerId);
}

abstract class PARDataAnalysisGet extends PARDataAnalysis {}

class PARDataAnalysisGetAll extends PARDataAnalysisGet {}

class PARDataAnalysisGetById extends PARDataAnalysisGet {
  final String id;
  PARDataAnalysisGetById(this.id);
}

class PARDataAnalysisGetByOwnerId extends PARDataAnalysisGet {
  final String ownerId;
  PARDataAnalysisGetByOwnerId(this.ownerId);
}

class PARDataAnalysisGetByTag extends PARDataAnalysisGet {
  final String tag;
  PARDataAnalysisGetByTag(this.tag);
}