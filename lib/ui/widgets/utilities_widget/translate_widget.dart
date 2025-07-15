import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:performer/performer_build.dart';
import 'package:smart_learn/data/models/translation.dart';
import 'package:smart_learn/services/text_to_speech_service.dart';
import 'package:smart_learn/ui/widgets/loading_item_widget.dart';
import 'package:smart_learn/ui/widgets/textfeild_widget.dart';

import '../../../global.dart';
import '../../../performers/action_unit/gemini_action.dart';
import '../../../performers/data_state/gemini_state.dart';
import '../../../performers/performer/gemini_performer.dart';
import '../bouncebutton_widget.dart';

///-  Widget chính -------------------------------------------------------------
class WdgTranslation extends StatefulWidget {
  const WdgTranslation({super.key});

  @override
  State<StatefulWidget> createState() => _WdgTranslationState();
}

class _WdgTranslationState extends State<WdgTranslation> {
  final TextEditingController _inputController = TextEditingController();

  int indexExpand = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.history, color: Colors.grey)
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                    child: Center(child: Text('Phát hiện ngôn ngữ', style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500)))
                ),

                const SizedBox(width: 5),

                const Icon(Icons.arrow_forward),

                const SizedBox(width: 5),

                Expanded(
                    child: Center(child: WdgBounceButton(
                        child: Text(_targetLanguageIndex.name, style: TextStyle(color: primaryColor(context), fontSize: 18, fontWeight: FontWeight.w500)),
                        onTap: () {
                          _showBottomSheetSelectLanguage(context, (i) {
                            setState(() {});
                          });
                        }
                    ))
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withAlpha(10),
                        offset: const Offset(0, 2)
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập văn bản cần dịch',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                )
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_inputController.text.isNotEmpty) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                    _TranslatedScreen(
                        originalText: _inputController.text,
                        targetLanguage: _targetLanguageIndex.name
                    )
            ));
          }
        },
        backgroundColor: primaryColor(context),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.arrow_forward),
      ),

    );
  }
}

///-  Màn hình dịch ------------------------------------------------------------
class _TranslatedScreen extends StatefulWidget {
  final String originalText;
  final String? translatedText;
  final String? sourceLanguage;
  final String targetLanguage;

  const _TranslatedScreen({
    required this.originalText,
    required this.targetLanguage,
    this.translatedText,
    this.sourceLanguage
  });

  @override
  State<_TranslatedScreen> createState() => _TranslatedScreenState();
}

class _TranslatedScreenState extends State<_TranslatedScreen> {
  int indexExpand = 0;
  late Translation _translation;

