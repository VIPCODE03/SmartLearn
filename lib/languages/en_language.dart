import 'package:smart_learn/languages/a_global_language.dart';

class EnLanguage extends GlobalLanguage {
  @override
  String get picture => 'Camera';

  @override
  String get pictureDesc => 'AI helps you with questions related to images.';

  @override
  String get text => 'Text';

  @override
  String get textDesc => 'AI helps you with questions based on text.';

  @override
  String get tab1 => 'AI';

  @override
  String get tab2 => 'Subjects';

  @override
  String get tab3 => 'Timetable';

  @override
  String get tab4 => 'Profile';

  @override
  String get hintQuestion => 'Enter your question..';

  @override
  String get next => 'Next';

  @override
  String get history => 'History';

  @override
  String get error => 'An error has occurred';

  @override
  String get solution => 'Solution';

  @override
  String get lastStudyDate => 'Last study day';

  @override
  String get good => 'Good';

  @override
  String get quiteGood => 'Quite Good';

  @override
  String get average => 'Average';

  @override
  String get poor => 'Poor';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get arrange => 'Arrange';

  @override
  String get name => 'Name';

  @override
  String get noData => 'No data';

  @override
  String get previous => 'Previous';
}
