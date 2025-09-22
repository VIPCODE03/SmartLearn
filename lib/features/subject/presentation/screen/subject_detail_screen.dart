import 'package:flutter/material.dart';
import 'package:performer/performer_build.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/dialogs/app_bottom_sheet.dart';
import 'package:smart_learn/app/ui/dialogs/scale_dialog.dart';
import 'package:smart_learn/app/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/app/ui/widgets/textfeild_widget.dart';
import 'package:smart_learn/core/feature_widgets/app_widget_provider.dart';
import 'package:smart_learn/features/subject/constants/education_levels.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';
import 'package:smart_learn/features/subject/domain/usecases/subject_update_usecase.dart';
import 'package:smart_learn/features/subject/presentation/state_manages/subject_performer/subject_action.dart';
import 'package:smart_learn/features/subject/presentation/state_manages/subject_performer/subject_performer.dart';

class SCRSubjectDetail extends StatelessWidget {
  final ENTSubject subject;
  final SubjectPerformer performer;
  const SCRSubjectDetail({super.key, required this.subject, required this.performer});

  @override
  Widget build(BuildContext context) {
    return PerformerProvider.external(
      performer: performer,
      child: PerformerBuilder<SubjectPerformer>(builder: (context, performer) {
        final subjectState = performer.current.subjects.where(
              (element) => element.id == subject.id,
        );

        if (subjectState.isEmpty) {
          return const SizedBox.shrink();
        }

        return _SCRSubjectDetail(subject: subjectState.first, performer: performer);
      })
    );
  }
}

class _SCRSubjectDetail extends StatefulWidget {
  final ENTSubject subject;
  final SubjectPerformer performer;
  const _SCRSubjectDetail({required this.subject, required this.performer});

  @override
  State<StatefulWidget> createState() => _DetaiSubjectScreenState();
}

class _DetaiSubjectScreenState extends State<_SCRSubjectDetail> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late VoidCallback? _theoryBackHandler;
  late VoidCallback? _exerciseBackHandler;
  bool _theoryRoot = true;
  bool _exerciseRoot = true;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          final index = _tabController.index;

          if (index == 0) {
            if (_theoryRoot) {
              Navigator.pop(context);
            } else {
              _theoryBackHandler?.call();
            }
          } else if (index == 1) {
            if (_exerciseRoot) {
              Navigator.pop(context);
            } else {
              _exerciseBackHandler?.call();
            }
          } else {
            Navigator.pop(context);
          }
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.design_services),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                widget.subject.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: context.style.color.primaryColor,
                indicatorColor: context.style.color.primaryColor,
                tabs: const [
                  Tab(text: 'Lý thuyết'),
                  Tab(text: 'Bài tập'),
                ],
              ),
              actions: [
                WdgBounceButton(child: const Icon(Icons.settings), onTap: () => _onTabSettings(context)),
                const SizedBox(width: 16),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                    child: Padding(padding: const EdgeInsets.all(16.0),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          appWidget.file.fileView(subjectId: widget.subject.id, partition: 'theory', supportTypes: [
                            'folder', 'txt', 'draw', 'system',
                          ],
                            onBackFolder: (backFolder) => _theoryBackHandler = backFolder,
                            onRootChanged: (isRoot) {
                              _theoryRoot = isRoot;
                            },
                          ),

                          appWidget.file.fileView(subjectId: widget.subject.id, partition: 'exercise', supportTypes: [
                            'folder', 'quiz', 'flashcard'
                          ],
                            onBackFolder: (backFolder) => _exerciseBackHandler = backFolder,
                            onRootChanged: (isRoot) {
                              _exerciseRoot = isRoot;
                            },
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        )
    );
  }
  
  void _onTabSettings(BuildContext context) {
    final subject = widget.subject;
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    nameController.text = subject.name;
    String levelSelected = subject.level;
    bool isHide = subject.isHide;

    showAppConfirmBottomSheet(
      onConfirm: () {
        if (formKey.currentState!.validate()) {
          widget.performer.add(UpdateSubject(SubjectUpdateParams(
            subject,
            name: nameController.text.trim(),
            level: levelSelected,
            isHide: isHide,
          )));
          Navigator.pop(context);
        }
      },
      context: context,
      title: 'Tùy chỉnh',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Tên môn học ----------------------------------------------------
            const SizedBox(height: 10),
            TextFormField(
              controller: nameController,
              maxLines: 1,
              decoration: inputDecoration(context: context, hintText: 'Tên môn học'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tên môn học';
                }
                return null;
              },
            ),

            /// Lớp ------------------------------------------------------------
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: levelSelected,
              decoration: inputDecoration(context: context, hintText: 'Chọn lớp'),
              items: educationLevels.map((level) {
                return DropdownMenuItem<String>(value: level, child: Text(level));
              }).toList(),
              onChanged: (level) {
                levelSelected = level!;
              },
              validator: (value) {
                if (value == null) {
                  return 'Vui lòng chọn lớp';
                }
                return null;
              },
            ),

            /// Chế độ ẩn/hiện  ------------------------------------------------
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(child: Text('Ẩn môn học', style: TextStyle(fontWeight: FontWeight.bold))),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Switch.adaptive(
                      value: isHide,
                      onChanged: (value) {
                        setState(() {
                          isHide = value;
                        });
                      },
                      activeColor: context.style.color.primaryColor,
                    );
                  },
                )
              ],
            ),

            /// Xóa môn học ----------------------------------------------------
            const SizedBox(height: 16),
            WdgBounceButton(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return WdgScaleDialog(
                        shadow: true,
                        border: true,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Xóa môn học?'),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                WdgBounceButton(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                                ),
                                const SizedBox(width: 32),
                                WdgBounceButton(
                                  onTap: () {
                                    widget.performer.add(DeleteSubjectById(subject.id));
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                                )
                              ]
                            )
                          ]
                        ),
                      );
                    }
                );
              },
              child: const Text('Xóa môn học', style: TextStyle(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}
