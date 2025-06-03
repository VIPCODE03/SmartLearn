
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAI {
  static const String flash1_5 = 'gemini-1.5-flash';
  static const String flash1_5_8b = 'gemini-1.5-flash-8b';
  static const String pro1_5 = 'gemini-1.5-pro';
  static const String aqa = 'aqa';
  static const String flash2 = "gemini-2.0-flash";
  static const String flashLite2 = "gemini-2.0-flash-lite";
  static const String proErimental2 = "gemini-2.0-pro-exp-02-05";

  String model;
  String apiKey = 'AIzaSyBwQDMZO8sx4dYcEXMWuQad-eqf1CnEFQ8';
  GenerativeModel gemini;
  final List<Content> history = [];
  ChatSession? conversation;

  GeminiAI({required this.model})
      :
        gemini = GenerativeModel(
          model: model,
          apiKey: 'AIzaSyAH34wpY8AhiXS73lHRI43BPDOJ8y9nWhg',
        );

  Future<String?> ask(String question) async {
    final response = await gemini.generateContent([Content.text(question)]);
    return response.text;
  }

  Future<String?> chat(String message) async {
    conversation ??= gemini.startChat(history: history);
    var response = await conversation?.sendMessage(Content.text(message));
    return response?.text;
  }

  void train(String message) {
    history.add(Content.text(message));
    history.add(Content.model([TextPart('OK, tôi đã sẵn sàng trả lời người dùng!')]));
  }
}
