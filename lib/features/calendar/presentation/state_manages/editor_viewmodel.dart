import 'package:flutter/cupertino.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/parameters/calendar_params.dart';
import 'package:smart_learn/features/calendar/domain/usecases/calendar_add_usecase.dart';
import 'package:smart_learn/features/calendar/domain/usecases/calendar_check_duplicate_usecase.dart';
import 'package:smart_learn/features/calendar/domain/usecases/calendar_update_usecase.dart';

class VMLCalendarEditor extends ChangeNotifier {
  final UCECalendarAdd _add;
  final UCECalendarUpdate _update;
  final UCECalendarCheckDuplicate _useCaseCheckDuplicate;

  VMLCalendarEditor(this._add, this._update, this._useCaseCheckDuplicate);

  Future<ENTCalendar?> add({
    required PARCalendarAdd params
  }) async {
    final result = await _add(params);
    return result.fold(
            (l) => null,
            (newCalendar) => newCalendar
    );
  }

  Future<ENTCalendar?> update({
    required PARCalendarUpdate params
  }) async {
    final result = await _update(params);
    return result.fold(
            (l) => null,
            (newCalendar) => newCalendar
    );
  }

  Future<bool> checkDuplicate({
    required PARCalendarCheckDuplicate params
  }) async {
    final result = await _useCaseCheckDuplicate(params);
    await Future.delayed(const Duration(seconds: 1));
    return result.fold(
            (l) => false,
            (r) => r
    );
  }
}