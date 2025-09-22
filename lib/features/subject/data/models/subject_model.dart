import 'package:smart_learn/core/database/tables/subject_table.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';

SubjectTable _table = SubjectTable.instance;

class MODSubject extends ENTSubject {
  MODSubject({
    required super.id,
    required super.name,
    required super.lastStudyDate,
    required super.level,
    required super.isHide,
  });

  Map<String, dynamic> toMap() {
    return {
      _table.columnId: id,
      _table.columnName: name,
      _table.columnLastStudyDate: lastStudyDate.toIso8601String(),
      _table.columnLevel: level,
      _table.columnIsHide: isHide ? 1 : 0,
    };
  }

  factory MODSubject.fromMap(Map<String, dynamic> map) {
    return MODSubject(
      id: map[_table.columnId],
      name: map[_table.columnName],
      lastStudyDate: DateTime.parse(map[_table.columnLastStudyDate]),
      level: map[_table.columnLevel],
      isHide: map[_table.columnIsHide] == 1,
    );
  }

  factory MODSubject.fromEntity(ENTSubject entity) {
    return MODSubject(
      id: entity.id,
      name: entity.name,
      lastStudyDate: entity.lastStudyDate,
      level: entity.level,
      isHide: entity.isHide,
    );
  }
}