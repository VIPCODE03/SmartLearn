import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:open_filex/open_filex.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/widgets/textfeild_widget.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/core/link/routers/app_router.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';
import 'package:smart_learn/features/file/domain/parameters/create_params.dart';
import 'package:smart_learn/features/file/domain/parameters/file_params.dart';
import 'package:smart_learn/features/file/domain/parameters/load_params.dart';
import 'package:smart_learn/features/file/domain/parameters/update_params.dart';
import 'package:smart_learn/features/file/presentation/libraries/flutter_drawing_custom/draw_screen.dart';
import 'package:smart_learn/features/file/presentation/libraries/text_quill/text_editor_screen.dart';
import 'package:smart_learn/features/file/presentation/mappers/appfile_ui.dart';
import 'package:smart_learn/features/file/presentation/state_manages/appfile_bloc/bloc.dart';
import 'package:smart_learn/features/file/presentation/state_manages/appfile_bloc/events.dart';
import 'package:smart_learn/features/file/presentation/state_manages/appfile_bloc/states.dart';
import 'package:smart_learn/app/services/storage_service.dart';
import 'package:smart_learn/app/ui/dialogs/app_bottom_sheet.dart';
import 'package:smart_learn/app/ui/snackbars/app_snackbar.dart';
import 'package:smart_learn/app/ui/widgets/loading_widget.dart';
import 'package:smart_learn/app/ui/widgets/popup_menu_widget.dart';
import 'package:path/path.dart' as p;

enum SupportType {
  folder, txt, draw, quiz, system, flashcard
}

class SCRAppFile extends StatefulWidget {
  /// Đường dẫn gốc
  final String subjectId;
  /// Phân ổ
  final String partition;
  /// Danh sách loại file hỗ trợ
  final List<SupportType> supportTypes;
  /// Sự kiện quay lại
  final Function(VoidCallback backFolder)? onBackFolder;
  final Function(bool isRoot)? onRootChanged;

  const SCRAppFile({
    super.key,
    required this.subjectId,
    required this.partition,
    required this.supportTypes,
    this.onRootChanged,
    this.onBackFolder,
  });

  @override
  State<StatefulWidget> createState() => _SCRAppFileState();
}

class _SCRAppFileState extends State<SCRAppFile> with AppRouterMixin, AutomaticKeepAliveClientMixin {
  late final FileExtenalValue fileExtenal;
  final _key = GlobalKey<ExpandableFabState>();
  late final AppFileBloc bloc;

