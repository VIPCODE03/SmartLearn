
import 'package:flutter/cupertino.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/features/focus/presentation/state_manages/focus_performer/focus_action.dart';
import 'package:smart_learn/features/focus/presentation/state_manages/focus_performer/focus_datastate.dart';
import 'package:smart_learn/features/focus/presentation/state_manages/focus_performer/focus_performer.dart';
import 'package:smart_learn/core/di/injection.dart';

typedef FocusBuilder = Widget Function({
  required bool isFocused,
  required List<double> Function() getHoursInWeekly,
  required Duration Function() getTotal,
  required void Function() toggle,
});

class WIDFocusStatus extends StatelessWidget {
  final FocusBuilder buildWidget;

  const WIDFocusStatus({super.key, required this.buildWidget});

  @override
  Widget build(BuildContext context) {
    return PerformerProvider<FocusPerformer>.external(
      performer: getIt<FocusPerformer>()..add(InitFocus(getFocusUseCase: getIt())),
      child: PerformerBuilder<FocusPerformer>(builder: (context , perf) {
        final state = perf.current;

        return buildWidget(
          isFocused: state is FocusingState,
          getTotal: () => state.weeklyFocus.total,
          getHoursInWeekly: () => state.weeklyFocus.hourList,
          toggle: () => toggleFocus(perf, state is FocusingState),
        );
      }),
    );
  }

  void toggleFocus(FocusPerformer perf, bool isFocusing) {
    if (isFocusing) {
      perf.add(StopFocus());
    } else {
      perf.add(StartFocus(
        addTimeFocusUseCase: getIt(),
      ));
    }
  }
}