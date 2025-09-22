import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:smart_learn/features/file/presentation/libraries/flutter_drawing_custom/add_hisotry.dart';
import 'package:smart_learn/features/file/presentation/libraries/flutter_drawing_custom/triangle.dart';

class DrawScreen extends StatefulWidget {
  final String? json;
  final bool edit;

  const DrawScreen({super.key, this.json, this.edit = true});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final DrawingController _drawingController = DrawingController();
  final TransformationController _transformationController = TransformationController();
  double _colorOpacity = 1;

  @override
  void initState() {
    _addHistory();
    super.initState();
  }

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  void _addHistory() {
    if (widget.json != null) {
      try {
        _drawingController.addContentsDecode(widget.json!);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  /// 获取画板数据 `getImageData()`
  void _getImageData() async {
    final Uint8List? data =
        (await _drawingController.getImageData())?.buffer.asUint8List();
    if (data != null && mounted) {
      showDialog<void>(
        context: context,
        builder: (BuildContext c) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => Navigator.pop(c),
                child: InteractiveViewer(
                    minScale: 1.0, maxScale: 25, child: Image.memory(data))),
          );
        },
      );
    }
  }

  void _restBoard() {
    _transformationController.value = Matrix4.identity();
  }

  void _updateView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: widget.edit
          ? AppBar(
              leading: PopupMenuButton<Color>(
                icon: Icon(Icons.color_lens,
                    color: _drawingController.drawConfig.value.color),
                onSelected: (ui.Color value) => _drawingController.setStyle(
                    color: value.withValues(alpha: _colorOpacity)),
                itemBuilder: (_) {
                  return <PopupMenuEntry<ui.Color>>[
                    PopupMenuItem<Color>(
                      child: StatefulBuilder(
                        builder: (BuildContext context,
                            Function(void Function()) setState) {
                          return Slider(
                            value: _colorOpacity,
                            onChanged: (double v) {
                              _drawingController.setStyle(
                                color: _drawingController.drawConfig.value.color
                                    .withValues(alpha: _colorOpacity),
                              );
                              setState(() => _colorOpacity = v);
                              _updateView();
                            },
                          );
                        },
                      ),
                    ),
                    ...Colors.accents.map((ui.Color color) {
                      return PopupMenuItem<ui.Color>(
                          value: color,
                          child:
                              Container(width: 200, height: 50, color: color));
                    }),
                  ];
                },
              ),
              actions: widget.edit
                  ? <Widget>[
                      IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            Navigator.pop(context,
                                jsonEncode(_drawingController.getJsonList()));
                          }),
                      IconButton(
                          icon: const Icon(Icons.restore_page_rounded),
                          onPressed: _restBoard),
                    ]
                  : null,
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Transform.scale(
                  scale: widget.edit ? 1 : 1,
                  child: IgnorePointer(
                      ignoring: widget.edit ? false : true,
                      child: DrawingBoard(
                          minScale: 0.9,
                          maxScale: 10,
                          transformationController: _transformationController,
                          controller: _drawingController,
                          background: Container(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            color: Colors.white,
                          ),
                          showDefaultActions: widget.edit ? true : false,
                          showDefaultTools: widget.edit ? true : false,
                          defaultToolsBuilder: widget.edit
                              ? (Type t, _) {
                            return DrawingBoard.defaultTools(
                                t, _drawingController)
                              ..insert(
                                4,
                                DefToolItem(
                                  icon: Icons.change_history_rounded,
                                  isActive: t == Triangle,
                                  onTap: () => _drawingController
                                      .setPaintContent(Triangle()),
                                ),
                              );
                          }
                              : null
                      )
                  ),
                );
              },
            ),
            if (!widget.edit)
              Positioned(
                top: 2,
                right: 2,
                child: IconButton(
                    onPressed: () => _getImageData(),
                    icon: const Icon(Icons.image)),
              ),
          ],
        ),
      ),
    );
  }
}
