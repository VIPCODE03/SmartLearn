import 'dart:convert';

import 'package:smart_learn/core/database/tables/dataanalysis_table.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/entities/data_analysis_entity.dart';

DataAnalysisTable get _table => DataAnalysisTable.instance;

class MODDataAnalysis extends ENTAnalysis {
  MODDataAnalysis({
    required super.id,
    required super.tag,
    required super.ownerId,
    required super.analysis,
    required super.version,
  });

  Map<String, dynamic> toJson() {
    return {
      _table.columnId: id,
      _table.columnTag: tag,
      _table.columnOwnerId: ownerId,
      _table.columnAnalysis: jsonEncode(analysis),
      _table.columnVersion: version,
    };
  }

  factory MODDataAnalysis.fromJson(Map<String, dynamic> json) {
    return MODDataAnalysis(
      id: json[_table.columnId] as String,
      tag: json[_table.columnTag] as String,
      ownerId: json[_table.columnOwnerId] as String,
      analysis: jsonDecode(json[_table.columnAnalysis]) as Map<int, String>,
      version: json[_table.columnVersion] as int,
    );
  }

  factory MODDataAnalysis.fromEntity(ENTAnalysis entity) {
    return MODDataAnalysis(
      id: entity.id,
      tag: entity.tag,
      ownerId: entity.ownerId,
      analysis: entity.analysis,
      version: entity.version,
    );
  }
}