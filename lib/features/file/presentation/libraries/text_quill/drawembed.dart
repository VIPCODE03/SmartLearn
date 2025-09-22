import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../flutter_drawing_custom/draw_screen.dart';

class DrawEmbed extends Embeddable {
  const DrawEmbed(String value)
      : super(drawType, value);

  static const String drawType = 'draw';

  static DrawEmbed fromDocument(Document document)
  => DrawEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class DrawEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'draw';

  @override
  String toPlainText(Embed node) {
    return node.value.data;
  }

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    return SizedBox(
        height: 200,
        width: 200,
        child: DrawScreen(
          json: embedContext.node.value.data as String,
          edit: false,
        )
    );
  }
}