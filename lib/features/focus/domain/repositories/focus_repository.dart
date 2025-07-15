
import 'package:dartz/dartz.dart';
import 'package:smart_learn/features/focus/domain/entities/weekly_focus_entity.dart';

import '../../../../core/error/failures.dart';

abstract class REPFocus {

  //  - CẬP NHẬT  --------------------------------------------------------------

  //  - Update by day -
  Future<Either<Failure, void>> updateFocus(ENTWeeklyFocus focus);

  //  - LẤY DỮ LIỆU  --------------------------------------------------------------

  // -  Lấy dữ liệu theo tuần -
  Future<Either<Failure, ENTWeeklyFocus>> getWeeklyFocus();
}