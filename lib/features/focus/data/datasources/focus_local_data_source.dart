import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_learn/core/error/exeption.dart';
import 'package:smart_learn/features/focus/data/models/weekly_focus_model.dart';

const _cachedWeeklyFocus = 'CACHED_WEEKLY_FOCUS';

abstract class LDSFocus {

  //- Lấy dữ liệu từ bộ nhớ -
  Future<MODWeeklyFocus> getLastWeeklyFocus();

  //- Lưu vào bộ nhớ -
  Future<void> cacheWeeklyFocus(MODWeeklyFocus focusToCache);
}

class LDSFocusImpl extends LDSFocus {
  final SharedPreferences sharedPreferences;

  LDSFocusImpl({required this.sharedPreferences});

  @override
  Future<void> cacheWeeklyFocus(MODWeeklyFocus focusToCache) {
    final jsonMap = focusToCache.toJson();

    final jsonString = json.encode(jsonMap);
    return sharedPreferences.setString(_cachedWeeklyFocus, jsonString);
  }

  @override
  Future<MODWeeklyFocus> getLastWeeklyFocus() {
    final jsonString = sharedPreferences.getString(_cachedWeeklyFocus);

    if(jsonString != null) {
      try {
        final jsonMap = json.decode(jsonString);
        final model = MODWeeklyFocus.fromJson(jsonMap);
        return Future.value(model);
      } catch (e) {
        throw FormatException("ERROR FORMAT JSON: $e");
      }
    } else {
      return Future.value(MODWeeklyFocus.empty());
    }
  }
}