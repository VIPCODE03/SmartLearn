import 'dart:convert';

class TextDocument {
  final String text;

  TextDocument({required this.text});

  factory TextDocument.fromJson(Map<String, dynamic> json) {
    var text = json['text'] as String;

    return TextDocument(
      text: text
    );
  }

  static TextDocument parseEquationData(String jsonString) {
    final jsonData = jsonDecode(jsonString);
    return TextDocument.fromJson(jsonData);
  }
}
