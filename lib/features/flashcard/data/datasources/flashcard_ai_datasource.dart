import 'dart:convert';

import 'package:smart_learn/app/assets/app_assets.dart';
import 'package:smart_learn/app/config/gemini_config.dart';
import 'package:smart_learn/core/error/exeption.dart';
import 'package:smart_learn/features/flashcard/data/datasources/flashcard_local_datasource.dart';
import 'package:smart_learn/features/flashcard/data/models/flashcard_model.dart';
import 'package:smart_learn/utils/json_util.dart';
import 'package:zent_gemini/gemini_models.dart';

sealed class ADSFlashcard {
  Future<List<MODFlashCard>> getFlashCard(String instruct, String cardSetId);
}

class ADSFlashcardImpl extends ADSFlashcard {
  final LDSFlashCard _localDataSource = LDSFlashCardImpl();

  @override
  Future<List<MODFlashCard>> getFlashCard(String instruct, String cardSetId) async {
    List<MODFlashCard> cards = [];

    final gemAI = GeminiAIConfig.gemAI('gemini-2.5-flash');
    gemAI.setSystemInstruction = await AppAssets.loadString(AppAssets.path.train.flashcard);

    final result = await gemAI.generateContent(await Content.build(textPrompt: instruct));
    if(result != null && result.text != null) {
      final json = jsonDecode(UTIJson.cleanRawJsonString(result.text!));
      if(json is List) {
        cards = json.map((e) => MODFlashCard.fromJson(e as Map<String, dynamic>, cardSetId)).toList();
        for(final card in cards) {
          await _localDataSource.add(card);
        }
        return cards;
      }
      else if(json is Map) {
        cards.add(MODFlashCard.fromJson(json as Map<String, dynamic>, cardSetId));
        await _localDataSource.add(cards.first);
        return cards;
      }
      throw const FormatException();
    }
    else {
      throw const AIException();
    }
  }
}