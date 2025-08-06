import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:open_filex/open_filex.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/core/router/app_router.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';
import 'package:smart_learn/features/file/domain/parameters/create_params.dart';
import 'package:smart_learn/features/file/domain/parameters/file_params.dart';
import 'package:smart_learn/features/file/domain/parameters/load_params.dart';
import 'package:smart_learn/features/file/domain/parameters/update_params.dart';
import 'package:smart_learn/features/file/presentation/mappers/appfile_ui.dart';
import 'package:smart_learn/features/file/presentation/state_manages/appfile_bloc/bloc.dart';
import 'package:smart_learn/features/file/presentation/state_manages/appfile_bloc/events.dart';
import 'package:smart_learn/features/file/presentation/state_manages/appfile_bloc/states.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/libraries/flutter_drawing_custom/draw_screen.dart';
import 'package:smart_learn/libraries/text_quill/text_editor_screen.dart';
import 'package:smart_learn/services/storage_service.dart';
import 'package:smart_learn/ui/dialogs/app_bottom_sheet.dart';
import 'package:smart_learn/ui/dialogs/dialog_textfiled.dart';
import 'package:smart_learn/ui/dialogs/scale_dialog.dart';
import 'package:smart_learn/ui/snackbars/app_snackbar.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';
import 'package:smart_learn/ui/widgets/popup_menu_widget.dart';
import 'package:path/path.dart' as p;

enum SupportType {
  folder, txt, draw, quiz, system
}

class SCRAppFile extends StatefulWidget {
  /// Đường dẫn gốc
  final String subjectId;
  final String pathRoot;
  /// Danh sách loại file hỗ trợ
  final List<SupportType> supportTypes;

  const SCRAppFile({super.key, required this.subjectId, required this.pathRoot, required this.supportTypes});

  @override
  State<StatefulWidget> createState() => _SCRAppFileState();
}

class _SCRAppFileState extends State<SCRAppFile> {
  final _key = GlobalKey<ExpandableFabState>();
  late final AppFileBloc bloc;

  @override
  initState() {
    super.initState();
    bloc = AppFileBloc(create: getIt(), delete: getIt(), update: getIt(), load: getIt())
      ..add(AppFileLoadEvent(
          params: AppFileLoadParams(
              FileForeignParams(subjectId: widget.subjectId),
              pathId: widget.pathRoot
          ))
      );
  }

  //---------------- Mở file --------------------------------
  Future<void> _open(BuildContext context ,ENTAppFile file) async {
    //------------------ file -------------------------
    if(file is ENTAppFileSystem) {
      try {
        final OpenResult result = await OpenFilex.open(file.filePath);

        if (result.type != ResultType.done) {
          if(context.mounted) {
            showAppSnackbar(context, 'Có lỗi xảy ra', type: SnackbarType.error);
          }
        }
      } catch (e) {
        if(context.mounted) {
          showAppSnackbar(context, 'Có lỗi xảy ra', type: SnackbarType.error);
        }
        debugPrint(e.toString());
      }
    }

    //--------------------------- draw ------------------------
    else if(file is ENTAppFileDraw) {
      final newJson = await Navigator.push(context, MaterialPageRoute(builder: (context) => DrawScreen(json: file.json)));
      if(newJson != null) bloc.add(AppFileUpdateEvent(AppFileUpdateParams.draw(file, json: newJson)));
    }

    //----------------- folder -------------------------
    else if(file is ENTAppFileFolder) {
      bloc.add(AppFileLoadEvent(nameFolder: file.name, params: AppFileLoadParams(FileForeignParams(subjectId: widget.subjectId), pathId: file.id)));
    }

    //------------------- txt ----------------------------
    else if(file is ENTAppFileTxt) {
      final newJson = await Navigator.push(context, MaterialPageRoute(builder: (context) => TextEditorScreen(json: file.content)));
      if(newJson != null) bloc.add(AppFileUpdateEvent(AppFileUpdateParams.txt(file, content: newJson)));
    }

    //------------------- quiz ----------------------------
    else if(file is ENTAppFileQuiz) {
      showDialog(context: context, builder: (context) {
        return _MenuQuiz(file, bloc);
      });
    }
  }

