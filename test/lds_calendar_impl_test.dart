import 'package:flutter_test/flutter_test.dart';
import 'package:smart_learn/features/calendar/data/datasources/calendar_local_data_source.dart';
import 'package:smart_learn/features/calendar/data/models/b_calendar_event_model.dart';
import 'package:smart_learn/features/calendar/data/models/zz_time_model.dart';
import 'package:smart_learn/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';

void main() {
  group('REPCalendarImpl', () {
    late REPCalendarImpl rep;

    setUp(() {
      rep = REPCalendarImpl(localDataSource: LDSCalendarImpl());
      LDSCalendarImpl.demo.clear();
    });

    test('add should add calendar to the list', () async {
      final calendar = MODCalendarEvent(
          id: '1',
          title: 'Test Calendar',
          start: DateTime.now(),
          end: DateTime(2025, 07, 16, 10, 00),
      );
      await rep.add(calendar);

      final all = await rep.getAll();
      expect(all.isRight(), true);
      final allValue = all.getOrElse(() => []);
      expect(allValue.length, 1);

      final entity = allValue.first;
      await rep.add(entity);
      final all2 = await rep.getAll();
      expect(all2.isRight(), true);
      final allValue2 = all2.getOrElse(() => []);
      print(allValue2.toString());
      expect(allValue2.length, 2);
    });
  });
}
