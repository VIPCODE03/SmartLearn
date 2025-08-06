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

class _DetaiSubjectScreenState extends State<SCRSubjectDetail> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                    children: [
                      appWidget.file.fileView(subjectId: widget.subject.id, pathRoot: 'theory', supportTypes: [
                        'folder', 'txt', 'draw', 'system'
                      ]),

                      appWidget.file.fileView(subjectId: widget.subject.id, pathRoot: 'exercise', supportTypes: [
                        'folder', 'quiz'
                      ]),

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
    );
  }
}
