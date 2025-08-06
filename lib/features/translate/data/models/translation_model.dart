
import 'package:smart_learn/features/translate/domain/entities/translation_entity.dart';

class MODTranslation extends ENTTranslation {
  MODTranslation({
    required super.originalText,
    required super.translatedText,
    required super.sourceLanguage,
    required super.targetLanguage
  });

  factory MODTranslation.fromJson(Map<String, dynamic> json) {
    return MODTranslation(
        originalText: json['originalText'],
        translatedText: json['translatedText'],
        sourceLanguage: json['sourceLanguage'],
        targetLanguage: json['targetLanguage']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalText': originalText,
      'translatedText': translatedText,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage
    };
  }

}