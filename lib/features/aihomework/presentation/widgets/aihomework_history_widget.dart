import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/ui/widgets/loading_item_widget.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/features/aihomework/domain/parameters/aihomework_history_params.dart';
import 'package:smart_learn/features/aihomework/presentation/screens/d_exercise_solution_screen.dart';
import 'package:smart_learn/features/aihomework/presentation/state_manages/history_bloc/bloc.dart';
import 'package:smart_learn/features/aihomework/presentation/state_manages/history_bloc/event.dart';
import 'package:smart_learn/features/aihomework/presentation/state_manages/history_bloc/state.dart';

typedef HistoryBuilder = Widget Function(

    /// Map key [id] và [title]
    List<Map<String, String>> titles,

    /// Mở lịch sử
    Function(String id) openDetail,
);

class WIDAIHomeWorkHistory extends StatelessWidget with AppRouterMixin {
  final HistoryBuilder builder;
  const WIDAIHomeWorkHistory({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AIHomeWorkBloc>(
        create: (context) => AIHomeWorkBloc(getHistory: getIt(), deleteHistory: getIt())..add(AIHomeWorkHistoryGet(PARAIHomeWorkHistoryGetAll())),
        child: BlocBuilder<AIHomeWorkBloc, AIHomeWorkHistoryState>(
            builder: (context, state) {
              if(state is AIHomeWorkHistoryNoData) {
                if(state is AIHomeWorkHistoryLoading) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WdgItemLoading(
                        child: SizedBox(
                          height: 10,
                          width: 200,
                        ),
                      ),
                      SizedBox(height: 10),
                      WdgItemLoading(
                        child: SizedBox(
                          height: 10,
                          width: 300,
                        ),
                      ),
                    ],
                  );
                }
                if(state is AIHomeWorkHistoryError) {
                  return Text(globalLanguage.error);
                }
              }
              if(state is AIHomeWorkHistoryHasData) {
                final mapHistories = state.histories.map((e) => {'id': e.id, 'title': e.textQuestion}).toList();
                return SizedBox(
                  child: builder(
                      mapHistories,
                      (id) async {
                        final history = state.histories.firstWhere((element) => element.id == id);
                        if(history.imagePath != null) {
                          final file = File(history.imagePath!);
                          final imgBytes = await file.readAsBytes();
                          if(context.mounted) {
                            pushFade(context, SCRExerciseSolution.fromHistory(
                                textQuestion: history.textQuestion,
                                image: imgBytes,
                                instruct: '',
                                answer: history.textAnswer,
                            ));
                          }
                        }
                        else {
                          if(context.mounted) {
                            pushFade(context, SCRExerciseSolution.fromHistory(
                                textQuestion: history.textQuestion,
                                image: null,
                                instruct: '',
                                answer: history.textAnswer,
                            ));
                          }
                        }
                      }
                  )
                );
              }
              return const SizedBox();
        }),
    );
  }
}