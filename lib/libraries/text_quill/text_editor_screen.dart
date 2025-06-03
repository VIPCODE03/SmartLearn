import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class TextEditorScreen extends StatefulWidget {
  final String? json;
  const TextEditorScreen({super.key, this.json});

  @override
  State<TextEditorScreen> createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  final QuillController _controller = () {
    return QuillController.basic(
        config: const QuillControllerConfig(
          clipboardConfig: QuillClipboardConfig(
            enableExternalRichPaste: true,
          ),
        ));
  }();
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if(widget.json != null) {
      _controller.document = Document.fromJson(jsonDecode(widget.json!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soạn văn bản'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Print Delta JSON to log',
            onPressed: () {
              Navigator.pop(context, jsonEncode(_controller.document.toDelta().toJson()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ExpansionTile(
              title: const Text('Tools', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                QuillSimpleToolbar(
                  controller: _controller,
                  config: QuillSimpleToolbarConfig(
                    showClipboardPaste: false,
                    customButtons: const [
/*                      QuillToolbarCustomButtonOptions(
                        icon: const Icon(Icons.add_alarm_rounded),
                        onPressed: () {
                          _controller.document.insert(
                            _controller.selection.extentOffset,
                            TimeStampEmbed(
                              DateTime.now().toString(),
                            ),
                          );

                          _controller.updateSelection(
                            TextSelection.collapsed(
                              offset: _controller.selection.extentOffset + 1,
                            ),
                            ChangeSource.local,
                          );
                        },
                      ),*/
/*                      QuillToolbarCustomButtonOptions(
                        icon: const Icon(Icons.draw),
                        onPressed: () async {
                          final result = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const DrawScreen())
                          );
                          _controller.document.insert(
                            _controller.selection.extentOffset,
                            DrawEmbed(result),
                          );

                          _controller.updateSelection(
                            TextSelection.collapsed(
                              offset: _controller.selection.extentOffset + 1,
                            ),
                            ChangeSource.local,
                          );
                        },
                      ),*/
                    ],
                    buttonOptions: QuillSimpleToolbarButtonOptions(
                      base: QuillToolbarBaseButtonOptions(
                        afterButtonPressed: () {
                          final isDesktop = {
                            TargetPlatform.linux,
                            TargetPlatform.windows,
                            TargetPlatform.macOS
                          }.contains(defaultTargetPlatform);
                          if (isDesktop) {
                            _editorFocusNode.requestFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: QuillEditor(
                focusNode: _editorFocusNode,
                scrollController: _editorScrollController,
                controller: _controller,
                config: const QuillEditorConfig(
                  placeholder: 'Start writing your notes...',
                  padding: EdgeInsets.all(16),
                  embedBuilders: [
                    // TimeStampEmbedBuilder(),
                    // DrawEmbedBuilder()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorScrollController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }
}