import 'package:smart_learn/app/languages/language.dart';

class ViLanguage extends AppLanguage {
  @override
  String get picture => 'Máy ảnh';

  @override
  String get pictureDesc => 'AI trợ giúp bạn các câu hỏi trong hình ảnh.';

  @override
  String get text => 'Văn bản';

  @override
  String get textDesc => 'AI trợ giúp bạn các câu hỏi bằng văn bản.';

  @override
  String get tab1 => 'Trang chủ';

  @override
  String get tab2 => 'Môn học';

  @override
  String get tab3 => 'Lịch';

  @override
  String get tab4 => 'Cài đặt';

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
  String get isHide => 'Môn học đã ẩn';

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