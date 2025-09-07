
import 'package:smart_learn/features/calendar/domain/entities/zz_cycle_entity.dart';

class MODCycle extends ENTCycle {
  MODCycle({
    required super.type,
    required super.daysOfWeek,
  });

  Map<String, dynamic> toMap() {
    return {
      "type": type.toString(),
      "daysOfWeek": daysOfWeek?.toList(),
    };
  }

  factory MODCycle.fromMap(Map<String, dynamic> map) {
    return MODCycle(
      type: RecurrenceType.values.firstWhere((type) => type.toString() == map["type"]),
      daysOfWeek: (map['daysOfWeek'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toSet(),
    );
  }

  factory MODCycle.fromEntity(ENTCycle entity) {
    return MODCycle(
      type: entity.type,
      daysOfWeek: entity.daysOfWeek,
    );
  }
}