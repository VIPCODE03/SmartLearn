import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/dialogs/dialog_textfiled.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/core/feature_widgets/app_widget_provider.dart';
import 'package:smart_learn/features/assistant/domain/entities/converstation_entity.dart';
import 'package:smart_learn/features/assistant/domain/parameters/conversation_params.dart';
import 'package:smart_learn/features/assistant/domain/parameters/mess_params.dart';
import 'package:smart_learn/features/assistant/presentation/state_manages/assistantconversation_viewmodel.dart';
import 'package:smart_learn/features/assistant/presentation/state_manages/assistantmess_viewmodel.dart';
import 'package:smart_learn/app/services/camera_service.dart';
import 'package:smart_learn/app/ui/dialogs/popup_dialog/popup_dialog.dart';
import 'package:smart_learn/app/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/app/ui/widgets/popup_menu_widget.dart';
import '../../domain/entities/content_entity.dart';

class SCRAssistant extends StatefulWidget {
  final ScrollController? externalScrollController;

  final String? prompt;
  final String? instruct;
  final Function(String json)? onCreated;

  const SCRAssistant({
    super.key,
    this.externalScrollController,
    this.prompt,
    this.instruct,
    this.onCreated
  });

  const SCRAssistant.create({
    super.key,
    this.externalScrollController,
    required this.prompt,
    required this.instruct,
    required this.onCreated
  });

  @override
  State<SCRAssistant> createState() => _SCRAssistantState();
}

class _SCRAssistantState extends State<SCRAssistant> {
  bool get _isTemp => widget.onCreated != null;

  void _showDialogEditName(BuildContext context, ENTConversation conversation, VMLAssistantConversation viewmodel) async {
    final newName = await showInputDialog(context: context, title: globalLanguage.rename);
    if (newName != null) {
      viewmodel.updateConversation(ConversationUpdateParams(conversation, name: newName));
    }
  }

  ///---  Drawer lịch sử  ------------------------------------------------------
  Widget _buildDrawer(VMLAssistantConversation viewModel) {
    return Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: globalLanguage.findConversation,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    viewModel.search = value;
                  },
                ),
              ),
            ),
            Expanded(
              child: Consumer<VMLAssistantConversation>(
                builder: (context, viewModel, child) {
                  final conversations = viewModel.conversations;
                  conversations.sort((a, b) {
                    return b.updateLast.compareTo(a.updateLast);
                  });
                  return ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      final title = conversation.title.isNotEmpty
                          ? conversation.title
                          : globalLanguage.newConversation;

                      return WdgPopupMenu(
                        pressType: PressType.longPress,
                        items: [
                          MenuItem(globalLanguage.rename, Icons.edit, () {
                            _showDialogEditName(context, conversation, viewModel);
                          }),
                          MenuItem(globalLanguage.delete, Icons.delete, () {
                            viewModel.deleteConversation(conversation.id);
                          }),
                        ],
                        child: ListTile(
                          leading: const Icon(Icons.chat_bubble_outline),
                          title: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            viewModel.currentConversation = conversation;
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => VMLAssistantMessage(getIt(), getIt(), isTemp: _isTemp)),
          ChangeNotifierProvider(create: (_) => VMLAssistantConversation(getIt(), getIt(), getIt(), getIt())),
        ],
        child: Consumer<VMLAssistantConversation>(
          builder: (context, conversationViewmodel, child) {
            if (conversationViewmodel.currentConversation != null) {
              context.read<VMLAssistantMessage>().loadMessage(MessGetParams(
                  MessForeignParams(
                      conversationViewmodel.currentConversation!.id))
              );
            }

          return Scaffold(
              resizeToAvoidBottomInset: false,
              ///---  Phần tiêu đề và hành động   ---------------------------------
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.design_services)
                ),
                title: Text(globalLanguage.assistant),
                actions: _isTemp
                    ? []
                    : [
                        WdgBounceButton(
                          child: const Icon(Icons.chat_bubble_outline),
                          onTap: () {
                            conversationViewmodel.newConversation();
                          },
                        ),

                        const SizedBox(width: 20),

                        Builder(
                          builder: (context) => WdgBounceButton(
                            child: const Icon(Icons.history),
                            onTap: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                          ),
                        ),

                        const SizedBox(width: 20),
                      ],
              ),

              ///-  Drawer list cuộc trò chuyện  ------------------------------------------------
              endDrawer: _isTemp ? null : _buildDrawer(conversationViewmodel),

              ///-  Body tin nhắn và nhập ------------------------------------------
              body: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    if(_isTemp)
                      Text(globalLanguage.conversationTemp, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),

                    Expanded(
                      child: _WIDListMessage(externalScrollController: widget.externalScrollController, isTemp: _isTemp, onCreated: widget.onCreated),
                    ),

                    _WIDInputContainer(context.read<VMLAssistantMessage>(), widget.instruct, _isTemp),
                  ]
                )
              )
            );
          }
        ),

    );
  }
}

