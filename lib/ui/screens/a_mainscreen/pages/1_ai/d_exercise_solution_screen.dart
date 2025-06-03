import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/performers/action_unit/gemini_action.dart';
import 'package:smart_learn/performers/performer/gemini_conductor.dart';
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import '../../../../../global.dart';
import '../../../../widgets/text_ai_answer.dart';

class ExerciseSolutionScreen extends StatelessWidget {
  final dynamic data;
  final String topic;
  final String instruct;

  const ExerciseSolutionScreen({
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
            Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.grey.withAlpha(50),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                globalLanguage.solution,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: PerformerProvider<GeminiConductor>(
                  create: () => GeminiConductor()
                    ..add(AskAction(topic: topic, instruct: instruct, question: data)),
                  child: ConductorBuilder<GeminiConductor>(
                    builder: (context, conductor) {
                      if (conductor.current.state == GemState.progress) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (conductor.current.state == GemState.done) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor(context).withAlpha(6),
                                blurRadius: 6,
                                spreadRadius: 1,
                                offset: const Offset(0, 0.5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: WdgTextAIAnswer(jsonString: conductor.current.answers),
                        );
                      }

                      if (conductor.current.state == GemState.error) {
                        return Center(child: Text(globalLanguage.error));
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
