import 'dart:convert';
import 'dart:typed_data';
import 'package:smart_learn/utils/generate_id_util.dart';
import 'package:smart_learn/utils/json_util.dart';
import 'package:zent_gemini/gemini_models.dart';

enum Role {
  user, bot
}

class ENTMessage {
  final String id;
  final Role role;
  final ENTContent content;
  final DateTime createdAt;

  ENTMessage(
      this.id,
      this.role,
      this.content, {
        DateTime? createdAt,
      }) : createdAt = createdAt ?? DateTime.now();

  ENTMessage.other(this.role, this.content, this.createdAt) : id = 'other';
}

abstract class ENTContent {
  final Content? content;
  ENTContent(this.content);
}

class ENTContentText extends ENTContent {
  ENTContentText(super.content);

  String get text {
    final text = content?.text;
    if (text is String) {
      return text;
    }
    return '';
  }
}

class ENTContentImage extends ENTContent {
  final String id;
  ENTContentImage(super.content, {String? id}) : id = id ?? UTIGenerateID.random();

  String? get text {
    final text = content?.text;
    if (text is String) {
      return text;
    }
    return null;
  }

  Uint8List? get image {
    final image = content?.image;
    if (image is Uint8List) {
      return image;
    }
    return null;
  }
}

class ENTContentQuiz extends ENTContent {
  final String title;
  ENTContentQuiz(this.title, super.content);

  String? get jsonQuiz {
    final json = content?.text;
    if (json is String) {
      return UTIJson.cleanRawJsonString(json);
    }
    return null;
  }
}

class ENTContentCreate extends ENTContent {
  ENTContentCreate(super.content);

  String get text {
    final text = content?.text;
    if (text is String) {
      final json = UTIJson.cleanRawJsonString(text);
      return jsonDecode(json)['text'];
    }
    return '';
  }
}

class ENTContentTyping extends ENTContent {
  final String text;
  ENTContentTyping({this.text = 'Đang trả lời'}) : super(null);
}

class ENTContentError extends ENTContent {
  final String message;
  ENTContentError(this.message) : super(null);
}