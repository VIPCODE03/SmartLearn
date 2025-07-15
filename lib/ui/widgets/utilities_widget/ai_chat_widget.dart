import 'package:flutter/material.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/performers/action_unit/gemini_action.dart';
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import 'package:smart_learn/performers/performer/gemini_performer.dart';
import 'package:smart_learn/ui/widgets/bouncebutton_widget.dart';

class WdgChat extends StatefulWidget {
  final ScrollController? externalScrollController;

  const WdgChat({
    super.key,
    this.externalScrollController,
  });
  @override
  State<WdgChat> createState() => _WdgChatState();
}

class _WdgChatState extends State<WdgChat> {
  final TextEditingController _textController = TextEditingController();
  late ScrollController _scrollController;
  final List<_Content> _messages = [];

  bool _hasText = false;
  bool _newMess = false;
  bool _isEnting = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    if(widget.externalScrollController != null) {
      _scrollController = widget.externalScrollController!;
    }
    else {
      _scrollController = ScrollController();
    }

    _addContentBot('Xin chào, tôi có thể giúp gì cho bạn?');
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  //------------------  Gửi tin nhắn  ---------------------------
  void _addContentUser(String text) {
    _textController.clear(); 
    setState(() {
      _messages.add(_Content(_Role.user, text.trim()));
    });
    _scrollToBottom(); 
  }

  void _addContentBot(String text) {
    setState(() {
      _messages.add(_Content(_Role.bot, text.trim()));
    });
    _scrollToBottom();
  }

  void _addContentEnting() {
    if(!_isEnting) {
      _isEnting = true;
      _addContentBot('...');
    }
  }

  void _removeContentEnting() {
    if(_isEnting) {
      _isEnting = false;
      _messages.removeLast();
    }
  }

  //---------------------- Nghe thay đổi ô nhập -----------------
  void _onTextChanged() {
    final hasText = _textController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  //-------------  Hàm để cuộn ------------------
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  ///---  Giao diện cho mỗi item tin nhắn  -------------
  Widget _buildMessageItem(_Content message) {
    final bool isUserMessage = message.role == _Role.user;

    if(isUserMessage) {
      return _buildMessUser(message.content);
    }
    else {
      return _buildMessBot(message.content);
    }
  }

  Widget _buildMessUser(String mess) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5, right: 12, left: 24),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        decoration: BoxDecoration(
          color: primaryColor(context).withAlpha(10),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          mess,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildMessBot(String mess) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5, right: 24, left: 12),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(10),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          mess,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  ///---  Khu vực nhập liệu  --------------
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            ///--- TextField để nhập tin nhắn ----------------------------
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor(context).withAlpha(25)
                ),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration.collapsed(
                    hintText: "Nhập tin nhắn...",
                  ),
                  minLines: 1,
                  maxLines: 5,
                ),
              )
            ),

            ///--- Nút gửi tin nhắn --------------------------------------------
            PerformerProvider<GeminiPerformer>.create(
                create: (_) => GeminiPerformer(),
                child: PerformerBuilder<GeminiPerformer>(builder: (context, performer) {
                  final currentState = performer.current;

                  if(currentState is GeminiDoneState && _newMess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && _newMess) {
                        _newMess = false;
                        _removeContentEnting();
                        _addContentBot(currentState.answers);
                      }
                    });
                  }

                  if(currentState is GeminiProgressState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _addContentEnting();
                      }
                    });
                  }

                  return WdgBounceButton(
                      onTap: currentState is GeminiProgressState || !_hasText
                          ? () {}
                          : () {
                        final newMessUser = _textController.text.trim();
                        _newMess = true;
                        _addContentUser(newMessUser);
                        performer.add(GemChat(mess: newMessUser));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: currentState is GeminiProgressState || !_hasText
                                ? Colors.grey
                                : primaryColor(context).withAlpha(100)
                        ),
                        child: const Icon(Icons.send_rounded),
                      )
                  );
                })
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMessageItem(_messages[index]);
              },
            ),
          ),

          _buildTextComposer(),
        ],
      ),
    );
  }
}

class _Content {
  final _Role role;
  final String content;

  _Content(this.role, this.content);

  Map<String, dynamic> toMap() {
    return {
      'role': role.toString(),
      'content': content
    };
  }

  factory _Content.fromMap(Map<String, dynamic> map) {
    _Role roleValue = _Role.values.firstWhere(
          (e) => e.toString() == map['role'],
      orElse: () => _Role.user,
    );
    return _Content(
        roleValue,
        map['content']
    );
  }
}

enum _Role {
  user, bot
}