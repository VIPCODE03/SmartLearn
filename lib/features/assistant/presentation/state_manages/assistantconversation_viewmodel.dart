import 'package:flutter/cupertino.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/features/assistant/domain/entities/converstation_entity.dart';
import 'package:smart_learn/features/assistant/domain/parameters/conversation_params.dart';
import 'package:smart_learn/features/assistant/domain/usecases/conversation_usecases/conversation_add_usecase.dart';
import 'package:smart_learn/features/assistant/domain/usecases/conversation_usecases/conversation_update_usecase.dart';
import 'package:smart_learn/features/assistant/domain/usecases/conversation_usecases/delete_conversation_usecase.dart';
import 'package:smart_learn/features/assistant/domain/usecases/conversation_usecases/get_conversation_usecase.dart';
import 'package:diacritic/diacritic.dart';

class VMLAssistantConversation extends ChangeNotifier {
  final UCEConversationAdd _add;
  final UCEConversationUpdate _update;
  final UCEConversationDelete _delete;
  final UCEConversationGet _get;
  VMLAssistantConversation(
      this._add,
      this._update,
      this._delete,
      this._get
      ) {
    _init();
  }

  String? _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  final List<ENTConversation> _conversations = [];
  List<ENTConversation> get conversations {
    if(_search == null) {
      return _conversations;
    }
    return _searchConversation(_search!);
  }
  ENTConversation? _currentConversation;
  ENTConversation? get currentConversation => _currentConversation;
  set currentConversation(ENTConversation? value) {
    _currentConversation = value;
    notifyListeners();
  }

  Future<void> _init() async {
    await getConversationAll();
    newConversation();
  }

  //--- Cuộc trò chuyện --------------------------------------------------------
  void newConversation() async {
    final available = _conversations.where((conversation) => conversation.title == '').toList();
    if (available.isEmpty) {
      final result = await _add(ConversationAddParams(name: ''));
      result.fold(
              (failure) {
                logDev('failure');
              },
              (conversation) {
                currentConversation = conversation;
                _conversations.add(conversation);
              });
    }
    else {
      currentConversation = available.first;
    }
    notifyListeners();
  }

  void updateConversation(ConversationUpdateParams params) async {
    final result = await _update(params);
    result.fold(
            (failure) {},
            (conversationUpdated) {
              _conversations.removeWhere((conversation) => conversation.id == conversationUpdated.id);
              _conversations.add(conversationUpdated);
              notifyListeners();
        });
  }

  //- Delete  ------------------------------------------------------------------
  void deleteConversation(String id) async {
    final result = await _delete(ConversationDeleteParams(id));
    result.fold(
            (failure) {},
            (data) {
              _conversations.removeWhere((element) => element.id == id);
              if(currentConversation?.id == id) {
                newConversation();
              }
              notifyListeners();
        });
  }

  //--  Get --------------------------------------------------------------------
  Future<void> getConversationAll() async {
    final result = await _get(ConversationGetAllParams());
    result.fold(
            (failure) {},
            (conversations) {
              _conversations.clear();
              _conversations.addAll(conversations);
              notifyListeners();
            });
  }

  //- Search  ------------------------------------------------------------------
  List<ENTConversation> _searchConversation(String search) {
    final normalizedSearch = removeDiacritics(search.toLowerCase().trim());
    return _conversations.where((conversation) {
      final title = removeDiacritics(conversation.title.toLowerCase());
      return title.contains(normalizedSearch);
    }).toList();
  }
}
