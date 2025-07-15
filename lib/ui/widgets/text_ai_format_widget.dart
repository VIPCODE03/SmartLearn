
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';

class WdgTextAIFormat extends StatelessWidget {
  final String textJson;
  const WdgTextAIFormat({super.key, required this.textJson});

  @override
  Widget build(BuildContext context) {
    return TeXView(
      loadingWidgetBuilder: (_) => const Center(child: WdgLoading()),
      child: TeXViewDocument(_TextDocument.parseEquationData(textJson).text),
      style: const TeXViewStyle(
        elevation: 6,
        padding: TeXViewPadding.all(16),
      ),
    );
  }
}

class _TextDocument {
  final String text;

  _TextDocument({required this.text});

  factory _TextDocument.fromJson(Map<String, dynamic> json) {
    var text = json['text'] as String;

    return _TextDocument(
        text: text
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'text': text,
    };
    return data;
  }

  static _TextDocument parseEquationData(String jsonString) {
    final jsonData = jsonDecode(jsonString);
    return _TextDocument.fromJson(jsonData);
  }
}
