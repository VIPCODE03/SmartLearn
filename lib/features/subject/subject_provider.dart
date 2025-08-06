import 'package:flutter/material.dart';
import 'package:smart_learn/features/subject/presentation/screen/subject_screen.dart';

abstract class ISubjectWidget {
  Widget subjectScreen();
}

abstract class ISubjectRouter {
}

class _SubjectWidget implements ISubjectWidget {
  static final _SubjectWidget _singleton = _SubjectWidget._internal();
  _SubjectWidget._internal();
  static _SubjectWidget get instance => _singleton;

  @override
  Widget subjectScreen() => const SCRSubject();
}

class _SubjectRouter implements ISubjectRouter {
  static final _SubjectRouter _singleton = _SubjectRouter._internal();
  _SubjectRouter._internal();
  static _SubjectRouter get instance => _singleton;
}

class SubjectProvider {
  static final SubjectProvider _singleton = SubjectProvider._internal();
  SubjectProvider._internal();
  static SubjectProvider get instance => _singleton;

  ISubjectWidget get widget => _SubjectWidget.instance;
  ISubjectRouter get router => _SubjectRouter.instance;
}
