import 'package:flutter/material.dart';
import 'package:smart_learn/data/models/subject/a_subject.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/widgets/file_tree_widget.dart';

class DetailSubjectScreen extends StatefulWidget {
  final Subject subject;

  const DetailSubjectScreen({super.key, required this.subject});

  @override
  State<StatefulWidget> createState() => _DetaiSubjectScreenState();
}

class _DetaiSubjectScreenState extends State<DetailSubjectScreen> {
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
                    WdgFileTree(files: widget.subject.theories ?? [], isTheory: true,),

                    WdgFileTree(files: widget.subject.exercises ?? [], isTheory: false),

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
