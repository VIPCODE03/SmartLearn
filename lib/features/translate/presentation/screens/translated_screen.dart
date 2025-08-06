import 'package:flutter/material.dart';
import 'package:performer/performer_build.dart';
import 'package:smart_learn/features/translate/domain/entities/language_entity.dart';
import 'package:smart_learn/features/translate/domain/entities/translation_entity.dart';

import '../../../../../performers/action_unit/gemini_action.dart';
import '../../../../../performers/data_state/gemini_state.dart';
import '../../../../../performers/performer/gemini_performer.dart';
import '../../../../../services/text_to_speech_service.dart';
import '../../../../../ui/widgets/loading_item_widget.dart';

///-  Màn hình dịch ------------------------------------------------------------
class SCRTranslated extends StatefulWidget {
  final String originalText;
  final String? translatedText;
  final String? codeSourceLanguage;
  final String codeTargetLanguage;

  const SCRTranslated({
    super.key,
    required this.originalText,
    required this.codeTargetLanguage,
    this.translatedText,
    this.codeSourceLanguage
  });

  @override
  State<SCRTranslated> createState() => _SCRTranslatedState();
}

class _SCRTranslatedState extends State<SCRTranslated> {
  int indexExpand = 0;
  late ENTTranslation _translation;

  @override
  void initState() {
    super.initState();

    _translation = ENTTranslation(
        originalText: widget.originalText,
        translatedText: widget.translatedText ?? '',
        sourceLanguage: widget.codeSourceLanguage ?? '',
        targetLanguage: widget.codeTargetLanguage
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: PerformerProvider<GeminiPerformer>.create(
          create: (context) => GeminiPerformer()..add(GemTranslate(originalText: widget.originalText, targetLanguage: widget.codeTargetLanguage)),
          child: PerformerBuilder<GeminiPerformer>(builder: (context, performer) {
            final state = performer.current;
            if(state is GeminiDoneState) {
              final String translationJson = state.answers.text ?? 'Lỗi';
            }

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: indexExpand == 2
                        ? const SizedBox()
                        : Container(
                      height: indexExpand == 1 ? maxHeight * 0.8 : maxHeight * 0.4,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(5),
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: _TranslateItem(
                        languageCode: _translation.sourceLanguage,
                        data: _translation.originalText,
                        textStyle: null,
                        onExpand: () {
                          setState(() {
                            indexExpand = (indexExpand == 1) ? 0 : 1;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: indexExpand == 1
                        ? const SizedBox()
                        : Container(
                      height: indexExpand == 2 ? maxHeight * 0.8 : maxHeight * 0.4,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(5),
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: _TranslateItem(
                        languageCode: _translation.targetLanguage,
                        data: _translation.translatedText,
                        textStyle: null,
                        onExpand: () {
                          setState(() {
                            indexExpand = (indexExpand == 2) ? 0 : 2;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          })
      ),
    );
  }
}

///-  Item dịch ----------------------------------------------------------------
class _TranslateItem extends StatelessWidget {
  final String languageCode;
  final String data;
  final TextStyle? textStyle;
  final VoidCallback onExpand;

  const _TranslateItem({
    required this.languageCode,
    required this.data,
    required this.textStyle,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              languageCode.isNotEmpty
                  ? Text(ENTLanguage.fromCode(languageCode)?.name ?? '', style: const TextStyle(color: Colors.grey))
                  : const SizedBox(height: 40, width: 60, child: WdgItemLoading()),

              Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                final textToSpeech = TextToSpeechService()..setLanguage(languageCode);
                                textToSpeech.speak(data);
                              },
                              icon: const Icon(Icons.volume_up)
                          ),

                          const SizedBox(width: 5),

                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.copy)
                          ),

                          const SizedBox(width: 5),

                          IconButton(
                              onPressed: onExpand,
                              icon: const Icon(Icons.fullscreen)
                          )
                        ]
                    ),
                  )
              )
            ],
          ),

          const SizedBox(height: 10),

          data.isNotEmpty
              ? Expanded(child: SingleChildScrollView(child: Text(data, style: textStyle)))
              : const SizedBox(height: 40, width: 100, child: WdgItemLoading())
        ],
      ),
    );
  }
}
