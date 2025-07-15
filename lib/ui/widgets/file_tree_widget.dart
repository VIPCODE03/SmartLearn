import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:open_filex/open_filex.dart';
import 'package:smart_learn/data/models/file/file.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/libraries/text_quill/text_editor_screen.dart';
import 'package:smart_learn/ui/dialogs/dialog_textfiled.dart';
import 'package:smart_learn/ui/dialogs/scale_dialog.dart';
import 'package:smart_learn/ui/screens/b_quizscreen/manage/a_quiz_manage_screen.dart';
import 'package:smart_learn/ui/widgets/popup_menu_widget.dart';
import 'package:ulid/ulid.dart';
import 'package:path/path.dart' as p;

import '../../libraries/flutter_drawing_custom/draw_screen.dart';
import '../screens/b_quizscreen/play/a_quiz_screen.dart';

class WdgFileTree extends StatefulWidget {
  final bool isTheory;
  final List<AppFile> files;
  final Widget Function(BuildContext context, AppFile item)? itemBuilder;

  const WdgFileTree({super.key, required this.files, this.itemBuilder, required this.isTheory});

  @override
  State<StatefulWidget> createState() => _WdgFileTreeState();
}

class _WdgFileTreeState extends State<WdgFileTree> {
  final List<String?> stackId = [];
  final _key = GlobalKey<ExpandableFabState>();

  @override
  void initState() {
    super.initState();
    stackId.add(null);
  }

  AppFileFolder? get currentFolder {
    final id = stackId.last;
    return widget.files.whereType<AppFileFolder>().firstWhere(
          (f) => f.id == id,
          orElse: () => AppFileFolder(id: 'root', name: 'Root', pathId: null, dateCreated: DateTime.now()),
        );
  }

