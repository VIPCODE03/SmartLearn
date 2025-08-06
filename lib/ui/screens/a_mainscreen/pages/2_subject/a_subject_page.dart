import 'package:flutter/cupertino.dart';
import 'package:smart_learn/core/feature_widgets/app_widget_provider.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appWidget.subject.subjectScreen();
  }
}