import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/ui/widgets/divider_widget.dart';
import 'package:smart_learn/app/ui/widgets/loading_item_widget.dart';
import 'package:smart_learn/app/ui/widgets/text_ai_format_widget.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/features/aihomework/presentation/state_manages/ask_ai_bloc/bloc.dart';
import 'package:smart_learn/features/aihomework/presentation/state_manages/ask_ai_bloc/event.dart';
import 'package:smart_learn/features/aihomework/presentation/state_manages/ask_ai_bloc/state.dart';
import 'package:smart_learn/features/aihomework/presentation/widgets/question_widget.dart';
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import 'package:smart_learn/utils/json_util.dart';

class SCRExerciseSolution extends StatelessWidget {
  final String textQuestion;
  final Uint8List? image;
  final String? instruct;
  final String? answer;

  const SCRExerciseSolution({
    super.key,
    required this.textQuestion,
    this.image,
    this.instruct,
  }) : answer = null;

  const SCRExerciseSolution.fromHistory({
    super.key,
    required this.textQuestion,
    this.image,
    this.instruct,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            WIDQuestionAI(textQuestion: textQuestion, imageQuestion: image),

            const SizedBox(height: 10),

            const WdgDivider(
              height: 1,
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.center,
              child: Text(
                globalLanguage.solution,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: BlocProvider<ASKAIBloc>(
                  create: (context) => ASKAIBloc(addHistory: getIt())..add(
                      answer == null
                          ? ASKAI(textQuestion: textQuestion, imageBytes: image, instruct: instruct)
                          : LoadFromHistory(answer!)
                  ),
                  child: BlocBuilder<ASKAIBloc, ASKAIState>(
                    builder: (context, state) {
                      if (state is ASKAIAnswering) {
                        return ListView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: WdgItemLoading(
                                  child: SizedBox(
                                    height: 16 + index*2.0,
                                    width: MediaQuery.of(context).size.width / 3 * (index + 1),
                                  ),
                                ),
                              );

                            }
                        );
                      }

                      if (state is ASKAIAnswer) {
                        return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: WdgTextAIFormat(textJson: UTIJson.cleanRawJsonString(state.answer)),
                            )
                        );
                      }

                      if (state is GeminiErrorState) {
                        return Center(child: Text(globalLanguage.error));
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
