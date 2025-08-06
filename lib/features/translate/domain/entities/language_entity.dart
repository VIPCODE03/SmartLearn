
class ENTLanguage {
  final String name;
  final String code;
  final String region;

  const ENTLanguage({
    required this.name,
    required this.code,
    required this.region,
  });

  @override
  String toString() {
    return '$ENTLanguage(name: $name, code: $code, region: $region)';
  }

  static ENTLanguage? fromCode(String code) {
    final language = ENTLanguage.all.where((lang) => lang.code == code);
    return language.isNotEmpty ? language.first : null;
  }

  static List<ENTLanguage> get all => const [
    ENTLanguage(name: 'Arabic', code: 'ar-SA', region: 'Saudi Arabia'),
    ENTLanguage(name: 'Bengali', code: 'bn-IN', region: 'Bangladesh, India'),
    ENTLanguage(name: 'Chinese (Simplified)', code: 'zh-CN', region: 'China'),
    ENTLanguage(name: 'Chinese (Traditional)', code: 'zh-TW', region: 'Taiwan, Hong Kong'),
    ENTLanguage(name: 'Czech', code: 'cs-CZ', region: 'Czech Republic'),
    ENTLanguage(name: 'Danish', code: 'da-DK', region: 'Denmark'),
    ENTLanguage(name: 'Dutch', code: 'nl-NL', region: 'Netherlands, Belgium'),
    ENTLanguage(name: 'English', code: 'en-US', region: 'Worldwide (US)'),
    ENTLanguage(name: 'Filipino (Tagalog)', code: 'fil-PH', region: 'Philippines'),
    ENTLanguage(name: 'Finnish', code: 'fi-FI', region: 'Finland'),
    ENTLanguage(name: 'French', code: 'fr-FR', region: 'France, Canada, Belgium'),
    ENTLanguage(name: 'German', code: 'de-DE', region: 'Germany, Austria, Switzerland'),
    ENTLanguage(name: 'Greek', code: 'el-GR', region: 'Greece'),
    ENTLanguage(name: 'Hebrew', code: 'he-IL', region: 'Israel'),
    ENTLanguage(name: 'Hindi', code: 'hi-IN', region: 'India'),
    ENTLanguage(name: 'Hungarian', code: 'hu-HU', region: 'Hungary'),
    ENTLanguage(name: 'Indonesian', code: 'id-ID', region: 'Indonesia'),
    ENTLanguage(name: 'Italian', code: 'it-IT', region: 'Italy, Switzerland'),
    ENTLanguage(name: 'Japanese', code: 'ja-JP', region: 'Japan'),
    ENTLanguage(name: 'Korean', code: 'ko-KR', region: 'South Korea'),
    ENTLanguage(name: 'Malay', code: 'ms-MY', region: 'Malaysia'),
    ENTLanguage(name: 'Norwegian', code: 'nb-NO', region: 'Norway'),
    ENTLanguage(name: 'Polish', code: 'pl-PL', region: 'Poland'),
    ENTLanguage(name: 'Portuguese', code: 'pt-BR', region: 'Brazil, Portugal'),
    ENTLanguage(name: 'Romanian', code: 'ro-RO', region: 'Romania'),
    ENTLanguage(name: 'Russian', code: 'ru-RU', region: 'Russia, Belarus'),
    ENTLanguage(name: 'Spanish', code: 'es-ES', region: 'Spain, Latin America'),
    ENTLanguage(name: 'Swedish', code: 'sv-SE', region: 'Sweden'),
    ENTLanguage(name: 'Thai', code: 'th-TH', region: 'Thailand'),
    ENTLanguage(name: 'Turkish', code: 'tr-TR', region: 'Turkey'),
    ENTLanguage(name: 'Ukrainian', code: 'uk-UA', region: 'Ukraine'),
    ENTLanguage(name: 'Urdu', code: 'ur-PK', region: 'Pakistan, India'),
    ENTLanguage(name: 'Vietnamese', code: 'vi-VN', region: 'Vietnam'),
  ];
}