  @override
  initState() {
    super.initState();
    fileExtenal = FileExtenalValue(subjectId: widget.subjectId, partition: widget.partition);
    bloc = AppFileBloc(create: getIt(), delete: getIt(), update: getIt(), load: getIt())
      ..add(AppFileLoadEvent(
          params: AppFileLoadParams(
              fileExtenal,
              pathId: 'root'
          ))
      );

    if(widget.onBackFolder != null) {
      widget.onBackFolder!(goBackFolder);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final color = context.style.color;

    return BlocProvider<AppFileBloc>.value(
      value: bloc,
      child: Scaffold(
          body: BlocListener<AppFileBloc, AppFileState>(
              listener: (context, state) {
                if (state is AppFileCreated || state is AppFileUpdated) {
                  showAppSnackbar(context, globalLanguage.updated, type: SnackbarType.success);
                }

                if (state is AppFileDeleted) {
                  showAppSnackbar(context, globalLanguage.deleted, type: SnackbarType.success);
                }

                if (state is AppFileError) {
                  showAppSnackbar(context, state.message, type: SnackbarType.error);
                }
              },
              child: BlocBuilder<AppFileBloc, AppFileState>(
                builder: (context, state) {
                  final bloc = context.read<AppFileBloc>();
                  if(widget.onRootChanged != null) {
                    widget.onRootChanged!(bloc.isRoot);
                  }

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
                        ///-  PHẦN THÔNG TIN THƯ MỤC  -------------------------------------------
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
                                          params: AppFileLoadParams(fileExtenal, pathId: folder['pathId'] as String)
                                      ),
                                    );
                                  },
                                  child: nameFolder.isEmpty
                                      ? Icon(Icons.home, size: 16, color: color.primaryColor)
                                      : Text(nameFolder,
                                      style: TextStyle(
                                        fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                                        color: isLast ? color.primaryColor : Colors.grey,
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

                        ///-  DANH SÁCH ITEM  ---------------------------------------------------
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
                                      MenuItem(globalLanguage.rename, Icons.edit, () {
                                        _showEditName(context, globalLanguage.rename, file.name, (newName) {
                                          bloc.add(AppFileUpdateEvent(AppFileUpdateParams.rename(file, name: newName)));
                                        });
                                      }),
                                      MenuItem(globalLanguage.delete, Icons.delete, () async {
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

                  return Center(child: Text(globalLanguage.error));
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

  //--------- Hàm mở rộng --------------------------------------------------
  void goBackFolder() {
    bloc.add(AppFileBackFolder());
  }

  //---------------- Mở file --------------------------------
  Future<void> _open(BuildContext context ,ENTAppFile file) async {
    //------------------ file -------------------------
    if(file is ENTAppFileSystem) {
      try {
        final OpenResult result = await OpenFilex.open(file.filePath);

        if (result.type != ResultType.done) {
          if(context.mounted) {
            showAppSnackbar(context, globalLanguage.error, type: SnackbarType.error);
          }
        }
      } catch (e) {
        if(context.mounted) {
          showAppSnackbar(context, globalLanguage.error, type: SnackbarType.error);
        }
        debugPrint(e.toString());
      }
    }

    //--------------------------- draw ------------------------
    else if(file is ENTAppFileDraw) {
      final newJson = await pushSlideLeft(context, DrawScreen(json: file.json));
      if(newJson != null) bloc.add(AppFileUpdateEvent(AppFileUpdateParams.draw(file, json: newJson)));
    }

    //----------------- folder -------------------------
    else if(file is ENTAppFileFolder) {
      bloc.add(AppFileLoadEvent(nameFolder: file.name, params: AppFileLoadParams(fileExtenal, pathId: file.id)));
    }

    //------------------- txt ----------------------------
    else if(file is ENTAppFileTxt) {
      final newJson = await pushSlideLeft(context, TextEditorScreen(json: file.content));
      if(newJson != null) bloc.add(AppFileUpdateEvent(AppFileUpdateParams.txt(file, content: newJson)));
    }

    //------------------- quiz ----------------------------
    else if(file is ENTAppFileQuiz) {
      appRouter.quiz.goQuizByFileId(context, fileId: file.id);
    }

    //-----------------flashcard----------------------------
    else if(file is ENTAppFileFlashCard) {
      appRouter.flashCard.goFlashCardByFile(context, file.id);
    }
  }

  //----------------- Thêm file -----------------------------
  Future<void> _add(BuildContext context, SupportType type, String pathId) async {
    final state = _key.currentState;
    if (state != null) {
      state.toggle();
    }
    try {
      switch(type) {
      //----------------folder---------------
        case SupportType.folder: {
          _showEditName(context, globalLanguage.folder, '', (name) {
            bloc.add(AppFileCreateEvent(AppFileCreateParams.folder(fileExtenal, name: name, pathId: pathId)));
          });
          break;
        }

      //-------------------- txt ----------------
        case SupportType.txt: {
          if (!context.mounted) return;

          _showEditName(context, globalLanguage.note, '', (name) {
            bloc.add(AppFileCreateEvent(AppFileCreateParams.txt(fileExtenal, name: name, pathId: pathId)));
          });
          break;
        }


      //--------------------- draw -----------------
        case SupportType.draw: {
          if (!context.mounted) return;

          _showEditName(context, globalLanguage.draw, '', (name) {
            bloc.add(AppFileCreateEvent(AppFileCreateParams.draw(fileExtenal, name: name, pathId: pathId)));
          });
          break;
        }

      //----------------------file-------------------
        case SupportType.system: {
          final filePath = await AppStorageService.pickAndSaveAnyFileToAppDir(folderName: 'appfilesystem');

          if (filePath != null) {
            final fileName = p.basename(filePath);
            if (context.mounted) {
              bloc.add(AppFileCreateEvent(AppFileCreateParams.system(fileExtenal, name: fileName, pathId: pathId, filePath: filePath)));
            }
          }
        }

      //----------------------quiz------------------
        case SupportType.quiz: {
          if (!context.mounted) return;

          _showEditName(context, globalLanguage.quiz, '', (name) {
            bloc.add(AppFileCreateEvent(AppFileCreateParams.quiz(fileExtenal, name: name, pathId: pathId)));
          });
          break;
        }

        case SupportType.flashcard: {
          if (!context.mounted) return;

          _showEditName(context, globalLanguage.flashCard, '', (name) {
            bloc.add(AppFileCreateEvent(AppFileCreateParams.flashcard(fileExtenal, name: name, pathId: pathId)));
          });
          break;
        }
      }
    } catch (e) {
      if(context.mounted) {
        showAppSnackbar(context, globalLanguage.error, type: SnackbarType.error);
      }
      debugPrint(e.toString());
    }
  }

  ///-  BOTTOM SHEET EDIT TÊN --------------------------------------------------
  void _showEditName(BuildContext context, String title, String? name, Function(String name) onEdit) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    if (name != null) {
      nameController.text = name;
    }
    final FocusNode focusNode = FocusNode()..requestFocus();
    showAppConfirmBottomSheet(
        context: context,
        title: title,
        onConfirm: () {
          if (formKey.currentState!.validate()) {
            onEdit(nameController.text.trim());
            Navigator.pop(context);
          }
        },
        child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  focusNode: focusNode,
                  controller: nameController,
                  maxLines: 1,
                  decoration: inputDecoration(context: context, hintText: globalLanguage.name),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return globalLanguage.pleaseEnterName;
                    }
                    return null;
                  },
                ),
              ]
            )
        )
    );
  }

  ///-  ITEM KIỂU --------------------------------------------------------------
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
            border: Border.all(color: color.withAlpha(100))
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

  ///-  BOTTOM SHEET CHỌN KIỂU  ------------------------------------------------
  void _showSelectType(BuildContext context) {
    showAppBottomSheet(
        context: context,
        title: globalLanguage.chooseTypeFile,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _itemType(icon: Icons.folder, name: globalLanguage.folder, subName: globalLanguage.subFolder, color: Colors.yellow,
                onTap: () => _add(context, SupportType.folder, bloc.stackFolder.last['pathId']!)
            ),

            if (widget.supportTypes.contains(SupportType.txt))
              _itemType(icon: Icons.description, name: globalLanguage.note, subName: globalLanguage.subNote, color: Colors.blue,
                  onTap: () => _add(context, SupportType.txt, bloc.stackFolder.last['pathId']!)
              ),

            if (widget.supportTypes.contains(SupportType.draw))
              _itemType(icon: Icons.draw, name: globalLanguage.draw, subName: globalLanguage.subDraw, color: Colors.orange,
                  onTap: () => _add(context, SupportType.draw, bloc.stackFolder.last['pathId']!)
              ),

            if (widget.supportTypes.contains(SupportType.system))
              _itemType(icon: Icons.insert_drive_file, name: globalLanguage.fileSystem, subName: globalLanguage.subFileSystem, color: Colors.grey,
                  onTap: () => _add(context, SupportType.system, bloc.stackFolder.last['pathId']!)
              ),

            if (widget.supportTypes.contains(SupportType.quiz))
              _itemType(icon: Icons.quiz, name: globalLanguage.quiz, subName: globalLanguage.subQuiz, color: Colors.green,
                  onTap: () => _add(context, SupportType.quiz, bloc.stackFolder.last['pathId']!)
              ),

            if (widget.supportTypes.contains(SupportType.flashcard))
              _itemType(icon: Icons.style, name: globalLanguage.flashCard, subName: globalLanguage.subFlashCard, color: Colors.brown,
                  onTap: () => _add(context, SupportType.flashcard, bloc.stackFolder.last['pathId']!)
              ),
          ]
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