  @override
  void initState() {
    super.initState();

    _translation = Translation(
        originalText: widget.originalText,
        translatedText: widget.translatedText ?? '',
        sourceLanguage: widget.sourceLanguage ?? '',
        targetLanguage: widget.targetLanguage
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: PerformerProvider<GeminiPerformer>.create(
          create: (context) => GeminiPerformer()..add(GemTranslate(originalText: widget.originalText, targetLanguage: widget.targetLanguage)),
          child: PerformerBuilder<GeminiPerformer>(builder: (context, performer) {
            final state = performer.current;
            if(state is GeminiDoneState) {
              final String translationJson = state.answers;
              _translation = Translation.fromJson(jsonDecode(translationJson));
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
                        language: _translation.sourceLanguage,
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
                        language: _translation.targetLanguage,
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
  final String language;
  final String data;
  final TextStyle? textStyle;
  final VoidCallback onExpand;

  const _TranslateItem({
    required this.language,
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
              language.isNotEmpty
                  ? Text(_getNameFromCode(language), style: const TextStyle(color: Colors.grey))
                  : const SizedBox(height: 40, width: 60, child: WdgItemLoading()),

              Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                final textToSpeech = TextToSpeechService()..setLanguage(language);
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

//--  Tất cả ngôn ngữ   --------------------------------------------------------
class _TranslationLanguage {
  final String name;
  final String code;
  final String region;

  const _TranslationLanguage({
    required this.name,
    required this.code,
    required this.region,
  });

  @override
  String toString() {
    return '$_TranslationLanguage(name: $name, code: $code, region: $region)';
  }
}

const List<_TranslationLanguage> _languages = [
  _TranslationLanguage(name: 'Arabic', code: 'ar-SA', region: 'Saudi Arabia'),
  _TranslationLanguage(name: 'Bengali', code: 'bn-IN', region: 'Bangladesh, India'),
  _TranslationLanguage(name: 'Chinese (Simplified)', code: 'zh-CN', region: 'China'),
  _TranslationLanguage(name: 'Chinese (Traditional)', code: 'zh-TW', region: 'Taiwan, Hong Kong'),
  _TranslationLanguage(name: 'Czech', code: 'cs-CZ', region: 'Czech Republic'),
  _TranslationLanguage(name: 'Danish', code: 'da-DK', region: 'Denmark'),
  _TranslationLanguage(name: 'Dutch', code: 'nl-NL', region: 'Netherlands, Belgium'),
  _TranslationLanguage(name: 'English', code: 'en-US', region: 'Worldwide (US)'),
  _TranslationLanguage(name: 'Filipino (Tagalog)', code: 'fil-PH', region: 'Philippines'),
  _TranslationLanguage(name: 'Finnish', code: 'fi-FI', region: 'Finland'),
  _TranslationLanguage(name: 'French', code: 'fr-FR', region: 'France, Canada, Belgium'),
  _TranslationLanguage(name: 'German', code: 'de-DE', region: 'Germany, Austria, Switzerland'),
  _TranslationLanguage(name: 'Greek', code: 'el-GR', region: 'Greece'),
  _TranslationLanguage(name: 'Hebrew', code: 'he-IL', region: 'Israel'),
  _TranslationLanguage(name: 'Hindi', code: 'hi-IN', region: 'India'),
  _TranslationLanguage(name: 'Hungarian', code: 'hu-HU', region: 'Hungary'),
  _TranslationLanguage(name: 'Indonesian', code: 'id-ID', region: 'Indonesia'),
  _TranslationLanguage(name: 'Italian', code: 'it-IT', region: 'Italy, Switzerland'),
  _TranslationLanguage(name: 'Japanese', code: 'ja-JP', region: 'Japan'),
  _TranslationLanguage(name: 'Korean', code: 'ko-KR', region: 'South Korea'),
  _TranslationLanguage(name: 'Malay', code: 'ms-MY', region: 'Malaysia'),
  _TranslationLanguage(name: 'Norwegian', code: 'nb-NO', region: 'Norway'),
  _TranslationLanguage(name: 'Polish', code: 'pl-PL', region: 'Poland'),
  _TranslationLanguage(name: 'Portuguese', code: 'pt-BR', region: 'Brazil, Portugal'),
  _TranslationLanguage(name: 'Romanian', code: 'ro-RO', region: 'Romania'),
  _TranslationLanguage(name: 'Russian', code: 'ru-RU', region: 'Russia, Belarus'),
  _TranslationLanguage(name: 'Spanish', code: 'es-ES', region: 'Spain, Latin America'),
  _TranslationLanguage(name: 'Swedish', code: 'sv-SE', region: 'Sweden'),
  _TranslationLanguage(name: 'Thai', code: 'th-TH', region: 'Thailand'),
  _TranslationLanguage(name: 'Turkish', code: 'tr-TR', region: 'Turkey'),
  _TranslationLanguage(name: 'Ukrainian', code: 'uk-UA', region: 'Ukraine'),
  _TranslationLanguage(name: 'Urdu', code: 'ur-PK', region: 'Pakistan, India'),
  _TranslationLanguage(name: 'Vietnamese', code: 'vi-VN', region: 'Vietnam'),
];

String _getNameFromCode(String code) {
  final language = _languages.where((lang) => lang.code == code);
  return language.isNotEmpty ? language.first.name : '';
}

_TranslationLanguage _targetLanguageIndex = _languages[0];

void _showBottomSheetSelectLanguage(BuildContext context, Function(String) onSelect) {
  String search = "";
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
              height: MediaQuery.of(context).size.height / 1.5,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Chọn ngôn ngữ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withAlpha(10),
                            offset: const Offset(0, 2)
                        )
                      ],
                    ),
                    child: WdgTextFeildCustom(
                      hintText: 'Tìm kiếm',
                      onChanged: (value) {
                        setState(() {
                          search = value ?? '';
                        });
                      },
                    ),
                  ),

                  Expanded(
                      child: ListView(
                        children: _languages.map((language) {
                          if(search.isEmpty || language.name.toLowerCase().contains(search.toLowerCase())) {
                            return TextButton(
                                onPressed: () {
                                  _targetLanguageIndex = language;
                                  onSelect(language.name);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(language.name)
                                    ),

                                    if(_targetLanguageIndex == language)
                                      const Icon(Icons.check),
                                  ],
                                )
                            );
                          }
                          return const SizedBox.shrink();
                        }).toList(),
                      )
                  )
                ],
              )
          );
        });
      }
  );
}