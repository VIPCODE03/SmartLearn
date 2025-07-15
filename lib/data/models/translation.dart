
class Translation {
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;

  Translation({
    required this.originalText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
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

  @override
  String toString() {
    return 'Translation(originalText: $originalText, translatedText: $translatedText, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage)';
  }
}