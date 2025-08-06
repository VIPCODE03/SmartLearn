
class UTIJson {
  static String cleanRawJsonString(String raw) {
    String cleaned = raw.trim();

    if ((cleaned.startsWith("'''") && cleaned.endsWith("'''")) ||
        (cleaned.startsWith('"""') && cleaned.endsWith('"""')) ||
        (cleaned.startsWith('```') && cleaned.endsWith('```'))
    ) {
      cleaned = cleaned.substring(3, cleaned.length - 3).trim();
    }

    final jsonPrefixPattern = RegExp(r"^(json|JSON)\s*[:\-]?\s*", caseSensitive: false);
    cleaned = cleaned.replaceFirst(jsonPrefixPattern, '');

    return cleaned.trim();
  }

}