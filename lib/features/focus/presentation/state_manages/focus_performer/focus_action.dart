import 'dart:async';

import 'package:performer/main.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/focus/domain/usecases/a_add_time_focus.dart';
import 'package:smart_learn/features/focus/domain/usecases/get_focus.dart';

import '../../../../../app/services/banner_service.dart';
import '../../../domain/entities/weekly_focus_entity.dart';
import '../../widgets/focus_banner_widget.dart';
import 'focus_datastate.dart';

abstract class FocusAction extends ActionUnit<FocusState> {
  static Timer? _timer;

  _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

class InitFocus extends FocusAction {
  final UCEGetFocus getFocusUseCase;

  InitFocus({required this.getFocusUseCase});

  @override
  Stream<FocusState> execute(FocusState current) async* {
    if(current is! FocusInitState) return;
    final focus = await getFocusUseCase(NoParams());
    focus.fold(
          (failure) {
            emit(FocusInitError(
                elapsed: Duration.zero,
                weeklyFocus: ENTWeeklyFocus(year: 0, weekNumber: 0, durations: const {}))
            );
          },
          (data) {
            emit(FocusInitiated(
              elapsed: Duration.zero,
              weeklyFocus: data,
            ));
          },
    );
  }
}

class StartFocus extends FocusAction {
  final UCEAddTimeFocus addTimeFocusUseCase;

  StartFocus({
    required this.addTimeFocusUseCase,
  });

  @override
  Stream<FocusState> execute(FocusState current) async* {
    if(current is FocusingState || current is FocusInitError) return;
    Duration elapsed = current.elapsed;
    FocusState state = current;

    AppBannerService().showBanner(const GlobalFocusTimerBar());
    yield FocusingState(elapsed: elapsed, weeklyFocus: current.weeklyFocus);

    FocusAction._timer = Timer.periodic(const Duration(seconds: 1), (_) async {
        const time = Duration(seconds: 1);
        elapsed += time;
        final today = DateTime.now();
        final addParams = AddTimeFocusParams(
          duration: time,
          day: today,
        );
        final addResult = await addTimeFocusUseCase(addParams);
        addResult.fold(
                (failure) {
                  _stopTimer();
                  AppBannerService().removeBanner();
                    emit(FocusInitiated(
                        elapsed: elapsed,
                        weeklyFocus: state.weeklyFocus,
                    ));
                },
                (data) {
                  state = FocusingState(elapsed: elapsed, weeklyFocus: data);
                  emit(state);
                }
        );
    });
  }
}

class StopFocus extends FocusAction {
  @override
  Stream<FocusState> execute(FocusState current) async* {
    if (current is FocusingState) {
      _stopTimer();
      AppBannerService().removeBanner();
      yield FocusInitiated(elapsed: Duration.zero, weeklyFocus: current.weeklyFocus);
    }
  }
}