  //----------------- Thêm file -----------------------------
  Future<void> _add(BuildContext context, SupportType type, String pathId) async {
    final state = _key.currentState;
    if (state != null) {
      state.toggle();
    }
    final String? name;
    try {
      switch(type) {
      //----------------folder---------------
        case SupportType.folder: {
          name = await showInputDialog(
              context: context,
              title: 'Thêm thư mục',
              hint: 'Nhập tên thư mục'
          );
          if(name != null && name.isNotEmpty) {
            bloc.add(AppFileCreateEvent(AppFileCreateParams.folder(FileForeignParams(subjectId: widget.subjectId), name: name, pathId: pathId)));
          }
          break;
        }

      //-------------------- txt ----------------
        case SupportType.txt: {
          if (!context.mounted) return;

          final name = await showInputDialog(
            context: context,
            title: 'Thêm ghi chú',
            hint: 'Nhập tên ghi chú',
          );

          if (name != null) {
            bloc.add(AppFileCreateEvent(AppFileCreateParams.txt(FileForeignParams(subjectId: widget.subjectId), name: name, pathId: pathId)));
          }
          break;
        }


      //--------------------- draw -----------------
        case SupportType.draw: {
          if (!context.mounted) return;

          final name = await showInputDialog(
            context: context,
            title: 'Thêm bản vẽ',
            hint: 'Nhập tên bản vẽ',
          );
          if(name != null) {
            bloc.add(AppFileCreateEvent(AppFileCreateParams.draw(FileForeignParams(subjectId: widget.subjectId), name: name, pathId: pathId)));
          }
          break;
        }

      //----------------------file-------------------
        case SupportType.system: {
          final filePath = await LocalStorageService.pickAndSaveAnyFileToAppDir(folderName: 'appfilesystem');

          if (filePath != null) {
            final fileName = p.basename(filePath);
            if (context.mounted) {
              bloc.add(AppFileCreateEvent(AppFileCreateParams.system(FileForeignParams(subjectId: widget.subjectId), name: fileName, pathId: pathId, filePath: filePath)));
            }
          }
        }

      //----------------------quiz------------------
        case SupportType.quiz: {
          final name = await showInputDialog(
              context: context,
              title: 'Thêm bài tập',
              hint: 'Nhập tên bài tập');
          if (name != null) {
            bloc.add(AppFileCreateEvent(AppFileCreateParams.quiz(FileForeignParams(subjectId: widget.subjectId), name: name, pathId: pathId)));
          }
        }
      }
    } catch (e) {
      if(context.mounted) {
        showAppSnackbar(context, 'Có lỗi xảy ra', type: SnackbarType.error);
      }
      debugPrint(e.toString());
    }
  }

