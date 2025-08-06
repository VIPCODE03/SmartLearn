import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/performers/action_unit/gemini_action.dart';
import 'package:smart_learn/performers/performer/gemini_performer.dart';
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import 'package:smart_learn/ui/widgets/divider_widget.dart';
import 'package:smart_learn/ui/widgets/loading_item_widget.dart';
import 'package:smart_learn/ui/widgets/text_ai_format_widget.dart';
import 'package:smart_learn/utils/json_util.dart';
import '../../../../global.dart';

class SCRExerciseSolution extends StatelessWidget {
  final dynamic data;
  final String topic;
  final String instruct;

  const SCRExerciseSolution({
    super.key,
    this.data,
    required this.topic,
    required this.instruct,
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
            Hero(
              tag: 'question',
              child: Container(
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor(context).withAlpha(20),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 0.5),
                    ),
                  ],
                ),
                child: Builder(
                  builder: (context) {
                    if (data is String) {
                      return Material(
                        type: MaterialType.transparency,
                        child: SingleChildScrollView(child: Text(data)),
                      );
                    } else if (data is CroppedFile) {
                      return Image.file(
                        File((data as CroppedFile).path),
                        fit: BoxFit.contain,
                      );
                    } else {
                      return Material(
                        type: MaterialType.transparency,
                        child: Text(globalLanguage.error),
                      );
                    }
                  },
                ),
              ),
            ),

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
              child: PerformerProvider<GeminiPerformer>.create(
                  create: (_) => GeminiPerformer()..add(AskAction(topic: topic, instruct: instruct, question: data)),
                  child: PerformerBuilder<GeminiPerformer>(
                    builder: (context, performer) {
                      final state = performer.current;

                      if (state is GeminiProgressState) {
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

                      if (state is GeminiDoneState) {
                        return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: WdgTextAIFormat(textJson: UTIJson.cleanRawJsonString(state.answers.text!)),
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
