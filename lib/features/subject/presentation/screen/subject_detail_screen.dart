import 'package:flutter/material.dart';
import 'package:smart_learn/core/feature_widgets/app_widget_provider.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';
import 'package:smart_learn/global.dart';

class SCRSubjectDetail extends StatefulWidget {
  final ENTSubject subject;
  const SCRSubjectDetail({super.key, required this.subject});

  @override
  State<StatefulWidget> createState() => _DetaiSubjectScreenState();
}

class _DetaiSubjectScreenState extends State<SCRSubjectDetail> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late VoidCallback? _theoryBackHandler;
  late VoidCallback? _exerciseBackHandler;
  bool _theoryRoot = true;
  bool _exerciseRoot = true;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
          length: 3,
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
                labelColor: primaryColor(context),
                indicatorColor: primaryColor(context),
                tabs: const [
                  Tab(text: 'Lý thuyết'),
                  Tab(text: 'Bài tập'),
                  Tab(text: 'Đánh giá',)
                ],
              ),
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

                          Center(
                            child: Text('Đánh giá môn học: ${widget.subject.name}',
                                style: const TextStyle(fontSize: 16)),
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
}