///---  Mục danh sách tin nhắn  ------------------------------------------------
class _WIDListMessage extends StatefulWidget {
  final ScrollController? externalScrollController;
  final bool isTemp;
  final Function(String json)? onCreated;

  const _WIDListMessage({
    this.externalScrollController,
    required this.isTemp,
    this.onCreated
  });

  @override
  State<_WIDListMessage> createState() => _WIDListMessageState();
}

class _WIDListMessageState extends State<_WIDListMessage> {
  final Map<String, Uint8List> _cacheImage = {};
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    if (widget.externalScrollController != null) {
      _scrollController = widget.externalScrollController!;
    } else {
      _scrollController = ScrollController();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _fmt(int bytes) => '${(bytes / 1024).toStringAsFixed(1)} KB';

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

  ///---  Giao diện cho mỗi item tin nhắn  --------------------------------------
  Widget _buildMessageItem(ENTMessage message) {
    Widget contentWidget;

    final content = message.content;
    final isUser = message.role == Role.user;

    if (content is ENTContentText) {
      contentWidget = _buildContentText(content.text, isUser: isUser);

    } else if (content is ENTContentImage) {
      final text = content.text;
      final id = content.id;
      Uint8List image;

      if (_cacheImage.containsKey(id)) {
        image = _cacheImage[id]!;
      }
      else {
        image = content.image!;
        _cacheImage[id] = image;
      }
      logDev(_fmt(image.length));
      contentWidget = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _buildContentImage(image),

          const SizedBox(height: 10),

          if (text != null && text.isNotEmpty)
            _buildContentText(text, isUser: isUser)
        ],
      );

    } else if (content is ENTContentQuiz) {
      contentWidget = const SizedBox();

    } else if(content is ENTContentCreate) {
      final text = content.text;

      contentWidget = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _buildContentText(text, isUser: isUser),
          const SizedBox(height: 10),
          WdgBounceButton(
            onTap: () => widget.onCreated?.call(text),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 36),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: context.style.color.primaryColor
                )
              ),
              child: const Text('Tạo', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      );
    } else if (content is ENTContentTyping) {
      contentWidget = const _Typing();

    } else if (content is ENTContentError) {
      contentWidget = Text(
        content.message,
        style: const TextStyle(fontSize: 16.0, color: Colors.red),
      );

    } else {
      contentWidget = const SizedBox.shrink();
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5, right: isUser ? 12 : 30, left: isUser ? 30 : 12),
          child: contentWidget
      ),
    );
  }

  _buildContentText(String text, {bool isUser = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
      decoration: BoxDecoration(
        color: isUser ? context.style.color.primaryColor.withAlpha(150) : null,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16.0)),
    );
  }

  _buildContentImage(Uint8List image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 250,
          maxWidth: 250,
        ),
        child: Image.memory(image, fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VMLAssistantMessage>(
        builder: (context, messViewModel, child) {
          _scrollToBottom();
          final contents = messViewModel.messages;
          return contents.isNotEmpty
          /// Danh sách --------------------------------------------------------
              ? ListView.builder(
            controller: _scrollController,
            itemCount: contents.length,
            itemBuilder: (context, index) {
              return _buildMessageItem(contents[index]);
            },
          )
          /// Danh sách rỗng  --------------------------------------------------
              : !widget.isTemp
                ? Center(child: appWidget.user.userInfo((name, age, email, bio, grade, hobbies) => _Greeting(name: name)))
                : const SizedBox();
        });
  }
}

