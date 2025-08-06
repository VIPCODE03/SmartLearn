import 'package:smart_learn/features/calendar/domain/entities/zz_cycle_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';
import 'package:smart_learn/features/calendar/domain/usecases/calendar_add_update_usecase.dart';
import 'package:smart_learn/features/calendar/domain/usecases/calendar_check_duplicate_usecase.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

class BuidCalendarParams {
  final int type;
  final String? id;
  final String title;
  final DateTime start;
  final DateTime end;
  final String? cycle;
  final Set<int>? weekdays;

  final String? subjectId;
  final String? desc;

  const BuidCalendarParams({
    required this.type,
    this.id,
    required this.title,
    required this.start,
    required this.end,
    this.cycle,
    this.weekdays,

    this.subjectId,
    this.desc,
  });
}

class VMLCalendarEditor extends ChangeNotifier {
  final UCECalendarAddOrUpdate _useCaseUpdate;
  final UCECalendarCheckDuplicate _useCaseCheckDuplicate;

  VMLCalendarEditor({
    required UCECalendarAddOrUpdate useCaseUpdate,
    required UCECalendarCheckDuplicate useCaseCheckDuplicate,
  })
      : _useCaseUpdate = useCaseUpdate,
        _useCaseCheckDuplicate = useCaseCheckDuplicate;

  Future<bool> addOrUpdate({
    required BuidCalendarParams params
  }) async {
    final result = await _useCaseUpdate(CalendarAddOrUpdateParams(calendar: _buildCalendar(params: params), isUpdate: params.id != null ? true : false));
    return result.fold(
            (l) => false,
            (r) => true
    );
  }

  Future<bool> checkDuplicate({
    required BuidCalendarParams params
  }) async {
    final result = await _useCaseCheckDuplicate(CalendarCheckDuplicateParams(calendar: _buildCalendar(params: params)));
    await Future.delayed(const Duration(seconds: 1));
    return result.fold(
            (l) => false,
            (r) => r
    );
  }

  ENTCalendar _buildCalendar({
    required BuidCalendarParams params
  }) {
    final entCycle = switch(params.cycle) {
      'weekly' => ENTCycle.weekly(params.weekdays ?? {}),
      'daily' => ENTCycle.daily(),
      _ => null,
    };
    if(params.type == 0) {
      return ENTCalendarEvent(id: params.id ?? UTIGenerateID.random(), title: params.title, start: params.start, end: params.end, cycle: entCycle);
    }
    return ENTCalendarSubject(id: params.id ?? UTIGenerateID.random(), title: params.title, subjectId: params.subjectId ?? '', start: params.start, end: params.end, cycle: entCycle);
  }
}