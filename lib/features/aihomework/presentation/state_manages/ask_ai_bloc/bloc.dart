import 'package:bloc/bloc.dart';
import 'package:smart_learn/config/gemini_config.dart';
import 'package:smart_learn/features/aihomework/domain/parameters/aihomework_history_params.dart';
import 'package:smart_learn/features/aihomework/domain/usecases/aihomework_history_add_usecase.dart';
import 'package:smart_learn/features/aihomework/presentation/state_manages/ask_ai_bloc/event.dart';
import 'package:smart_learn/features/aihomework/presentation/state_manages/ask_ai_bloc/state.dart';
import 'package:smart_learn/services/storage_service.dart';
import 'package:smart_learn/utils/assets_util.dart';
import 'package:zent_gemini/gemini_config.dart';
import 'package:zent_gemini/gemini_models.dart';
import 'package:zent_gemini/gemini_service.dart';

class ASKAIBloc extends Bloc<ASKAIEvent, ASKAIState> {
  final UCEAIHomeWorkHistoryAdd addHistory;

  ASKAIBloc({required this.addHistory}) : super(ASKAIAnswering()) {
    on<ASKAI>(_onASKAI);
    on<LoadFromHistory>(_onLoadFromHistory);
  }

  void _onASKAI(ASKAI event, Emitter<ASKAIState> emit) async {
    emit(ASKAIAnswering());
    String intructFormat = await UTIAssets.loadString(UTIAssets.path.train.format);
    String intructMission = await UTIAssets.loadString(UTIAssets.path.train.mission);

    final gemAI = GeminiAI(GeminiConfig(
      apiKey: GeminiAIConfig.apiKey,
      model: 'gemini-2.5-flash',
    ));


    gemAI.setSystemInstruction = ""
        "mission: $intructMission"
        "\njson format: $intructFormat"
        "";

    String newQuestion = ''
        'Trả lời câu hỏi: ${event.textQuestion}'
        '\nUser hướng dẫn: ${event.instruct}';
    Content? answers;
    answers = await gemAI.generateContent(await Content.build(textPrompt: newQuestion, image: event.imageBytes));

    if(answers != null && answers.text != null) {
      String? imagePath;
      if(event.imageBytes != null) {
        imagePath = await AppStorageService.saveByte(event.imageBytes!);
      }

      final addParams = PARAIHomeWorkHistoryAdd(
          textQuestion: event.textQuestion,
          textAnswer: answers.text!,
          imagePath: imagePath
      );
      final result = await addHistory(addParams);
      result.fold(
              (fail) => emit(ASKAIError()),
              (data) => emit(ASKAIAnswer(data.textAnswer))
      );
    }
  }

  void _onLoadFromHistory(LoadFromHistory event, Emitter<ASKAIState> emit) {
    emit(ASKAIAnswer(event.answer));
  }
}