///---  Khu vực nhập liệu  -----------------------------------------------------
class _WIDInputContainer extends StatefulWidget {
  final VMLAssistantMessage messageViewmodel;
  final String? instruct;
  final bool isTemp;
  const _WIDInputContainer(this.messageViewmodel, this.instruct, this.isTemp);

  @override
  State<_WIDInputContainer> createState() => _WIDInputContainerState();
}

class _WIDInputContainerState extends State<_WIDInputContainer> {
  final TextEditingController _textController = TextEditingController();
  bool _hasText = false;
  Uint8List? _image;

  @override
  void initState() {
    _textController.addListener(_onTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
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

  //------------------  Gửi tin nhắn  ---------------------------
  void _send(String text, VMLAssistantMessage messageViewmodel, VMLAssistantConversation conversationViewmodel) {
    _textController.clear();
    messageViewmodel.sendMessage(text, instruct: widget.instruct, image: _image, conversationViewmodel: conversationViewmodel);
    _image = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: WdgBounceButton(
              onTap: () async {
                _image = await AppCameraService().pickImageBytesFromGallery();
                if(context.mounted) {
                  setState(() {});
                }
              },
              scaleFactor: 0.6,
              child: const Icon(Icons.grid_view_rounded),
            ),
          ),

          ///--- TextField để nhập tin nhắn ----------------------------
          Expanded(
              child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: context.style.color.primaryColor.withAlpha(25)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(_image != null)
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxHeight: 100,
                                  maxWidth: 100,
                                ),
                                child: Image.memory(_image!, fit: BoxFit.contain),
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                child: const Icon(Icons.close, size: 20, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),

                      if(_image != null)
                        const SizedBox(height: 10),

                      TextField(
                        controller: _textController,
                        decoration: InputDecoration.collapsed(
                          hintText: globalLanguage.enterMess,
                        ),
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ],
                  )
              )
          ),

          ///--- Nút gửi tin nhắn --------------------------------------------
          ValueListenableBuilder(
              valueListenable: widget.messageViewmodel.isEnting,
              builder: (context, isEnting, child) {
                return WdgBounceButton(
                    onTap: !_hasText || isEnting
                        ? () {}
                        : () {
                      final newMessUser = _textController.text.trim();
                      _send(newMessUser, widget.messageViewmodel, context.read<VMLAssistantConversation>());
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isEnting || !_hasText
                              ? Colors.grey
                              : context.style.color.primaryColor.withAlpha(100)),
                      child: const Icon(Icons.send_rounded),
                    ));
              })
        ],
      ),
    );

  }
}

///---  Text chào đoạn chat mới ------------------------------------------------
class _Greeting extends StatefulWidget {
  final String name;

  const _Greeting({required this.name});

  @override
  State<_Greeting> createState() => _GreetingState();
}

class _GreetingState extends State<_Greeting> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = '${globalLanguage.helloUser} ${widget.name}';

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Colors.purple,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.red,
              ],
              stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
              begin: Alignment(-1.0 + 2 * _controller.value, 0),
              end: Alignment(1.0 - 2 * _controller.value, 0),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

///---  Text hiển thị trạng thái đang nhập  ------------------------------------
class _Typing extends StatefulWidget {
  const _Typing();

  @override
  State<_Typing> createState() => _TypingState();
}

class _TypingState extends State<_Typing> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.style.color.primaryColor;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.2, 0.8, 1.0],
              colors: [
                Colors.transparent,
                primaryColor.withAlpha(80),
                primaryColor.withAlpha(200),
                Colors.transparent,
              ],
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
              ),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Text(
            globalLanguage.entering,
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