  //---------------- Mở file --------------------------------
  Future<void> _open(AppFile file) async {
    //------------------ file -------------------------
    if(file is AppFileSystem) {
      try {
        final OpenResult result = await OpenFilex.open(file.filePath);

        if (result.type != ResultType.done) {
          // print('Không thể mở file: ${result.message}');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Lỗi: ${result.message}')),
          // );
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    //--------------------------- draw ------------------------
    else if(file is AppFileDraw) {
      final newJson = await Navigator.push(context, MaterialPageRoute(builder: (context) => DrawScreen(json: file.json)));
      if(newJson != file.json) {
        setState(() {
          file.json = newJson;
        });
      }
    }

    //----------------- folder -------------------------
    else if(file is AppFileFolder) {
      setState(() {
        stackId.add(file.id);
      });
    }

    //------------------- txt ----------------------------
    else if(file is AppFileTxt) {
      final newJson = await Navigator.push(context, MaterialPageRoute(builder: (context) => TextEditorScreen(json: file.content)));
      if(newJson != file.content) {
        setState(() {
          file.content = newJson;
        });
      }
    }

    //------------------- quiz ----------------------------
    else if(file is AppFileQuiz) {
      showDialog(context: context, builder: (context) {
        return _MenuQuiz(file);
      });
    }
  }

  //----------------- Thêm file -----------------------------
  Future<void> _add(BuildContext context, String type) async {
    final state = _key.currentState;
    if (state != null) {
      state.toggle();
    }
    switch(type) {
      //----------------folder---------------
      case 'folder': {
        final name = await showInputDialog(
          context: context,
          title: 'Thêm thư mục',
          hint: 'Nhập tên thư mục'
        );
        if(name != null && name.isNotEmpty) {
          setState(() {
            widget.files.add(AppFileFolder(id: Ulid().toString(), name: name, pathId: stackId.last, dateCreated: DateTime.now()));
          });
        }
      }

      //-------------------- txt ----------------
      case 'txt': {
        final content = await Navigator.push(context, MaterialPageRoute(builder: (context) => const TextEditorScreen()));
        if(content != null) {
          setState(() {
            widget.files.add(AppFileTxt(id: Ulid().toString(), name: 'Tài liệu', pathId: stackId.last, content: content, dateCreated: DateTime.now()));
          });
        }
      }

      //--------------------- draw -----------------
      case 'draw': {
        final jsonDraw = await Navigator.push(context, MaterialPageRoute(builder: (context) => const DrawScreen()));
        if(jsonDraw != null) {
          setState(() {
            widget.files.add(AppFileDraw(id: Ulid().toString(), name: 'Bản vẽ', pathId: stackId.last, json: jsonDraw, dateCreated: DateTime.now()));
          });
        }
      }

      //----------------------file-------------------
      case 'file': {
        try {
          FilePickerResult? result = await FilePicker.platform.pickFiles();

          if (result != null && result.files.single.path != null) {
            String filePath = result.files.single.path!;
            final fileName = p.basename(filePath);

            setState(() {
              widget.files.add(AppFileSystem(
                  id: Ulid().toString(),
                  name: fileName,
                  pathId: stackId.last,
                  filePath: filePath,
                  dateCreated: DateTime.now())
              );
            });
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      //----------------------quiz------------------
      case 'quiz': {
        try {
          final name = await showInputDialog(
              context: context,
              title: 'Thêm bài tập',
              hint: 'Nhập tên bài tập'
          );
          if (name != null && name.isNotEmpty) {
            final newFile = AppFileQuiz(
                id: Ulid().toString(),
                name: name,
                pathId: stackId.last,
                dateCreated: DateTime.now()
            );
            setState(() {
              widget.files.add(newFile);
            });
            if (context.mounted) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                      QuizManageScreen(
                        name: name,
                        onSave: (newJson) {
                          newFile.json = newJson;
                        },
                      )
              ));
            }
          }
        }
        catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Tên folder hiện tại - - - - - - ------------------------------
          stackId.length > 1
              ? Row(children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      setState(() {
                        stackId.removeLast();
                      });
                    },
                  ),
                  Text(currentFolder!.name)
                ])
              : const SizedBox.shrink(),

          /// Danh sách item  ---------------------------------------------------
          Expanded(
            child: widget.files.isEmpty
                ? Center(child: Text(globalLanguage.noData))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    itemCount: widget.files.length,
                    itemBuilder: (context, index) {
                      final file = widget.files[index];
                      if (file.pathId != stackId.last) {
                        return const SizedBox.shrink();
                      }

                      if (widget.itemBuilder != null) {
                        return widget.itemBuilder!(context, file);
                      }

                      Icon leadingIcon;
                      Color iconColor;

                      if (file is AppFileFolder) {
                        leadingIcon = Icon(Icons.folder, color: Colors.amber[700]);
                        iconColor = Colors.amber;
                      } else if (file is AppFileTxt) {
                        leadingIcon = Icon(Icons.description, color: Colors.blue[700]);
                        iconColor = Colors.blue;
                      } else if (file is AppFileDraw) {
                        leadingIcon = Icon(Icons.draw, color: Colors.yellow[700]);
                        iconColor = Colors.yellow;
                      } else if (file is AppFileQuiz) {
                        leadingIcon = Icon(Icons.quiz, color: Colors.green[700]);
                        iconColor = Colors.green;
                      } else {
                        leadingIcon = Icon(Icons.insert_drive_file, color: Colors.grey[600]);
                        iconColor = Colors.grey;
                      }

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: leadingIcon,
                          title: Text(
                            file.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          /// Nút thao tác item ----------------------------------------------
                          trailing: WdgPopupMenu(
                              items: [
                                MenuItem('Đổi tên', Icons.edit, () async {
                                  final name = await showInputDialog(context: context, title: 'Đổi tên', initialValue: file.name);
                                  setState(() {
                                    if(name != null && name.isNotEmpty) {
                                      file.name = name;
                                    }
                                  });
                                }),
                                MenuItem('Xóa', Icons.delete, () async {
                                  setState(() {
                                    widget.files.remove(file);
                                  });
                                }),
                              ],
                            child: Icon(Icons.more_vert, color: iconColor),
                          ),
                          onTap: () {
                            _open(file);
                          },
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 12),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.black.withValues(alpha: 0.05),
          blur: 5,
        ),
        children: [
          /// Thêm thư mục ----------------------------------------------------
          FloatingActionButton.small(
            child: const Icon(Icons.folder),
            onPressed: () {
              _add(context, 'folder');
            },
          ),

          if(widget.isTheory)
          /// Thêm tài liệu văn bản ----------------------------------------------
          FloatingActionButton.small(
            child: const Icon(Icons.description),
            onPressed: () {
              _add(context, 'txt');
            },
          ),

          if(widget.isTheory)
          /// Thêm bản vẽ ----------------------------------------------
          FloatingActionButton.small(
            child: const Icon(Icons.draw),
            onPressed: () {
              _add(context, 'draw');
            },
          ),

          if(widget.isTheory)
          /// Thêm file ----------------------------------------------------------
          FloatingActionButton.small(
            child: const Icon(Icons.insert_drive_file),
            onPressed: () {
              _add(context, 'file');
            },
          ),

          if(!widget.isTheory)
          /// Thêm quiz  ----------------------------------------------------------
            FloatingActionButton.small(
              child: const Icon(Icons.quiz),
              onPressed: () {
                _add(context, 'quiz');
              },
            ),
        ],
      ),
    );
  }
}

/// Menu Quiz ----------------------------------------------------------------------
class _MenuQuiz extends StatelessWidget {
  final AppFileQuiz fileQuiz;
  const _MenuQuiz(this.fileQuiz);

  @override
  Widget build(BuildContext context) {
    return WdgScaleDialog(
      border: true,
      shadow: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => QuizManageScreen(
                      name: fileQuiz.name,
                      json: fileQuiz.json,
                      onSave: (newJson) {
                        fileQuiz.json = newJson;
                      },
                    )
                ));
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Chỉnh sửa',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () {
                if(fileQuiz.json != null) {
                  navigateToNextScreen(context, QuizScreen.review(jsonQuiz: fileQuiz.json!));
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bắt đầu chơi',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.play_circle_outlined),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
