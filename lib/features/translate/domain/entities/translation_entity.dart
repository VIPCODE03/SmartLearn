
class ENTTranslation {
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;

  ENTTranslation({
    required this.originalText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  @override
  String toString() {
    return 'Translation(originalText: $originalText, translatedText: $translatedText, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage)';
  }
}