  Widget _itemType({
    required IconData icon,
    required String name,
    required String subName,
    required Color color,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: color.withAlpha(10),
            border: Border.all(color: color.withAlpha(50))
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 8),
                  Expanded(child: Text(name, style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700
                  )))
                ],
              ),

              const SizedBox(height: 4),

              Text(subName, style: const TextStyle(color: Colors.grey))
            ]
        ),
      )
    );
  }

  void _showSelectType(BuildContext context) {
    showAppBottomSheet(
        context: context,
        title: 'Chọn kiểu',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _itemType(icon: Icons.folder, name: 'Thư mục', subName: 'Thêm thư mục', color: Colors.yellow,
                onTap: () => _add(context, SupportType.folder, bloc.stackFolder.last['pathId']!)
            ),

            if (widget.supportTypes.contains(SupportType.txt))
              _itemType(icon: Icons.description, name: 'Ghi chú', subName: 'Thêm ghi chú', color: Colors.blue,
                  onTap: () => _add(context, SupportType.txt, bloc.stackFolder.last['pathId']!)
              ),

            if (widget.supportTypes.contains(SupportType.draw))
              _itemType(icon: Icons.draw, name: 'Bản vẽ', subName: 'Thêm bản vẽ', color: Colors.orange,
                  onTap: () => _add(context, SupportType.draw, bloc.stackFolder.last['pathId']!)
              ),

            if (widget.supportTypes.contains(SupportType.system))
              _itemType(icon: Icons.insert_drive_file, name: 'File', subName: 'Chọn file từ hệ thống', color: Colors.grey,
                  onTap: () => _add(context, SupportType.system, bloc.stackFolder.last['pathId']!)
              ),

            if (widget.supportTypes.contains(SupportType.quiz))
              _itemType(icon: Icons.quiz, name: 'Bài tập', subName: 'Thêm bài tập', color: Colors.green,
                  onTap: () => _add(context, SupportType.quiz, bloc.stackFolder.last['pathId']!)
              ),
          ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppFileBloc>.value(
      value: bloc,
      child: Scaffold(
        body: BlocListener<AppFileBloc, AppFileState>(
          listener: (context, state) {
            if (state is AppFileCreated || state is AppFileUpdated) {
              showAppSnackbar(context, 'Đã cập nhật', type: SnackbarType.success);
            }

            if (state is AppFileDeleted) {
              showAppSnackbar(context, 'Đã xóa', type: SnackbarType.success);
            }

            if (state is AppFileError) {
              showAppSnackbar(context, state.message, type: SnackbarType.error);
            }
          },
          child: BlocBuilder<AppFileBloc, AppFileState>(
            builder: (context, state) {
              final bloc = context.read<AppFileBloc>();

              if (state is AppFileLoading) {
                return const Center(child: WdgLoading());
              }

              if (state is AppFileLoadError) {
                return Center(child: Text(state.message));
              }

              if (state is AppFileHasData) {
                final files = state.files;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: List.generate(state.stackFolder.length, (index) {
                        final folder = state.stackFolder[index];
                        final nameFolder = folder['nameFolder'] as String;
                        final isLast = index == state.stackFolder.length - 1;

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                bloc.add(
                                  AppFileLoadEvent(
                                    nameFolder: nameFolder,
                                    params: AppFileLoadParams(FileForeignParams(subjectId: widget.subjectId), pathId: folder['pathId'] as String)
                                  ),
                                );
                              },
                              child: nameFolder.isEmpty
                                  ? Icon(Icons.home,
                                  size: 16,
                                  color: primaryColor(context,
                                  ))
                                  : Text(
                                  nameFolder,
                                  style: TextStyle(
                                    fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                                    color: isLast ? primaryColor(context) : Colors.grey,
                                  )
                              ),
                            ),
                            if (!isLast)
                              const Text(
                                '  /  ',
                                style: TextStyle(color: Colors.grey),
                              ),
                          ],
                        );
                      }),
                    ),

                    Expanded(
                      child: files.isEmpty
                          ? Center(child: Text(globalLanguage.noData))
                          : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final file = files[index];

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: Icon(file.iconData, color: file.iconColor.withAlpha(180)),
                              title: Text(
                                file.name,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              trailing: kIsWeb ? null : WdgPopupMenu(
                                items: [
                                  MenuItem('Đổi tên', Icons.edit, () async {
                                    final name = await showInputDialog(
                                        context: context, title: 'Đổi tên', initialValue: file.name);
                                    if (name != null) {
                                      bloc.add(AppFileUpdateEvent(AppFileUpdateParams.rename(file, name: name)));
                                    }
                                  }),
                                  MenuItem('Xóa', Icons.delete, () async {
                                    bloc.add(AppFileDeleteEvent(file: file));
                                  }),
                                ],
                                child: Icon(Icons.more_vert, color: file.iconColor),
                              ),
                              onTap: () {
                                _open(context, file);
                              },
                              contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              }

              return const Center(child: Text('Error'));
            },
          )
      ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showSelectType(context);
          },
          child: const Icon(Icons.add),
        )
      ),
    );
  }
}

/// Menu Quiz ----------------------------------------------------------------------
class _MenuQuiz extends StatelessWidget {
  final ENTAppFileQuiz fileQuiz;
  final AppFileBloc bloc;
  const _MenuQuiz(this.fileQuiz, this.bloc);

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
                  appRouter.quiz.goQuizFileManage(context, fileId: fileQuiz.id, title: fileQuiz.name);
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
                  appRouter.quiz.goQuizPlayById(context, fileId: fileQuiz.id);
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
