import 'dart:convert';

import 'package:smart_learn/core/database/tables/subject_table.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';

SubjectTable _table = SubjectTable.instance;

class MODSubject extends ENTSubject {
  MODSubject({
    required super.id,
    required super.name,
    required super.lastStudyDate,
    required super.tags,
    required super.level,
    required super.exercisesScores
  });

  Map<String, dynamic> toMap() {
    return {
      _table.columnId: id,
      _table.columnName: name,
      _table.columnLastStudyDate: lastStudyDate.toIso8601String(),
      _table.columnTags: jsonEncode(tags),
      _table.columnLevel: level,
      _table.columnExercisesScores: jsonEncode(exercisesScores),
    };
  }

  factory MODSubject.fromMap(Map<String, dynamic> map) {
    return MODSubject(
      id: map[_table.columnId],
      name: map[_table.columnName],
      lastStudyDate: DateTime.parse(map[_table.columnLastStudyDate]),
      tags: List<String>.from(jsonDecode(map[_table.columnTags])),
      level: map[_table.columnLevel],
      exercisesScores: List<double>.from(jsonDecode(map[_table.columnExercisesScores])),
    );
  }

  factory MODSubject.fromEntity(ENTSubject entity) {
    return MODSubject(
      id: entity.id,
      name: entity.name,
      lastStudyDate: entity.lastStudyDate,
      tags: entity.tags,
      level: entity.level,
      exercisesScores: entity.exercisesScores,
    );
  }
}