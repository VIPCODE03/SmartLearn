
import 'package:smart_learn/languages/a_global_language.dart';

class ViLanguage extends GlobalLanguage {
  @override
  String get picture => 'Máy ảnh';

  @override
  String get pictureDesc => 'AI trợ giúp bạn các câu hỏi trong hình ảnh.';

  @override
  String get text => 'Văn bản';

  @override
  String get textDesc => 'AI trợ giúp bạn các câu hỏi bằng văn bản.';

  @override
  String get tab1 => 'AI';

  @override
  String get tab2 => 'Môn học';

  @override
  String get tab3 => 'Thời khóa biểu';

  @override
  String get tab4 => 'Cá nhân';

  @override
  String get hintQuestion => 'Nhập câu hỏi của bạn..';

  @override
  String get next => 'Tiếp';

  @override
  String get history => 'Lịch sử';

  @override
  String get error => 'Đã xảy ra lỗi';

  @override
  String get solution => 'Lời giải';

  @override
  String get lastStudyDate => 'Lần học cuối';

  @override
  String get good => 'Tốt';

  @override
  String get quiteGood => 'Khá';

  @override
  String get average => 'Trung bình';

  @override
  String get poor => 'Kém';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get filter => 'Lọc';

  @override
  String get arrange => 'Sắp xếp';

  @override
  String get name => 'Tên';

  @override
  String get noData => 'Không có dữ liệu';

  @override
  String get previous => 'Trước';
}