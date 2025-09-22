import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/features/assistant/domain/entities/content_entity.dart';
import 'package:smart_learn/features/assistant/domain/parameters/conversation_params.dart';
import 'package:smart_learn/features/assistant/domain/parameters/mess_params.dart';
import 'package:smart_learn/features/assistant/domain/usecases/message_usecase/mess_add_usecase.dart';
import 'package:smart_learn/features/assistant/domain/usecases/message_usecase/mess_get_usecase.dart';
import 'package:smart_learn/features/assistant/presentation/state_manages/assistantconversation_viewmodel.dart';
import 'package:smart_learn/performers/action_unit/gemini_action.dart';
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import 'package:smart_learn/performers/performer/gemini_performer.dart';
import 'package:zent_gemini/gemini_models.dart';

class VMLAssistantMessage extends ChangeNotifier {
  final UCEMessAdd _add;
  final UCEMessGet _get;
  final bool isTemp;
  VMLAssistantMessage(this._add, this._get, {required this.isTemp});

  final ValueNotifier<bool> isError = ValueNotifier(false);
  MessForeignParams? currentConversation;

  final List<ENTMessage> _messages = [];
  List<ENTMessage> get messages => _messages;

  final GeminiPerformer _gemPerformer = GeminiPerformer();
  final ValueNotifier<bool> isEnting = ValueNotifier(true);

  //--- Tải tin nhắn  ----------------------------------------------------------
  void loadMessage(MessGetParams params) async {
    if(currentConversation != null && currentConversation!.convertationId == params.foreign.convertationId) {
      return;
    }
    currentConversation = params.foreign;
    isError.value = false;
    isEnting.value = true;
    _messages.clear();
    final result = await _get(params);
    result.fold(
            (fail) {
              isError.value = true;
            },
            (messages) {
              _messages.addAll(messages);
              isEnting.value = false;
            }
    );
    notifyListeners();
    logDev(_messages.length.toString(), context: 'VMLAssistantMessage.loadMessage');
  }

  //--- Gửi tin nhắn  ----------------------------------------------------------
  void sendMessage(String textPrompt, {String? instruct,Uint8List? image, required VMLAssistantConversation conversationViewmodel}) async {
    bool resultAdd;
    try {
      if (image != null) {
        resultAdd = await _addMessage(MessAddParams(
            currentConversation!, role: Role.user,
            content: ENTContentImage(
                await Content.build(textPrompt: textPrompt, image: image))));
      }
      else {
        resultAdd = await _addMessage(MessAddParams(
            currentConversation!, role: Role.user,
            content: ENTContentText(
                await Content.build(textPrompt: textPrompt))));
      }
    }
    catch (e, s) {
      resultAdd = false;
      logError(e, stackTrace: s, context: 'VMLAssistantMessage.sendMessage');
    }

    //- Nếu thêm thành công ----------------------------------------------------
    if(resultAdd) {
      //  Kiểm tra nếu là cuộc trò chuyện mới ----------------------------------
      if(!isTemp && conversationViewmodel.currentConversation!.title.isEmpty && textPrompt.trim().isNotEmpty) {
        String name = textPrompt.substring(0, textPrompt.length > 20 ? 20 : textPrompt.length);
        conversationViewmodel.updateConversation(ConversationUpdateParams(conversationViewmodel.currentConversation!, name: name));
      }

      //  Hỏi AI  --------------------------------------------------------------
      isEnting.value = true;
      final List<Content> histories = [];
      for (final mess in _messages) {
        histories.add(mess.content.content!);
      }
      _gemPerformer.add(GemChat(
          mess: textPrompt,
          instruct: instruct,
          image: image,
          histories: histories
      ));

      await for (final state in _gemPerformer.stream) {
        if (state is GeminiProgressState) {
          _addMessageBotTyping();
        } else if (state is GeminiDoneState) {
          _processingResults(state.answers);
          break;
        } else if (state is GeminiErrorState) {
          _addMessageBotError(state.message ?? 'Có lỗi');
          break;
        }
      }
    }

    _removeMessageBotTyping();
    isEnting.value = false;
  }

  //--- Xử lý kết quả AI  ------------------------------------------------------
  Future<bool> _processingResults(Content contentBot) async {
    final String? text = contentBot.text;
    if(text != null) {
      if(text.startsWith('{') || text.startsWith('```')) {
        return _addMessage(MessAddParams(currentConversation!, role: Role.bot, content: ENTContentCreate(contentBot)));
      }
    }
    return _addMessage(MessAddParams(currentConversation!, role: Role.bot, content: ENTContentText(contentBot)));
  }

  //--- Thêm tin nhắn vào csdl  và danh sách  ----------------------------------
  Future<bool> _addMessage(MessAddParams params) async {
    if(isTemp) {
      _messages.add(ENTMessage('', params.role, params.content));
      notifyListeners();
      return true;
    }

    else {
      final result = await _add(params);
      return result.fold(
              (fail) => false,
              (sucsess) {
            _messages.add(sucsess);
            notifyListeners();
            return true;
          }
      );
    }
  }

  void _addMessageBotError(String message) {
    _messages.add(ENTMessage.other(Role.bot, ENTContentError(message), DateTime.now()));
    notifyListeners();
  }

  void _addMessageBotTyping() {
    if(isEnting.value) {
      _messages.add(ENTMessage.other(Role.bot, ENTContentTyping(), DateTime.now()));
      notifyListeners();
    }
  }

  void _removeMessageBotTyping() {
    for (var i = _messages.length - 1; i >= 0; i--) {
      if (_messages[i].content is ENTContentTyping) {
        _messages.removeAt(i);
        break;
      }
    }
  }
}